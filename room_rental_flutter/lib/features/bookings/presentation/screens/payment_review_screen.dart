import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:room_rental_flutter/core/theme/app_theme.dart';

import 'payment_method_screen.dart';

/// Payment Review Screen
/// Shows booking summary and breakdown before payment
class PaymentReviewScreen extends StatelessWidget {
  final Room room;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;

  const PaymentReviewScreen({
    super.key,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
  });

  int get totalDays => checkOutDate.difference(checkInDate).inDays;
  int get totalMonths => (totalDays / 30).ceil();
  double get serviceFee => totalPrice * 0.05; // 5% service fee
  double get grandTotal => totalPrice + serviceFee;

  @override
  Widget build(BuildContext context) {
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
          'Review Payment',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Info
                  Text(
                    'Booking Details',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
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
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                room.imageUrl ?? '',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    color: AppTheme.dividerGray,
                                    child: const Icon(Icons.home),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    room.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlack,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: AppTheme.secondaryGray,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          room.location,
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            color: AppTheme.secondaryGray,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Check-in',
                          '${checkInDate.day}/${checkInDate.month}/${checkInDate.year}',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Check-out',
                          '${checkOutDate.day}/${checkOutDate.month}/${checkOutDate.year}',
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          'Duration',
                          '$totalDays days ($totalMonths month${totalMonths > 1 ? 's' : ''})',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Price Breakdown
                  Text(
                    'Price Breakdown',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
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
                    child: Column(
                      children: [
                        _buildPriceRow(
                          '\$${room.price.toStringAsFixed(0)} x $totalMonths month${totalMonths > 1 ? 's' : ''}',
                          '\$${totalPrice.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 12),
                        _buildPriceRow(
                          'Service Fee (5%)',
                          '\$${serviceFee.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        _buildPriceRow(
                          'Total',
                          '\$${grandTotal.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Cancellation Policy
                  Text(
                    'Cancellation Policy',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
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
                        _buildPolicyItem(
                          'Free cancellation up to 48 hours before check-in',
                        ),
                        const SizedBox(height: 12),
                        _buildPolicyItem(
                          '50% refund if cancelled 24-48 hours before check-in',
                        ),
                        const SizedBox(height: 12),
                        _buildPolicyItem(
                          'No refund if cancelled less than 24 hours before check-in',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Continue Button
          Container(
            padding: const EdgeInsets.all(24),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payment',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: AppTheme.secondaryGray,
                      ),
                    ),
                    Text(
                      '\$${grandTotal.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentMethodScreen(
                            room: room,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            totalAmount: grandTotal,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Proceed to Payment',
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
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppTheme.primaryBlack : AppTheme.secondaryGray,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppTheme.primaryGreen : AppTheme.primaryBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicyItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          size: 20,
          color: AppTheme.primaryGreen,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppTheme.primaryBlack,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
