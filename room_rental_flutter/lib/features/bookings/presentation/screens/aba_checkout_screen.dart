import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:room_rental_client/room_rental_client.dart';
import 'package:room_rental_flutter/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AbaCheckoutScreen extends StatefulWidget {
  final PaymentRequest paymentRequest;

  const AbaCheckoutScreen({super.key, required this.paymentRequest});

  @override
  State<AbaCheckoutScreen> createState() => _AbaCheckoutScreenState();
}

class _AbaCheckoutScreenState extends State<AbaCheckoutScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final pr = widget.paymentRequest;

    // Construct HTML form that auto-submits via POST
    final htmlContent =
        '''
    <!DOCTYPE html>
    <html>
      <head>
        <title>ABA Checkout</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body onload="document.forms[0].submit()">
        <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; font-family: sans-serif;">
            <p>Redirecting to ABA PayWay...</p>
        </div>
        <form action="${pr.checkoutUrl}" method="POST">
          <input type="hidden" name="req_time" value="${pr.reqTime}">
          <input type="hidden" name="merchant_id" value="${pr.merchantId}">
          <input type="hidden" name="tran_id" value="${pr.tranId}">
          <input type="hidden" name="amount" value="${pr.amount}">
          <input type="hidden" name="hash" value="${pr.hash}">
          <input type="hidden" name="firstname" value="${pr.firstName ?? ''}">
          <input type="hidden" name="lastname" value="${pr.lastName ?? ''}">
          <input type="hidden" name="email" value="${pr.email ?? ''}">
          <input type="hidden" name="phone" value="${pr.phone ?? ''}">
          <input type="hidden" name="type" value="${pr.type ?? 'purchase'}">
          <input type="hidden" name="payment_option" value="${pr.paymentOption ?? 'abapay'}">
          <input type="hidden" name="items" value="${pr.items ?? ''}">
          <input type="hidden" name="currency" value="${pr.currency ?? 'USD'}">
          <input type="hidden" name="shipping" value="${pr.shipping ?? '0.00'}">
          <input type="hidden" name="continue_success_url" value="${pr.continueSuccessUrl ?? ''}">
          <input type="hidden" name="return_url" value="${pr.returnUrl ?? ''}">
        </form>
      </body>
    </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            debugPrint('🌐 [ABA] Page Started: $url');
          },
          onPageFinished: (url) async {
            setState(() => _isLoading = false);
            debugPrint('🌐 [ABA] Page Finished: $url');

            // 1. Check URL-based success
            if (url.contains('roomrental.test/success') ||
                url.contains('success') ||
                url.contains('confirm')) {
              debugPrint('✅ [ABA] Success detected via URL');
              _handleSuccess();
              return;
            }

            // 2. Check content-based success (for sandbox JSON responses)
            try {
              var content =
                  await _controller.runJavaScriptReturningResult(
                        "document.body.innerText",
                      )
                      as String;

              // WebView result often comes back wrapped in extra quotes and escaped
              // 1. Remove outer quotes
              if (content.startsWith('"') && content.endsWith('"')) {
                content = content.substring(1, content.length - 1);
              }
              // 2. Unescape quotes and slashes
              content = content.replaceAll(r'\"', '"');
              content = content.replaceAll(r'\/', '/');
              content = content.replaceAll(r'\\', r'\');

              debugPrint('📄 [ABA] PROCESSED CONTENT: $content');

              // Standard success detection
              final isSuccess =
                  content.contains('"code":"00"') ||
                  content.contains('"code": "00"') ||
                  content.contains('"message":"Success!"');

              if (isSuccess) {
                debugPrint('✅ [ABA] Success detected via Page Content');

                // Try to find the deep link or the qrString
                final deepLinkMatch = RegExp(
                  r'"abapay_deeplink":\s*"([^"]+)"',
                ).firstMatch(content);
                final qrStringMatch = RegExp(
                  r'"qrString":\s*"([^"]+)"',
                ).firstMatch(content);

                String? targetLink;
                if (deepLinkMatch != null) {
                  targetLink = deepLinkMatch.group(1);
                } else if (qrStringMatch != null) {
                  // Manually construct the official ABA deep link if server only provides qrString
                  final qrData = qrStringMatch.group(1);
                  targetLink =
                      'abamobilebank://ababank.com?type=payway&qrcode=$qrData';
                }

                if (targetLink != null) {
                  final qrData = qrStringMatch?.group(1) ?? '';
                  final schemes = [
                    'abamobilebank://ababank.com?type=payway&qrcode=$qrData',
                    'abapay://qr/$qrData',
                  ];

                  bool launched = false;
                  for (final scheme in schemes) {
                    try {
                      debugPrint('🚀 [ABA] Attempting launch: $scheme');
                      launched = await launchUrl(
                        Uri.parse(scheme),
                        mode: LaunchMode.externalApplication,
                      );
                      if (launched) break;
                    } catch (e) {
                      debugPrint('❌ [ABA] Scheme failed: $scheme - $e');
                    }
                  }

                  if (!launched && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'ABA App not found. Please scan the QR code instead.',
                        ),
                      ),
                    );
                  }
                }

                // Auto-close and return success to PaymentMethodScreen
                // We add a tiny delay so the user can see the "Success" detection
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) _handleSuccess();
                });
              } else if (content.contains('"code":"01"') ||
                  content.contains('"code": "01"') ||
                  content.contains('error')) {
                debugPrint('❌ [ABA] Error detected via Page Content');
                _handleFailure();
              }
            } catch (e) {
              debugPrint('⚠️ [ABA] Error reading content: $e');
            }
          },
          onWebResourceError: (error) {
            debugPrint('❌ [ABA] WebResourceError: ${error.description}');
          },
          onNavigationRequest: (request) async {
            final url = request.url;
            if (url.startsWith('abapay://') ||
                url.startsWith('https://link.payway.com.kh')) {
              debugPrint('🚀 [ABA] Attempting to launch ABA App: $url');
              // Use url_launcher to open the external app
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(
        htmlContent,
        baseUrl: 'https://checkout-sandbox.payway.com.kh/',
      );
  }

  void _handleSuccess() {
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  void _handleFailure() {
    if (mounted) {
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ABA PayWay',
          style: GoogleFonts.outfit(
            color: AppTheme.primaryBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // MOCK SUCCESS BUTTON - REMOVE IN PRODUCTION
          TextButton(
            onPressed: _handleSuccess,
            child: const Text(
              'DEBUG: Success',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.primaryBlack),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              ),
            ),
        ],
      ),
    );
  }
}
