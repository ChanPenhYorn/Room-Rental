import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dwellly_client/room_rental_client.dart'; // Import User class
import 'package:serverpod_auth_client/serverpod_auth_client.dart'; // Import UserInfo class
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:dwellly_flutter/features/auth/presentation/providers/auth_providers.dart';

/// Personal Information Screen
/// Allows users to edit their profile information
class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  ConsumerState<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  bool _isEditing = false;
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  bool _isLoadingProfile = true;
  bool _isSaving = false;
  User? _userProfile; // Store the full profile object

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();

    // Fetch full profile info on init
    _loadProfileInfo();

    // Add listeners to controllers to trigger rebuilds on text change
    // so the "Save" button can enable/disable reactively
    _nameController.addListener(_onTextChanged);
    _phoneController.addListener(_onTextChanged);
    _bioController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_isEditing) {
      setState(() {});
    }
  }

  bool get _hasChanges {
    if (_userProfile == null) return false;
    if (_pickedImage != null) return true;

    return _nameController.text.trim() !=
            (_userProfile?.fullName ?? '').trim() ||
        _phoneController.text.trim() != (_userProfile?.phone ?? '').trim() ||
        _bioController.text.trim() != (_userProfile?.bio ?? '').trim();
  }

  Future<void> _loadProfileInfo() async {
    try {
      print('PersonalInformationScreen: Fetching profile info...');
      final repository = ref.read(authRepositoryProvider);
      final client = repository.authenticatedClient;
      final user = await client.auth.getMyProfile();

      if (user != null && mounted) {
        print(
          'PersonalInformationScreen: Profile info loaded for ${user.fullName}.',
        );
        setState(() {
          _userProfile = user;
          _nameController.text = user.fullName;
          _emailController.text = user.userInfo?.email ?? '';
          _phoneController.text = user.phone ?? '';
          _bioController.text = user.bio ?? '';
          _isLoadingProfile = false;
        });
      } else if (mounted) {
        print('PersonalInformationScreen: Profile info returned null.');
        setState(() {
          _isLoadingProfile = false;
          _userProfile = null;
        });
      }
    } catch (e) {
      print('PersonalInformationScreen: Profile load error: $e');
      if (mounted) {
        setState(() => _isLoadingProfile = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _phoneController.removeListener(_onTextChanged);
    _bioController.removeListener(_onTextChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
        ),
        title: Text(
          'Personal Information',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving
                ? null
                : (_isEditing
                      ? (_hasChanges ? _saveChanges : _toggleEdit)
                      : _toggleEdit),
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: GoogleFonts.outfit(
                      color: _isEditing && !_hasChanges
                          ? AppTheme.secondaryGray
                          : AppTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: _isLoadingProfile
          ? const Center(child: CircularProgressIndicator())
          : authState.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: (error) => Center(
                child: Text(
                  'Error: $error',
                  style: GoogleFonts.outfit(color: Colors.red),
                ),
              ),
              authenticated: (user) => _buildContent(user),
              unauthenticated: () => const Center(
                child: Text('Please login to view profile'),
              ),
            ),
    );
  }

  Widget _buildContent(UserInfo user) {
    // Determine image URL: prefer server profile image, fallback to auth image, then placeholder
    final displayImageUrl =
        _userProfile?.profileImage ??
        user.imageUrl ??
        'https://i.pravatar.cc/150?u=${user.userIdentifier}';
    final accountType = _userProfile?.role.name.toUpperCase() ?? 'TENANT';
    final memberSince = _userProfile?.createdAt ?? user.created;
    final displayId =
        _userProfile?.id?.toString() ?? user.id?.toString() ?? 'N/A';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture Section
          Center(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryGreen,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _pickedImage != null
                        ? FileImage(File(_pickedImage!.path)) as ImageProvider
                        : NetworkImage(displayImageUrl),
                  ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Form Fields
          _buildFormField(
            'Full Name',
            _nameController,
            Icons.person_outline,
            enabled: _isEditing,
          ),

          const SizedBox(height: 20),

          _buildFormField(
            'Email Address',
            _emailController,
            Icons.email_outlined,
            enabled: false, // Email cannot be changed
          ),

          const SizedBox(height: 20),

          _buildFormField(
            'Phone Number',
            _phoneController,
            Icons.phone_outlined,
            enabled: _isEditing,
          ),

          const SizedBox(height: 20),

          _buildFormField(
            'Bio',
            _bioController,
            Icons.description_outlined,
            enabled: _isEditing,
            maxLines: 3,
          ),

          const SizedBox(height: 32),

          // Account Information
          _buildInfoSection('Account Information', [
            _buildInfoItem('Account Type', accountType),
            _buildInfoItem('Member Since', _formatDate(memberSince)),
            _buildInfoItem('User ID', displayId),
          ]),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.secondaryGray),
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
            filled: true,
            fillColor: enabled ? Colors.white : AppTheme.dividerGray,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: AppTheme.primaryBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
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
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppTheme.secondaryGray,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlack,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _saveChanges() async {
    final notifier = ref.read(authNotifierProvider.notifier);

    setState(() => _isSaving = true);

    try {
      String? imageBase64;
      if (_pickedImage != null) {
        final bytes = await _pickedImage!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      await notifier.updateProfile(
        fullName: _nameController.text,
        phone: _phoneController.text,
        bio: _bioController.text,
        imageBase64: imageBase64,
      );

      if (mounted) {
        await _loadProfileInfo(); // Reload to get the latest server data and reset _hasChanges
        setState(() {
          _isEditing = false;
          _isSaving = false;
          _pickedImage = null; // Clear picked image after save
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully!',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${date.day}/${date.month}/${date.year}';
  }
}
