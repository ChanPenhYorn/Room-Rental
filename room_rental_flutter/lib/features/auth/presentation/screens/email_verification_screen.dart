import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String password;
  final UuidValue accountRequestId;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.password,
    required this.accountRequestId,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the verification code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the client from the provider
      final client = Client('http://127.0.0.1:9080/');

      debugPrint('--- Starting Verification ---');
      debugPrint('Email: ${widget.email}');
      debugPrint('Account Request ID: ${widget.accountRequestId}');
      debugPrint('Verification Code: ${_codeController.text.trim()}');

      // Verify the code
      debugPrint('Calling verifyRegistrationCode...');
      final registrationToken = await client.emailIdp.verifyRegistrationCode(
        accountRequestId: widget.accountRequestId,
        verificationCode: _codeController.text.trim(),
      );
      debugPrint('Verification successful. Token received: $registrationToken');

      // Finish registration
      debugPrint(
        'Calling finishRegistration with password length: ${widget.password.length}',
      );
      await client.emailIdp.finishRegistration(
        registrationToken: registrationToken,
        password: widget.password,
      );
      debugPrint('finishRegistration successful!');

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified! Please log in.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate to login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('ERROR during verification: $e');
      if (e is Error) {
        debugPrint('Stack trace: ${e.stackTrace}');
      }

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        // Check if it's a too many attempts error
        if (e.toString().contains('tooManyAttempts')) {
          _errorMessage =
              'Too many attempts. Please click "Resend" for a new code.';
        } else if (e.toString().contains('expired')) {
          _errorMessage = 'Code expired. Please click "Resend" for a new code.';
        } else {
          _errorMessage =
              'Invalid verification code. Please check and try again. Error: $e';
        }
      });
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final client = Client('http://127.0.0.1:9080/');

      // Start registration again to get a new code and account request ID
      final newAccountRequestId = await client.emailIdp.startRegistration(
        email: widget.email,
      );

      // Dev mode: get code
      try {
        final code = await client.dev.getRegistrationCode(widget.email);
        debugPrint('DEV_MODE: Verification code for ${widget.email} is: $code');
      } catch (e) {
        debugPrint('DEV_MODE: Failed to get verification code: $e');
      }

      if (!mounted) return;

      // Navigate to a new verification screen with the updated account request ID
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => EmailVerificationScreen(
            email: widget.email,
            password: widget.password,
            accountRequestId: newAccountRequestId,
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New verification code sent! Check your email.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to resend code. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade700,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Email icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.email_outlined,
                          size: 64,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'Verify Your Email',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'We sent a verification code to',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Verification code input
                      TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: 'Verification Code',
                          hintText: 'Enter 8-digit code',
                          prefixIcon: const Icon(Icons.pin),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorText: _errorMessage,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Verify button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Verify Email',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Resend code button
                      TextButton(
                        onPressed: _isLoading ? null : _resendCode,
                        child: Text(
                          'Didn\'t receive the code? Resend',
                          style: TextStyle(
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Back to login
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Back to Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
