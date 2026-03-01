import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:dwellly_flutter/features/listings/domain/entities/room_entity.dart';
import 'package:dwellly_flutter/features/listings/presentation/providers/room_provider.dart';

class EditRoomScreen extends ConsumerStatefulWidget {
  final RoomEntity room;

  const EditRoomScreen({super.key, required this.room});

  @override
  ConsumerState<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends ConsumerState<EditRoomScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _priceController;
  late RoomType _selectedType;
  bool _isLoading = false;
  final List<String> _uploadedImages = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.room.title);
    _descriptionController = TextEditingController(
      text: widget.room.description,
    );
    _addressController = TextEditingController(text: widget.room.location);
    _priceController = TextEditingController(
      text: widget.room.price.toString(),
    );
    _selectedType = widget.room.type;
    _uploadedImages.addAll(widget.room.images);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in required fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final updatedRoom = Room(
      id: widget.room.id,
      ownerId: 0, // Server-overwritten
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      location: _addressController.text,
      latitude: widget.room.latitude,
      longitude: widget.room.longitude,
      rating: widget.room.rating,
      type: _selectedType,
      imageUrl: _uploadedImages.isNotEmpty
          ? _uploadedImages.first
          : widget.room.imageUrl,
      images: _uploadedImages,
      isAvailable: widget.room.isAvailable,
      createdAt: DateTime.now(), // Server-overwritten
      status: widget.room.status,
    );

    final success = await ref
        .read(roomControllerProvider.notifier)
        .requestRoomUpdate(
          widget.room.id,
          updatedRoom,
        );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Edit request submitted for Admin approval.'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit edit request.')),
        );
      }
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
          icon: const Icon(Icons.close, color: AppTheme.primaryBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Property',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.room.status == RoomStatus.approved)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This property is currently live. Your changes will be reviewed by an Admin before being applied.',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            _buildSectionTitle('Basic Info'),
            _buildTextField(
              controller: _titleController,
              label: 'Property Title',
              hint: 'e.g. Modern Studio',
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
              hint: 'Property location',
            ),
            const SizedBox(height: 32),

            _buildSectionTitle('Property Details'),
            _buildDropdown(),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _priceController,
              label: 'Monthly Rent',
              hint: '0.00',
              prefix: '\$',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            _buildPhotosSection(),
          ],
        ),
      ),
    );
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

  ImageProvider _buildImageProvider(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Photos'),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.05),
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
          ],
        ),
        const SizedBox(height: 16),
        if (_uploadedImages.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
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
                    width: double.infinity,
                    height: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image(
                        image: _buildImageProvider(_uploadedImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
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
                          size: 14,
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlack,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? prefix,
    TextInputType? keyboardType,
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
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.outfit(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
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
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RoomType>(
              value: _selectedType,
              isExpanded: true,
              items: RoomType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.uiLabel,
                        style: GoogleFonts.outfit(fontSize: 16),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
