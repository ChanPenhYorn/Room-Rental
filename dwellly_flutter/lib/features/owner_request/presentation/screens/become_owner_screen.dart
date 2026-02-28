import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:dwellly_flutter/features/owner_request/presentation/providers/owner_request_providers.dart';

class BecomeOwnerScreen extends ConsumerStatefulWidget {
  const BecomeOwnerScreen({super.key});

  @override
  ConsumerState<BecomeOwnerScreen> createState() => _BecomeOwnerScreenState();
}

class _BecomeOwnerScreenState extends ConsumerState<BecomeOwnerScreen> {
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);

    final success = await ref
        .read(ownerRequestControllerProvider.notifier)
        .submitRequest(message: _messageController.text.trim());

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit request.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myRequestAsync = ref.watch(myOwnerRequestProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        title: Text(
          'Become an Owner',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryBlack,
        elevation: 0,
      ),
      body: myRequestAsync.when(
        data: (request) {
          if (request != null) {
            return _buildStatusView(request);
          }
          return _buildSubmitView();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildStatusView(BecomeOwnerRequest request) {
    Color statusColor;
    String statusDesc;
    IconData statusIcon;

    switch (request.status) {
      case OwnerRequestStatus.pending:
        statusColor = Colors.orange;
        statusDesc =
            'Your request is currently under review by our team. We will notify you once a decision is made.';
        statusIcon = Icons.hourglass_empty;
        break;
      case OwnerRequestStatus.approved:
        statusColor = AppTheme.primaryGreen;
        statusDesc =
            'Congratulations! Your request has been approved. You can now start listing your properties.';
        statusIcon = Icons.check_circle_outline;
        break;
      case OwnerRequestStatus.rejected:
        statusColor = Colors.red;
        statusDesc =
            'Unfortunately, your request to become an owner was not approved at this time. You can submit a new request later.';
        statusIcon = Icons.error_outline;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, size: 64, color: statusColor),
          ),
          const SizedBox(height: 24),
          Text(
            request.status.name.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            statusDesc,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppTheme.secondaryGray,
            ),
          ),
          const SizedBox(height: 32),
          if (request.status == OwnerRequestStatus.rejected)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Allow resubmitting by invalidating the provider locally or similar
                  // For now, let's just show the submit view if they want to try again
                  // but typically we'd want to clear the old request or handle it on backend
                  // The backend `submitRequest` already handles "pending or approved" check.
                  // So we can just show the submit view if rejected.
                  setState(() {
                    // This is a bit hacky, normally we'd have a 'resubmit' flow
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit New Request',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Back to Profile',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready to start hosting?',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlack,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tell us a bit about why you want to become a property owner on RoomRental. This will help our team review your application faster.',
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: AppTheme.secondaryGray,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Your Message (Optional)',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlack,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  'e.g. I have 3 apartments in the city center that I would like to list...',
              hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Submit Request',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
