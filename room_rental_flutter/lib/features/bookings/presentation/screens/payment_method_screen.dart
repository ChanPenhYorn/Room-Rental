import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:room_rental_flutter/core/theme/app_theme.dart';
import 'package:room_rental_flutter/core/network/api_client_provider.dart';
import '../providers/booking_provider.dart';
import 'aba_checkout_screen.dart';

import 'payment_success_screen.dart';

/// Payment Method Selection Screen
class PaymentMethodScreen extends ConsumerStatefulWidget {
  final Room room;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalAmount;

  const PaymentMethodScreen({
    super.key,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalAmount,
  });

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  String? _selectedMethod;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'aba',
      'name': 'ABA PAY',
      'icon': Icons.qr_code_scanner,
      'subtitle': 'Pay with ABA Mobile App',
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'subtitle': 'Visa, Mastercard, Amex',
    },
    {
      'id': 'paypal',
      'name': 'PayPal',
      'icon': Icons.account_balance_wallet,
      'subtitle': 'Pay with your PayPal account',
    },
    {
      'id': 'bank',
      'name': 'Bank Transfer',
      'icon': Icons.account_balance,
      'subtitle': 'Direct bank transfer',
    },
    {
      'id': 'cash',
      'name': 'Cash on Arrival',
      'icon': Icons.money,
      'subtitle': 'Pay when you arrive',
    },
  ];

  Future<void> _handlePayment() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a payment method',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    if (_selectedMethod == 'aba') {
      try {
        final client = ref.read(clientProvider);
        final paymentRequest = await client.payment.createAbaPaymentRequest(
          amount: widget.totalAmount,
          roomId: widget.room.id!,
        );

        if (paymentRequest != null && mounted) {
          final success = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AbaCheckoutScreen(
                paymentRequest: paymentRequest,
              ),
            ),
          );

          if (success == true) {
            // Transaction successful on gateway, verify with server and save
            await _createBooking(
              transactionId: paymentRequest.tranId,
              status: BookingStatus.confirmed,
            );
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment cancelled or failed'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment initiation failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    } else {
      // For other methods like 'Cash', just create an active/confirmed booking
      await _createBooking(
        status: _selectedMethod == 'cash'
            ? BookingStatus.active
            : BookingStatus.confirmed,
      );
    }
  }

  Future<void> _createBooking({
    String? transactionId,
    BookingStatus? status,
  }) async {
    setState(() => _isProcessing = true);
    debugPrint(
      '📝 [Booking] Creating booking for room: ${widget.room.id}, status: $status',
    );

    try {
      // If it's ABA, we verify transaction on server
      if (transactionId != null && _selectedMethod == 'aba') {
        try {
          final client = ref.read(clientProvider);
          await client.payment.verifyAbaTransaction(transactionId);
          debugPrint('✅ [Booking] Transaction verified');
        } catch (e) {
          debugPrint(
            '⚠️ [Booking] Verification failed (non-critical in sandbox): $e',
          );
        }
      }

      final result = await ref
          .read(bookingControllerProvider.notifier)
          .createBooking(
            roomId: widget.room.id!,
            checkIn: widget.checkInDate,
            checkOut: widget.checkOutDate,
            totalPrice: widget.totalAmount,
            transactionId: transactionId,
            status: status,
          );

      if (result != null && mounted) {
        debugPrint('🎉 [Booking] Success! Booking ID: ${result.id}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              room: widget.room,
              checkInDate: widget.checkInDate,
              checkOutDate: widget.checkOutDate,
              totalAmount: widget.totalAmount,
              paymentMethod: _selectedMethod!,
              bookingIdOverride: 'BK${result.id}',
            ),
          ),
        );
      } else {
        throw Exception('Server returned null booking');
      }
    } catch (e) {
      debugPrint('❌ [Booking] Error creating booking: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Method',
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
                  // Amount to Pay
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryGreen, Color(0xFF00A86B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                        Text(
                          'Total Amount',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${widget.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Payment Methods
                  Text(
                    'Select Payment Method',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ..._paymentMethods.map((method) {
                    final isSelected = _selectedMethod == method['id'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedMethod = method['id'];
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryGreen
                                  : AppTheme.dividerGray,
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primaryGreen.withOpacity(
                                        0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryGreen
                                      : AppTheme.primaryGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  method['icon'],
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.primaryGreen,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method['name'],
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryBlack,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      method['subtitle'],
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: AppTheme.secondaryGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.primaryGreen,
                                  size: 28,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Pay Button
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
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Pay Now',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
