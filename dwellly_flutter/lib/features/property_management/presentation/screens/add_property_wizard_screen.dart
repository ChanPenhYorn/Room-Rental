import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:dwellly_flutter/core/network/api_client_provider.dart';
import 'package:dwellly_flutter/features/listings/presentation/screens/home_screen.dart';
import 'package:dwellly_flutter/features/listings/presentation/providers/room_provider.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

/// Add Property Wizard Screen
/// A multi-step form for adding a new property listing
class AddPropertyWizardScreen extends ConsumerStatefulWidget {
  const AddPropertyWizardScreen({super.key});

  @override
  ConsumerState<AddPropertyWizardScreen> createState() =>
      _AddPropertyWizardScreenState();
}

class _AddPropertyWizardScreenState
    extends ConsumerState<AddPropertyWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form Data
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  String _propertyType = 'Apartment';
  final List<String> _selectedFacilities = [];
  final List<String> _uploadedImages = [];

  // Static Photos for testing
  final List<String> _staticPhotos = [
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500&q=80',
    'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500&q=80',
    'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=500&q=80',
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500&q=80',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=500&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _autoFillForTesting();
  }

  void _autoFillForTesting() {
    _titleController.text = 'Cozy Modern Apartment';
    _descriptionController.text =
        'A beautiful studio apartment located in the heart of the city. Close to public transport and amenities.';
    _addressController.text = '123 Main St, Downtown';
    _priceController.text = '450.00';
    _depositController.text = '900.00';
    _propertyType = 'Apartment';
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _uploadedImages.addAll(images.map((image) => image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking images: $e')),
        );
      }
    }
  }

  Widget _buildImageProvider(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return Image.network(path, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), fit: BoxFit.cover);
    }
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    } else {
      // Submit
      _submitProperty();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submitProperty() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryGreen),
      ),
    );

    try {
      final client = ref.read(clientProvider);

      final finalImages = <String>[];
      for (final imagePath in _uploadedImages) {
        if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
          finalImages.add(imagePath);
        } else {
          try {
            final file = File(imagePath);
            final bytes = await file.readAsBytes();
            final base64String = base64Encode(bytes);
            final uploadedUrl = await client.room.uploadRoomImage(base64String);
            if (uploadedUrl != null) {
              finalImages.add(uploadedUrl);
            }
          } catch (e) {
            if (mounted) {
              Navigator.pop(context); // Close loading
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to upload image: $e')),
              );
            }
            return;
          }
        }
      }

      final room = Room(
        ownerId: 0, // Server will overwrite with authenticated user's ID
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        location: _addressController.text,
        latitude: 11.5564, // Default Phnom Penh for demo
        longitude: 104.9282,
        rating: 4.5,
        type: _mapPropertyType(_propertyType),
        imageUrl: finalImages.isNotEmpty ? finalImages.first : null,
        images: finalImages,
        isAvailable: true,
        createdAt: DateTime.now(),
        status: RoomStatus.pending,
      );

      final result = await client.room.createRoom(room);

      if (mounted) {
        Navigator.pop(context); // Close loading

        if (result != null) {
          // Refresh all listing caches so the dashboard shows the new pending room
          ref.invalidate(roomListProvider);
          ref.invalidate(pendingRoomsProvider);
          ref.invalidate(myRoomsProvider);

          // Show Success Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => PropertySuccessScreen(room: result),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Submission failed. Please try again.',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  RoomType _mapPropertyType(String type) {
    switch (type.toLowerCase()) {
      case 'apartment':
        return RoomType.apartment1br;
      case 'house':
        return RoomType.house;
      case 'villa':
        return RoomType.villa;
      case 'condo':
        return RoomType.condo;
      case 'dormitory':
        return RoomType.dormitory;
      default:
        return RoomType.apartment1br;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
          onPressed: _previousStep,
        ),
        title: Text(
          'List Your Property',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: AppTheme.dividerGray,
            color: AppTheme.primaryGreen,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: [
          _buildStep1BasicInfo(),
          _buildStep2Photos(),
          _buildStep3Facilities(),
          _buildStep4Pricing(),
          _buildStep5Review(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppTheme.dividerGray),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentStep == _totalSteps - 1 ? 'Submit Listing' : 'Next',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Basic Info
  Widget _buildStep1BasicInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about your property',
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppTheme.secondaryGray,
            ),
          ),
          const SizedBox(height: 32),

          _buildTextField(
            controller: _titleController,
            label: 'Property Title',
            hint: 'e.g. Modern Studio in Downtown',
          ),
          const SizedBox(height: 20),

          _buildTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Describe your property...',
            maxLines: 4,
          ),
          const SizedBox(height: 20),

          _buildTextField(
            controller: _addressController,
            label: 'Address',
            hint: 'Full property address',
          ),
          const SizedBox(height: 20),

          // Property Type Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Type',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlack,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.dividerGray.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.dividerGray),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _propertyType,
                    isExpanded: true,
                    items: ['Apartment', 'House', 'Villa', 'Condo', 'Dormitory']
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                color: AppTheme.primaryBlack,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _propertyType = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Step 2: Photos
  Widget _buildStep2Photos() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Photos',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Showcase the best features of your property',
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppTheme.secondaryGray,
            ),
          ),
          const SizedBox(height: 32),

          // Add Photo Button
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryGreen,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_a_photo,
                          size: 32,
                          color: AppTheme.primaryGreen,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload Photo',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      // Add a random static photo
                      _uploadedImages.add(
                        _staticPhotos[_uploadedImages.length %
                            _staticPhotos.length],
                      );
                    });
                  },
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryGreen,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.collections,
                          size: 32,
                          color: AppTheme.primaryGreen,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add Static Photo',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'Selected Photos',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlack,
            ),
          ),
          const SizedBox(height: 12),

          const SizedBox(height: 24),

          // Image Grid
          if (_uploadedImages.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: _uploadedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildImageProvider(_uploadedImages[index]),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _uploadedImages.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  // Step 3: Facilities
  Widget _buildStep3Facilities() {
    final facilities = [
      'Wifi',
      'AC',
      'Kitchen',
      'Parking',
      'Gym',
      'Pool',
      'Washer',
      'Dryer',
      'TV',
      'Balcony',
      'Garden',
      'Security',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Facilities & Amenities',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'What makes your property special?',
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppTheme.secondaryGray,
            ),
          ),
          const SizedBox(height: 32),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: facilities.map((facility) {
              final isSelected = _selectedFacilities.contains(facility);
              return FilterChip(
                label: Text(facility),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFacilities.add(facility);
                    } else {
                      _selectedFacilities.remove(facility);
                    }
                  });
                },
                selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryGreen,
                labelStyle: GoogleFonts.outfit(
                  color: isSelected
                      ? AppTheme.primaryGreen
                      : AppTheme.primaryBlack,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.primaryGreen
                        : AppTheme.dividerGray,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Step 4: Pricing
  Widget _buildStep4Pricing() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Your Price',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How much do you want to charge?',
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppTheme.secondaryGray,
            ),
          ),
          const SizedBox(height: 32),

          _buildTextField(
            controller: _priceController,
            label: 'Monthly Rent',
            hint: '0.00',
            prefix: '\$',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),

          _buildTextField(
            controller: _depositController,
            label: 'Security Deposit',
            hint: '0.00',
            prefix: '\$',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.primaryGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Include utility costs in the rent to attract more tenants.',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 5: Review
  Widget _buildStep5Review() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Listing',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check everything before submitting',
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppTheme.secondaryGray,
            ),
          ),
          const SizedBox(height: 32),

          _buildReviewCard(),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              image: _uploadedImages.isNotEmpty
                  ? DecorationImage(
                      image: _getImageProvider(_uploadedImages.first),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: NetworkImage('https://picsum.photos/400/300'),
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleController.text.isNotEmpty
                      ? _titleController.text
                      : 'Property Title',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _addressController.text.isNotEmpty
                      ? _addressController.text
                      : 'Address',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppTheme.secondaryGray,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${_priceController.text}/mo',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _propertyType,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Facilities',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedFacilities
                      .map(
                        (facility) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.dividerGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            facility,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? prefix,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            filled: true,
            fillColor: AppTheme.dividerGray.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.dividerGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.dividerGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryGreen),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: AppTheme.primaryBlack,
          ),
        ),
      ],
    );
  }
}

class PropertySuccessScreen extends StatelessWidget {
  final Room room;
  const PropertySuccessScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Success Animation/Icon
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(seconds: 1),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen.withOpacity(0.1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryGreen.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 20 * value,
                                    spreadRadius: 5 * value,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                size: 80,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Success Message
                      Text(
                        'Submission Received!',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your property is waiting for approval',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: AppTheme.secondaryGray,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Listing Summary Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header with Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'LISTING ID',
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: AppTheme.secondaryGray,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'PR${room.id}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryBlack,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'PENDING',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Dotted Line
                            _buildDottedLine(),

                            const SizedBox(height: 24),

                            // Room Info Summary
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        room.title,
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryBlack,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        room.location,
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          color: AppTheme.secondaryGray,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${room.price.toStringAsFixed(0)}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Details
                            _buildSummaryRow(
                              'Property Type',
                              room.type.name.toUpperCase(),
                            ),
                            const SizedBox(height: 12),
                            _buildSummaryRow(
                              'Submitted On',
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            ),
                            const SizedBox(height: 12),
                            _buildSummaryRow('Moderation', 'Under Review'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Info Tip
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: AppTheme.primaryGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your listing will be reviewed by an admin within 24 hours. You will be notified once it is approved.',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: AppTheme.primaryBlack.withOpacity(0.7),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Buttons
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(initialIndex: 0),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDottedLine() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : AppTheme.dividerGray,
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: AppTheme.secondaryGray,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
      ],
    );
  }
}
