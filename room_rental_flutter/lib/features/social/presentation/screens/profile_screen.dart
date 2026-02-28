import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:room_rental_flutter/core/theme/app_theme.dart';
import 'package:room_rental_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:room_rental_flutter/features/auth/presentation/providers/auth_providers.dart';
import 'package:room_rental_flutter/features/auth/presentation/providers/auth_state.dart';
import 'package:room_rental_flutter/features/property_management/presentation/screens/add_property_wizard_screen.dart';
import 'package:room_rental_flutter/features/social/presentation/screens/personal_information_screen.dart';

/// Profile Screen
/// Displays user profile details and settings
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  User? _userProfile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final repository = ref.read(authRepositoryProvider);
      final client = repository.authenticatedClient;
      final user = await client.auth.getMyProfile();
      if (mounted) {
        setState(() {
          _userProfile = user;
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProfile = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header with Profile Picture
              _buildHeader(context, authState),

              // Profile Options
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Hosting'),
                    const SizedBox(height: 12),
                    _buildOptionItem(
                      context,
                      icon: Icons.add_home_work_outlined,
                      title: 'List a Property',
                      subtitle: 'Add a new room or apartment',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddPropertyWizardScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Account Settings'),
                    const SizedBox(height: 12),
                    _buildOptionItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      subtitle: 'Name, Email, Phone',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PersonalInformationScreen(),
                          ),
                        );
                        // Refresh profile after returning from edit screen
                        _loadProfile();
                      },
                    ),
                    _buildOptionItem(
                      context,
                      icon: Icons.security,
                      title: 'Security',
                      subtitle: 'Password, 2FA',
                      onTap: () {},
                    ),
                    _buildOptionItem(
                      context,
                      icon: Icons.payment,
                      title: 'Payment Methods',
                      subtitle: 'Cards, Bank Accounts',
                      onTap: () {},
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle('App Settings'),
                    const SizedBox(height: 12),
                    _buildOptionItem(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Push, Email, SMS',
                      onTap: () {},
                    ),
                    _buildOptionItem(
                      context,
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'English (US)',
                      onTap: () {},
                    ),
                    _buildOptionItem(
                      context,
                      icon: Icons.dark_mode_outlined,
                      title: 'Theme',
                      subtitle: 'System Default',
                      onTap: () {},
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle('Support'),
                    const SizedBox(height: 12),
                    _buildOptionItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      subtitle: 'FAQ, Contact Support',
                      onTap: () {},
                    ),
                    _buildOptionItem(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      onTap: () {},
                    ),

                    const SizedBox(height: 32),
                    _buildLogoutButton(context, ref),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Version 1.0.0',
                        style: GoogleFonts.outfit(
                          color: AppTheme.secondaryGray,
                          fontSize: 12,
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
    );
  }

  Widget _buildHeader(BuildContext context, AuthState authState) {
    return authState.when(
      initial: () => const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      ),
      loading: () => const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      ),
      failure: (error) => SizedBox(
        height: 250,
        child: Center(
          child: Text(
            'Error loading profile',
            style: GoogleFonts.outfit(color: Colors.red),
          ),
        ),
      ),
      authenticated: (userInfo) {
        // Use full profile data if available, fallback to basic userInfo
        final displayName =
            _userProfile?.fullName ?? userInfo.fullName ?? 'User';
        final displayImageUrl =
            _userProfile?.profileImage ??
            userInfo.imageUrl ??
            'https://i.pravatar.cc/150?u=${userInfo.userIdentifier}';
        final roleName = _userProfile?.role.name.toUpperCase() ?? 'TENANT';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
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
              Stack(
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
                      radius: 50,
                      backgroundImage: NetworkImage(displayImageUrl),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PersonalInformationScreen(),
                        ),
                      ).then((_) => _loadProfile()),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                displayName,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userInfo.email ?? userInfo.userIdentifier,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppTheme.secondaryGray,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$roleName Account',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      unauthenticated: () => SizedBox(
        height: 250,
        child: Center(
          child: Text(
            'Please login',
            style: GoogleFonts.outfit(),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryBlack,
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryGreen,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: AppTheme.secondaryGray,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.secondaryGray,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          // Show logout confirmation
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Logout',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: GoogleFonts.outfit(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.outfit(color: AppTheme.secondaryGray),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.red.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.logout, color: Colors.red),
        label: Text(
          'Logout',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
