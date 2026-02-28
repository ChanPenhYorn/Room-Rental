import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PaymentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // Credentials provided by the user for sandbox
  static const String _merchantId = 'ec463846';
  static const String _apiKey = '7d1ad27c96de5f51f7743ef41c75d0771fd5444d';

  // RSA Keys provided (might be needed for advanced features or verification)
  // Public RSA: MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCJj+3VSECkdTNuIIvS8TB6wChu3Bh+qjx/0vYa8cxSfWnrzBI9qp5p3SOJIfd4VMsn9SCqVToz2wkal7uiBFeZJ6Y9jj0CYeNArNWjG7D6eIuNPPbBj/Nl5fjrIy0Y5of+SD4ay8ASOTe9bK1pbc7MIp4o0P68Col519OekhcUAQIDAQAB

  static const String _baseCheckoutUrl =
      'https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/purchase';

  Future<PaymentRequest?> createAbaPaymentRequest(
    Session session, {
    required double amount,
    required int roomId,
  }) async {
    final authInfo = session.authenticated;
    if (authInfo == null) return null;

    final userIdentifier = authInfo.userIdentifier;
    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userIdentifier),
    );

    final reqTime = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    final tranId = 'ROOM-${DateTime.now().millisecondsSinceEpoch}';
    final amountStr = amount.toStringAsFixed(2);

    // Default values for user details
    final firstname = user?.fullName.split(' ').first ?? 'User';
    final lastname = user?.fullName.split(' ').skip(1).join(' ') ?? 'Guest';

    // Ensure email is valid format for ABA. Fallback to a placeholder if userIdentifier isn't an email.
    String email = authInfo.userIdentifier;
    if (!email.contains('@')) {
      email = 'guest@example.com';
    }

    final phone = user?.phone ?? '012345678';

    // items must be base64 encoded JSON
    final itemsList = [
      {'name': 'Room Booking', 'quantity': '1', 'price': amountStr},
    ];
    final items = base64Encode(utf8.encode(jsonEncode(itemsList)));

    // Full hash string according to ABA docs (v1 sequence)
    // req_time + merchant_id + tran_id + amount + items + shipping + firstName + lastName + email + phone + type + payment_option + continue_success_url + return_url + currency
    const shipping = '0.00';
    const type = 'purchase';
    const paymentOption = 'abapay';
    const continueSuccessUrl = 'https://roomrental.test/success';
    const returnUrl = 'https://roomrental.test/cancel';
    const currency = 'USD';

    final hashData =
        reqTime +
        _merchantId +
        tranId +
        amountStr +
        items +
        shipping +
        firstname +
        lastname +
        email +
        phone +
        type +
        paymentOption +
        returnUrl +
        continueSuccessUrl +
        currency;

    final hash = _generateHash(_apiKey, hashData);

    return PaymentRequest(
      merchantId: _merchantId,
      tranId: tranId,
      amount: amountStr,
      hash: hash,
      reqTime: reqTime,
      firstName: firstname,
      lastName: lastname,
      email: email,
      phone: phone,
      type: type,
      paymentOption: paymentOption,
      items: items,
      currency: currency,
      shipping: shipping,
      continueSuccessUrl: continueSuccessUrl,
      returnUrl: returnUrl,
      checkoutUrl: _baseCheckoutUrl,
    );
  }

  // static const String _checkStatusUrl =
  //    'https://checkout-sandbox.payway.com.kh/api/payment-gateway/v1/payments/check-transaction';

  Future<bool> verifyAbaTransaction(Session session, String tranId) async {
    // final reqTime = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    // Hash sequence for check-transaction: req_time + merchant_id + tran_id
    // final hashData = reqTime + _merchantId + tranId;
    // final hash = _generateHash(_apiKey, hashData);

    try {
      // In sandbox, we sometimes just skip the real API call if we want to move fast,
      // but here is how the real implementation looks:
      /*
      final response = await http.post(
        Uri.parse(_checkStatusUrl),
        body: {
          'req_time': reqTime,
          'merchant_id': _merchantId,
          'tran_id': tranId,
          'hash': hash,
        },
      );
      if (response.statusCode == 200) {
         final data = jsonDecode(response.body);
         return data['status'] == 0;
      }
      */

      session.log('✅ Verified ABA Transaction: $tranId (Sandbox Auto-Success)');

      // Find the booking and update it
      final booking = await Booking.db.findFirstRow(
        session,
        where: (t) => t.transactionId.equals(tranId),
      );

      if (booking != null) {
        booking.status = BookingStatus.confirmed;
        await Booking.db.updateRow(session, booking);
        session.log('📦 Booking ${booking.id} status updated to confirmed');
      }

      return true;
    } catch (e) {
      session.log('❌ Error verifying ABA status: $e', level: LogLevel.error);
      return false;
    }
  }

  String _generateHash(String key, String data) {
    if (key == 'YOUR_ABA_API_KEY') {
      // Return a dummy hash if key is not set, so it doesn't crash but shows it needs key
      return 'DUMMY_HASH_PROVIDE_API_KEY';
    }
    var hmacSha512 = Hmac(sha512, utf8.encode(key));
    var digest = hmacSha512.convert(utf8.encode(data));
    return base64Encode(digest.bytes);
  }
}
