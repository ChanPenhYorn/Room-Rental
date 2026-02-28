import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';

/// Bills Management Screen
/// Shows all bills and payment history
class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  // Mock data
  final List<Map<String, dynamic>> _bills = [
    {
      'id': 'BILL001',
      'bookingId': 'BK12345',
      'roomName': 'Modern Studio in DHA',
      'type': 'Monthly Rent',
      'amount': 450.0,
      'dueDate': DateTime(2024, 3, 1),
      'status': 'Pending',
      'month': 'March 2024',
    },
    {
      'id': 'BILL002',
      'bookingId': 'BK12345',
      'roomName': 'Modern Studio in DHA',
      'type': 'Monthly Rent',
      'amount': 450.0,
      'dueDate': DateTime(2024, 2, 1),
      'paidDate': DateTime(2024, 2, 1),
      'status': 'Paid',
      'month': 'February 2024',
    },
    {
      'id': 'BILL003',
      'bookingId': 'BK12345',
      'roomName': 'Modern Studio in DHA',
      'type': 'Security Deposit',
      'amount': 900.0,
      'dueDate': DateTime(2024, 1, 15),
      'paidDate': DateTime(2024, 1, 15),
      'status': 'Paid',
      'month': 'January 2024',
    },
    {
      'id': 'BILL004',
      'bookingId': 'BK12346',
      'roomName': 'Cozy Apartment',
      'type': 'Monthly Rent',
      'amount': 380.0,
      'dueDate': DateTime(2024, 3, 1),
      'status': 'Upcoming',
      'month': 'March 2024',
    },
  ];

  double get _totalPending {
    return _bills
        .where((bill) => bill['status'] == 'Pending')
        .fold(0.0, (sum, bill) => sum + (bill['amount'] as double));
  }

  double get _totalPaid {
    return _bills
        .where((bill) => bill['status'] == 'Paid')
        .fold(0.0, (sum, bill) => sum + (bill['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    final pendingBills = _bills.where((b) => b['status'] == 'Pending').toList();
    final paidBills = _bills.where((b) => b['status'] == 'Paid').toList();
    final upcomingBills = _bills
        .where((b) => b['status'] == 'Upcoming')
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Bills & Payments',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Pending',
                      '\$${_totalPending.toStringAsFixed(2)}',
                      Colors.orange,
                      Icons.pending_actions,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Paid',
                      '\$${_totalPaid.toStringAsFixed(2)}',
                      AppTheme.primaryGreen,
                      Icons.check_circle,
                    ),
                  ),
                ],
              ),
            ),

            // Pending Bills
            if (pendingBills.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Pending Bills',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlack,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...pendingBills.map((bill) => _buildBillCard(bill)),
              const SizedBox(height: 24),
            ],

            // Upcoming Bills
            if (upcomingBills.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Upcoming Bills',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlack,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...upcomingBills.map((bill) => _buildBillCard(bill)),
              const SizedBox(height: 24),
            ],

            // Payment History
            if (paidBills.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Payment History',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlack,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...paidBills.map((bill) => _buildBillCard(bill)),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill) {
    final status = bill['status'] as String;
    final dueDate = bill['dueDate'] as DateTime;
    final paidDate = bill['paidDate'] as DateTime?;
    final isOverdue = status == 'Pending' && dueDate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue ? Colors.red.withOpacity(0.3) : AppTheme.dividerGray,
          width: 1,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill['type'],
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bill['roomName'],
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppTheme.secondaryGray,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status == 'Paid' ? 'Paid On' : 'Due Date',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppTheme.secondaryGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status == 'Paid'
                        ? '${paidDate!.day}/${paidDate.month}/${paidDate.year}'
                        : '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isOverdue ? Colors.red : AppTheme.primaryBlack,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Amount',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppTheme.secondaryGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${bill['amount'].toStringAsFixed(2)}',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (status == 'Pending') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentDialog(bill);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Pay Now',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return AppTheme.primaryGreen;
      case 'Pending':
        return Colors.orange;
      case 'Upcoming':
        return Colors.blue;
      default:
        return AppTheme.secondaryGray;
    }
  }

  void _showPaymentDialog(Map<String, dynamic> bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Pay Bill',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to pay this bill?',
              style: GoogleFonts.outfit(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount:',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppTheme.secondaryGray,
                        ),
                      ),
                      Text(
                        '\$${bill['amount'].toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                color: AppTheme.secondaryGray,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Payment processed successfully!',
                    style: GoogleFonts.outfit(),
                  ),
                  backgroundColor: AppTheme.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Pay Now',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
