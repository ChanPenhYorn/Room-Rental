import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/connectivity_provider.dart';

class ConnectionErrorDialog extends ConsumerStatefulWidget {
  const ConnectionErrorDialog({super.key});

  @override
  ConsumerState<ConnectionErrorDialog> createState() =>
      _ConnectionErrorDialogState();
}

class _ConnectionErrorDialogState extends ConsumerState<ConnectionErrorDialog> {
  bool _isRetrying = false;
  String? _errorMessage;

  Future<void> _handleRetry() async {
    setState(() {
      _isRetrying = true;
      _errorMessage = null;
    });

    try {
      final isHealthy = await ref
          .read(networkControllerProvider.notifier)
          .checkServerHealth();

      if (!mounted) return;

      if (isHealthy) {
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _errorMessage =
              "Still unable to connect. Please check your internet or server status.";
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "An unexpected error occurred: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.wifi_off_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text('Connection Lost'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We are having trouble connecting to the server. Please check your internet connection and try again.',
              style: TextStyle(fontSize: 16),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: _isRetrying ? null : _handleRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF55B97D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: _isRetrying
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'OK',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
