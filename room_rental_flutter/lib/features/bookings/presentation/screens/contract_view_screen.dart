import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:room_rental_flutter/core/theme/app_theme.dart';

/// Contract View Screen
/// Displays rental contract details and terms
class ContractViewScreen extends StatelessWidget {
  final String bookingId;
  final String roomName;

  const ContractViewScreen({
    super.key,
    required this.bookingId,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    // Mock contract data
    final contract = {
      'contractId': 'CNT-$bookingId',
      'bookingId': bookingId,
      'roomName': roomName,
      'tenantName': 'John Doe',
      'landlordName': 'Jane Smith',
      'startDate': DateTime(2024, 2, 15),
      'endDate': DateTime(2024, 5, 15),
      'monthlyRent': 450.0,
      'securityDeposit': 900.0,
      'signedDate': DateTime(2024, 2, 10),
    };

    final contractId = contract['contractId'] as String;
    final tenantName = contract['tenantName'] as String;
    final landlordName = contract['landlordName'] as String;
    final startDate = contract['startDate'] as DateTime;
    final endDate = contract['endDate'] as DateTime;
    final monthlyRent = contract['monthlyRent'] as double;
    final securityDeposit = contract['securityDeposit'] as double;
    final signedDate = contract['signedDate'] as DateTime;

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rental Contract',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppTheme.primaryGreen),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Contract downloaded successfully',
                    style: GoogleFonts.outfit(),
                  ),
                  backgroundColor: AppTheme.primaryGreen,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppTheme.primaryGreen),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Share contract',
                    style: GoogleFonts.outfit(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contract Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryGreen, Color(0xFF00A86B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.description,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'RENTAL AGREEMENT',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Contract ID: $contractId',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Contract Details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parties Section
                  _buildSectionTitle('Parties Involved'),
                  const SizedBox(height: 16),
                  _buildInfoCard([
                    _buildInfoRow('Tenant', tenantName),
                    const Divider(height: 24),
                    _buildInfoRow('Landlord', landlordName),
                  ]),
                  const SizedBox(height: 24),

                  // Property Details
                  _buildSectionTitle('Property Details'),
                  const SizedBox(height: 16),
                  _buildInfoCard([
                    _buildInfoRow('Property', roomName),
                    const Divider(height: 24),
                    _buildInfoRow('Booking ID', bookingId),
                  ]),
                  const SizedBox(height: 24),

                  // Rental Period
                  _buildSectionTitle('Rental Period'),
                  const SizedBox(height: 16),
                  _buildInfoCard([
                    _buildInfoRow(
                      'Start Date',
                      _formatDate(startDate),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      'End Date',
                      _formatDate(endDate),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      'Duration',
                      '${_calculateMonths(startDate, endDate)} months',
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Financial Terms
                  _buildSectionTitle('Financial Terms'),
                  const SizedBox(height: 16),
                  _buildInfoCard([
                    _buildInfoRow(
                      'Monthly Rent',
                      '\$${monthlyRent.toStringAsFixed(2)}',
                      valueColor: AppTheme.primaryGreen,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      'Security Deposit',
                      '\$${securityDeposit.toStringAsFixed(2)}',
                      valueColor: AppTheme.primaryGreen,
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Terms & Conditions
                  _buildSectionTitle('Terms & Conditions'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.dividerGray,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTermItem(
                          '1. Payment Terms',
                          'Rent is due on the 1st of each month. Late payments will incur a fee of 5% after 5 days.',
                        ),
                        const SizedBox(height: 16),
                        _buildTermItem(
                          '2. Maintenance',
                          'The landlord is responsible for major repairs. The tenant must report any issues within 48 hours.',
                        ),
                        const SizedBox(height: 16),
                        _buildTermItem(
                          '3. Termination',
                          'Either party may terminate this agreement with 30 days written notice.',
                        ),
                        const SizedBox(height: 16),
                        _buildTermItem(
                          '4. Security Deposit',
                          'The security deposit will be refunded within 14 days after the end of the tenancy, minus any deductions for damages.',
                        ),
                        const SizedBox(height: 16),
                        _buildTermItem(
                          '5. Utilities',
                          'Tenant is responsible for electricity, water, and internet bills.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Signatures
                  _buildSectionTitle('Signatures'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified,
                              color: AppTheme.primaryGreen,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'This contract was digitally signed on ${_formatDate(signedDate)}',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: AppTheme.primaryBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSignature('Tenant', tenantName),
                            Container(
                              width: 1,
                              height: 60,
                              color: AppTheme.dividerGray,
                            ),
                            _buildSignature(
                              'Landlord',
                              landlordName,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Contract downloaded as PDF',
                                  style: GoogleFonts.outfit(),
                                ),
                                backgroundColor: AppTheme.primaryGreen,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: Text(
                            'Download PDF',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryGreen,
                            side: const BorderSide(
                              color: AppTheme.primaryGreen,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Contract sent via email',
                                  style: GoogleFonts.outfit(),
                                ),
                                backgroundColor: AppTheme.primaryGreen,
                              ),
                            );
                          },
                          icon: const Icon(Icons.email),
                          label: Text(
                            'Email Copy',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryBlack,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AppTheme.secondaryGray,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppTheme.primaryBlack,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTermItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: AppTheme.secondaryGray,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSignature(String role, String name) {
    return Column(
      children: [
        Text(
          role,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: AppTheme.secondaryGray,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 100,
          height: 2,
          color: AppTheme.primaryGreen,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateMonths(DateTime start, DateTime end) {
    return ((end.difference(start).inDays) / 30).ceil();
  }
}
