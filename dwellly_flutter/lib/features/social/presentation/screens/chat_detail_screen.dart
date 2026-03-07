import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:dwellly_flutter/core/utils/avatar_utils.dart';
import 'package:dwellly_flutter/features/social/presentation/controllers/chat_controller.dart';
import 'package:dwellly_flutter/features/auth/presentation/providers/user_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final int userId;
  final String userName;
  final String? avatarUrl;
  final bool isOnline;

  const ChatDetailScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.isOnline,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _isLocked = false;
  String? _recordingPath;
  DateTime? _recordingStartTime;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  StreamSubscription? _amplitudeSubscription;
  double _amplitude = 0.0;
  AnimationController? _pulseController;

  double _dragX = 0.0;
  double _dragY = 0.0;
  bool _isCancelled = false;
  bool _isLocking = false;

  bool _isSending = false;
  String? _sendingType;

  final Map<int, AudioPlayer> _audioPlayers = {};
  final Map<int, StreamSubscription> _playerSubscriptions = {};
  final Map<int, Duration> _playerPositions = {};
  final Map<int, Duration> _playerDurations = {};

  final Map<int, bool> _fileDownloading = {};
  final Dio _dio = Dio();

  String? _currentFloatingDate;
  bool _showFloatingPill = false;
  Timer? _hidePillTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    Future.microtask(() {
      ref.read(chatHistoryProvider(widget.userId).notifier).markRead();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _pulseController?.dispose();
    _amplitudeSubscription?.cancel();
    _hidePillTimer?.cancel();
    for (final sub in _playerSubscriptions.values) {
      sub.cancel();
    }
    for (final player in _audioPlayers.values) {
      player.dispose();
    }
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatHistoryProvider(widget.userId).notifier).sendMessage(text);
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _showAttachmentOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.photo_library,
                    color: Colors.blue,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickMultipleImages();
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.camera_alt,
                    color: Colors.pink,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file,
                    color: Colors.orange,
                    label: 'File',
                    onTap: () {
                      Navigator.pop(context);
                      _pickFile();
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.location_on,
                    color: Colors.green,
                    label: 'Location',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Location feature coming soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppTheme.primaryBlack,
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> _compressImage(
    File file, {
    int quality = 70,
    int maxWidth = 1200,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);

      int width = decodedImage.width;
      int height = decodedImage.height;

      if (width > maxWidth) {
        height = (height * maxWidth / width).round();
        width = maxWidth;
      }

      final resized = await resizedImage(
        bytes,
        width,
        height,
        quality: quality,
      );

      return resized;
    } catch (e) {
      return await file.readAsBytes();
    }
  }

  Future<Uint8List?> resizedImage(
    Uint8List bytes,
    int width,
    int height, {
    int quality = 70,
  }) async {
    return bytes;
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1200,
      );

      if (images.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPreviewScreen(
              filePath: images.first.path,
              messageType: 'image',
              userId: widget.userId,
              isMultiple: true,
              multiplePaths: images.map((e) => e.path).toList(),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking images: $e')),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1200,
      );
      if (image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPreviewScreen(
              filePath: image.path,
              messageType: 'image',
              userId: widget.userId,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _sendImageWithCompression(String imagePath) async {
    try {
      final file = File(imagePath);
      final compressedBytes = await _compressImage(file);

      if (compressedBytes != null) {
        final base64String = base64Encode(compressedBytes);
        final fileName = imagePath.split('/').last;

        final controller = ref.read(
          chatHistoryProvider(widget.userId).notifier,
        );
        final attachmentUrl = await controller.uploadAttachment(
          base64String,
          fileName,
        );

        if (attachmentUrl != null) {
          await controller.sendAttachmentMessage(
            messageType: 'image',
            attachmentUrl: attachmentUrl,
            attachmentSize: compressedBytes.length,
          );
          _scrollToBottom();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending image: $e')),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx'],
      );
      if (result != null && result.files.single.path != null) {
        await _sendAttachment(result.files.single.path!, 'file');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<void> _sendAttachment(String filePath, String messageType) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      final fileName = filePath.split('/').last;

      final controller = ref.read(chatHistoryProvider(widget.userId).notifier);
      final attachmentUrl = await controller.uploadAttachment(
        base64String,
        fileName,
      );

      if (attachmentUrl != null) {
        int? duration;
        String? attachmentName;
        int? attachmentSize;

        if (messageType == 'voice') {
          duration = _recordingDuration;
        } else {
          attachmentName = fileName;
          attachmentSize = bytes.length;
        }

        await controller.sendAttachmentMessage(
          messageType: messageType,
          attachmentUrl: attachmentUrl,
          attachmentDuration: duration,
          attachmentName: attachmentName,
          attachmentSize: attachmentSize,
        );
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending attachment: $e')),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        _amplitudeSubscription = _audioRecorder
            .onAmplitudeChanged(const Duration(milliseconds: 100))
            .listen((amp) {
              if (mounted) {
                setState(() {
                  _amplitude = amp.current;
                });
              }
            });

        HapticFeedback.mediumImpact();

        setState(() {
          _isRecording = true;
          _isLocked = false;
          _recordingPath = path;
          _recordingStartTime = DateTime.now();
          _recordingDuration = 0;
          _dragX = 0.0;
          _dragY = 0.0;
          _isCancelled = false;
          _isLocking = false;
        });

        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration++;
          });
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting recording: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording({
    bool isCancelled = false,
    bool fromLock = false,
  }) async {
    if (_isLocked && !fromLock) {
      return;
    }

    try {
      _recordingTimer?.cancel();
      _amplitudeSubscription?.cancel();
      final path = await _audioRecorder.stop();

      HapticFeedback.lightImpact();

      setState(() {
        _isRecording = false;
        _isLocked = false;
        _dragX = 0.0;
        _dragY = 0.0;
        _isCancelled = false;
        _isLocking = false;
        _amplitude = 0.0;
      });

      if (isCancelled || path == null) {
        if (path != null) {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        }
        return;
      }

      if (path != null) {
        setState(() {
          _isSending = true;
          _sendingType = 'voice';
        });
        await _sendAttachment(path, 'voice');
        setState(() {
          _isSending = false;
          _sendingType = null;
        });
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isLocked = false;
        _isSending = false;
        _sendingType = null;
        _dragX = 0.0;
        _dragY = 0.0;
        _isCancelled = false;
        _isLocking = false;
        _amplitude = 0.0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error stopping recording: $e')),
        );
      }
    }
  }

  Future<void> _lockRecording() async {
    HapticFeedback.heavyImpact();
    setState(() {
      _isLocked = true;
      _isLocking = false;
    });
  }

  Future<void> _cancelRecording() async {
    HapticFeedback.mediumImpact();
    await _stopRecording(isCancelled: true, fromLock: true);
  }

  Future<void> _sendRecording() async {
    HapticFeedback.mediumImpact();
    await _stopRecording(isCancelled: false, fromLock: true);
  }

  Future<void> _toggleVoicePlayback(ChatMessage message) async {
    if (message.attachmentUrl == null) return;

    final messageId = message.id;
    if (messageId == null) return;

    for (final entry in _audioPlayers.entries) {
      if (entry.key != messageId && entry.value.playing) {
        await entry.value.pause();
      }
    }

    if (_audioPlayers.containsKey(messageId)) {
      final player = _audioPlayers[messageId]!;
      if (player.playing) {
        await player.pause();
      } else {
        await player.play();
      }
    } else {
      final player = AudioPlayer();
      _audioPlayers[messageId] = player;

      await player.setUrl(message.attachmentUrl!);

      _playerDurations[messageId] = player.duration ?? Duration.zero;

      _playerSubscriptions[messageId] = player.positionStream.listen((
        position,
      ) {
        if (mounted) {
          setState(() {
            _playerPositions[messageId] = position;
          });
        }
      });

      player.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {});
          if (state.processingState == ProcessingState.completed) {
            player.seek(Duration.zero);
            player.pause();
          }
        }
      });

      await player.play();
    }
  }

  void _showImageViewer(List<String> imageUrls, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatHistoryState = ref.watch(chatHistoryProvider(widget.userId));
    final userProfile = ref.watch(userProfileProvider);

    final currentUserId = userProfile.maybeWhen(
      data: (user) => user?.id,
      orElse: () => null,
    );

    ref.listen<AsyncValue<List<ChatMessage>>>(
      chatHistoryProvider(widget.userId),
      (previous, next) {
        if (next.hasValue &&
            (previous?.value?.length ?? 0) < (next.value?.length ?? 0)) {
          _scrollToBottom();
        }
      },
    );

    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            AvatarUtils.buildAvatar(
              imageUrl: widget.avatarUrl,
              fallbackName: widget.userName,
              radius: 16,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                Text(
                  widget.isOnline ? 'Online' : 'Offline',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: widget.isOnline
                        ? Colors.green
                        : AppTheme.secondaryGray,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: AppTheme.primaryGreen),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: chatHistoryState.when(
                  data: (messages) {
                    if (messages.isEmpty) {
                      return Center(
                        child: Text(
                          'No messages yet. Say hi!',
                          style: GoogleFonts.outfit(color: Colors.grey),
                        ),
                      );
                    }

                    final itemsWithHeaders = <dynamic>[];
                    for (int i = 0; i < messages.length; i++) {
                      final message = messages[i];
                      if (i == 0) {
                        itemsWithHeaders.add(
                          _getDateHeaderText(message.sentAt),
                        );
                      } else {
                        final previousMessage = messages[i - 1];
                        final currentDate = DateTime(
                          message.sentAt.year,
                          message.sentAt.month,
                          message.sentAt.day,
                        );
                        final previousDate = DateTime(
                          previousMessage.sentAt.year,
                          previousMessage.sentAt.month,
                          previousMessage.sentAt.day,
                        );
                        if (currentDate != previousDate) {
                          itemsWithHeaders.add(
                            _getDateHeaderText(message.sentAt),
                          );
                        }
                      }
                      itemsWithHeaders.add(message);
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollStartNotification ||
                            notification is ScrollUpdateNotification) {
                          setState(() {
                            _showFloatingPill = true;
                          });
                          _hidePillTimer?.cancel();

                          final index = (_scrollController.offset / 100)
                              .floor()
                              .clamp(0, itemsWithHeaders.length - 1);

                          String? foundDate;
                          for (int i = index; i >= 0; i--) {
                            if (itemsWithHeaders[i] is String) {
                              foundDate = itemsWithHeaders[i] as String;
                              break;
                            }
                          }

                          setState(() {
                            _currentFloatingDate = foundDate;
                          });
                        } else if (notification is ScrollEndNotification) {
                          _hidePillTimer?.cancel();
                          _hidePillTimer = Timer(
                            const Duration(milliseconds: 1500),
                            () {
                              if (mounted) {
                                setState(() {
                                  _showFloatingPill = false;
                                });
                              }
                            },
                          );
                        }
                        return false;
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: itemsWithHeaders.length,
                        itemBuilder: (context, index) {
                          final item = itemsWithHeaders[index];
                          if (item is String) {
                            return _buildDateHeader(item);
                          } else if (item is ChatMessage) {
                            final isMe = item.senderId == currentUserId;
                            return _buildMessageBubble(item, isMe, messages);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    );
                  },
                  loading: () => _buildSkeletonMessages(),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
              _buildMessageInput(),
            ],
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showFloatingPill ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _currentFloatingDate ?? '',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isSending) _buildSendingOverlay(),
        ],
      ),
    );
  }

  Widget _buildSkeletonMessages() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          final isMe = index % 2 == 0;
          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 10,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSendingOverlay() {
    Color bgColor;
    String message;
    IconData icon;

    switch (_sendingType) {
      case 'voice':
        bgColor = Colors.red.shade400;
        message = 'Sending voice message...';
        icon = Icons.mic;
        break;
      case 'image':
        bgColor = AppTheme.primaryGreen;
        message = 'Sending image...';
        icon = Icons.image;
        break;
      case 'file':
        bgColor = Colors.blue.shade400;
        message = 'Sending file...';
        icon = Icons.insert_drive_file;
        break;
      default:
        bgColor = Colors.grey;
        message = 'Sending...';
        icon = Icons.send;
    }

    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          margin: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                message,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: _isRecording ? _buildRecordingUI() : _buildNormalInput(),
      ),
    );
  }

  Widget _buildRecordingUI() {
    if (_isLocked) {
      return _buildLockedRecordingUI();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isCancelled ? Colors.red.shade100 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController!,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController!.value * 0.2),
                child: Icon(
                  Icons.mic,
                  color: _isCancelled ? Colors.white : Colors.red,
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragX += details.delta.dx;
                  if (_dragX < -50.0) {
                    _isCancelled = true;
                  } else {
                    _isCancelled = false;
                  }
                });
              },
              onHorizontalDragEnd: (_) {
                _stopRecording(isCancelled: _isCancelled);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              _buildAmplitudeWave(),
                              const SizedBox(width: 8),
                              Text(
                                _isCancelled
                                    ? 'Release to cancel'
                                    : 'Recording...',
                                style: GoogleFonts.outfit(
                                  color: _isCancelled ? Colors.red : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _formatDuration(_recordingDuration),
                            style: GoogleFonts.outfit(
                              color: _isCancelled
                                  ? Colors.white
                                  : Colors.red.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _isCancelled ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Cancelled',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmplitudeWave() {
    final normalizedAmplitude = ((_amplitude + 160) / 160).clamp(0.0, 1.0);
    return SizedBox(
      width: 40,
      height: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          final heightFactor = (normalizedAmplitude * (index + 1) / 5).clamp(
            0.2,
            1.0,
          );
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 3,
            height: 16 * heightFactor,
            decoration: BoxDecoration(
              color: _isCancelled ? Colors.white : Colors.red,
              borderRadius: BorderRadius.circular(1.5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLockedRecordingUI() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController!,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController!.value * 0.2),
                child: const Icon(
                  Icons.mic,
                  color: AppTheme.primaryGreen,
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _buildAmplitudeWave(),
                    const SizedBox(width: 8),
                    Text(
                      'Recording locked',
                      style: GoogleFonts.outfit(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatDuration(_recordingDuration),
                  style: GoogleFonts.outfit(
                    color: AppTheme.primaryGreen,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _cancelRecording,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          IconButton(
            onPressed: _sendRecording,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppTheme.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalInput() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.add, color: AppTheme.primaryGreen),
          onPressed: _showAttachmentOptions,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: _messageController,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.outfit(
                  color: AppTheme.secondaryGray,
                ),
                border: InputBorder.none,
              ),
              style: GoogleFonts.outfit(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onLongPressStart: (_) => _startRecording(),
          onLongPressMoveUpdate: (details) {
            final dx = details.localPosition.dx - 40;
            final dy = details.localPosition.dy - 40;
            setState(() {
              _dragX = dx;
              _dragY = dy;
              if (_dragX < -50.0) {
                _isCancelled = true;
                _isLocking = false;
              } else if (_dragY < -50.0) {
                _isLocking = true;
                _isCancelled = false;
              } else {
                _isCancelled = false;
                _isLocking = false;
              }
            });
          },
          onLongPressEnd: (_) {
            if (_isLocked || _isLocking) {
              _lockRecording();
            } else {
              _stopRecording(isCancelled: _isCancelled);
            }
          },
          child: CircleAvatar(
            backgroundColor: _isCancelled
                ? Colors.red
                : (_isLocking ? Colors.orange : AppTheme.primaryGreen),
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white, size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hold to record')),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: AppTheme.primaryGreen,
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white, size: 20),
            onPressed: _sendMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    bool isMe,
    List<ChatMessage> allMessages,
  ) {
    final messageType = message.messageType ?? 'text';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.primaryGreen : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildMessageContent(message, isMe, messageType, allMessages),
      ),
    );
  }

  Widget _buildMessageContent(
    ChatMessage message,
    bool isMe,
    String messageType,
    List<ChatMessage> allMessages,
  ) {
    switch (messageType) {
      case 'voice':
        return _buildVoiceMessage(message, isMe);
      case 'image':
        return _buildImageMessage(message, isMe, allMessages);
      case 'file':
        return _buildFileMessage(message, isMe);
      default:
        return _buildTextMessage(message, isMe);
    }
  }

  Widget _buildTextMessage(ChatMessage message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            message.message,
            style: GoogleFonts.outfit(
              color: isMe ? Colors.white : AppTheme.primaryBlack,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat.jm().format(message.sentAt),
            style: GoogleFonts.outfit(
              color: isMe
                  ? Colors.white.withOpacity(0.7)
                  : AppTheme.secondaryGray,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessage(ChatMessage message, bool isMe) {
    final messageId = message.id;
    final isPlaying =
        messageId != null &&
        _audioPlayers.containsKey(messageId) &&
        _audioPlayers[messageId]!.playing;

    final position = messageId != null ? _playerPositions[messageId] : null;
    final duration = messageId != null ? _playerDurations[messageId] : null;

    double progress = 0.0;
    if (duration != null && duration.inMilliseconds > 0 && position != null) {
      progress = position.inMilliseconds / duration.inMilliseconds;
    } else if (message.attachmentDuration != null &&
        message.attachmentDuration! > 0) {
      progress = 0.0;
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _toggleVoicePlayback(message),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.white.withOpacity(0.2)
                    : AppTheme.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isMe ? Colors.white : AppTheme.primaryGreen,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 24,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: isMe
                            ? Colors.white.withOpacity(0.3)
                            : AppTheme.secondaryGray.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: isMe ? Colors.white : AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                    ...List.generate(12, (index) {
                      final waveProgress = index / 12;
                      final isActive = waveProgress <= progress;
                      return Positioned(
                        left: index * 10.0,
                        child: Container(
                          width: 3,
                          height: 8 + (index % 3) * 4.0,
                          decoration: BoxDecoration(
                            color: isActive
                                ? (isMe ? Colors.white : AppTheme.primaryGreen)
                                : (isMe
                                      ? Colors.white.withOpacity(0.3)
                                      : AppTheme.secondaryGray.withOpacity(
                                          0.3,
                                        )),
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              if (message.message != null && message.message!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.message!,
                    style: GoogleFonts.outfit(
                      color: isMe ? Colors.white : AppTheme.primaryBlack,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                position != null
                    ? '${_formatDuration(position.inSeconds)} / ${_formatDuration((duration?.inSeconds ?? message.attachmentDuration ?? 0))}'
                    : (message.attachmentDuration != null
                          ? _formatDuration(message.attachmentDuration!)
                          : '0:00'),
                style: GoogleFonts.outfit(
                  color: isMe ? Colors.white : AppTheme.primaryBlack,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Text(
            DateFormat.jm().format(message.sentAt),
            style: GoogleFonts.outfit(
              color: isMe
                  ? Colors.white.withOpacity(0.7)
                  : AppTheme.secondaryGray,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(
    ChatMessage message,
    bool isMe,
    List<ChatMessage> allMessages,
  ) {
    final imageUrls = <String>[];

    if (message.attachmentUrl != null && message.attachmentUrl!.isNotEmpty) {
      imageUrls.add(message.attachmentUrl!);
    }

    for (final msg in allMessages) {
      if (msg.messageType == 'image' &&
          msg.attachmentUrl != null &&
          msg.attachmentUrl!.isNotEmpty &&
          !imageUrls.contains(msg.attachmentUrl)) {
        final msgIsMe = msg.senderId == message.senderId;
        if (msgIsMe == isMe) {
          imageUrls.add(msg.attachmentUrl!);
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (message.attachmentUrl != null) {
                _showImageViewer(imageUrls, 0);
              }
            },
            child: Hero(
              tag: 'image_${message.attachmentUrl}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  message.attachmentUrl ?? '',
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 220,
                      height: 220,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 220,
                    height: 220,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrls.length > 1)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.collections,
                          size: 12,
                          color: isMe ? Colors.white : AppTheme.primaryBlack,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${imageUrls.length}',
                          style: GoogleFonts.outfit(
                            color: isMe ? Colors.white : AppTheme.primaryBlack,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Text(
                DateFormat.jm().format(message.sentAt),
                style: GoogleFonts.outfit(
                  color: isMe
                      ? Colors.white.withOpacity(0.7)
                      : AppTheme.secondaryGray,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(ChatMessage message, bool isMe) {
    final messageId = message.id;
    final isDownloading =
        messageId != null && (_fileDownloading[messageId] ?? false);

    return GestureDetector(
      onTap: () async {
        if (message.attachmentUrl == null || messageId == null) return;

        if (_fileDownloading[messageId] == true) return;

        try {
          final directory = await getApplicationDocumentsDirectory();
          final fileName = message.attachmentName ?? 'document';
          final localPath = '${directory.path}/$fileName';
          final localFile = File(localPath);

          if (await localFile.exists()) {
            await OpenFilex.open(localPath);
          } else {
            setState(() {
              _fileDownloading[messageId] = true;
            });

            await _dio.download(
              message.attachmentUrl!,
              localPath,
              onReceiveProgress: (received, total) {},
            );

            setState(() {
              _fileDownloading[messageId] = false;
            });

            if (await localFile.exists()) {
              await OpenFilex.open(localPath);
            }
          }
        } catch (e) {
          setState(() {
            _fileDownloading[messageId] = false;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error opening file: $e')),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.insert_drive_file,
                color: isMe ? Colors.white : AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.attachmentName ?? 'Document',
                    style: GoogleFonts.outfit(
                      color: isMe ? Colors.white : AppTheme.primaryBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (message.attachmentSize != null)
                    Text(
                      _formatFileSize(message.attachmentSize!),
                      style: GoogleFonts.outfit(
                        color: isMe
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppTheme.secondaryGray,
                        fontSize: 12,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    isDownloading ? 'Downloading...' : 'Tap to open',
                    style: GoogleFonts.outfit(
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.5)
                          : AppTheme.secondaryGray.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                  if (message.message != null &&
                      message.message!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      message.message!,
                      style: GoogleFonts.outfit(
                        color: isMe ? Colors.white : AppTheme.primaryBlack,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            isDownloading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  )
                : Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppTheme.secondaryGray,
                  ),
            const SizedBox(width: 8),
            Text(
              DateFormat.jm().format(message.sentAt),
              style: GoogleFonts.outfit(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : AppTheme.secondaryGray,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getDateHeaderText(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (date.year == now.year) {
      return DateFormat('EEEE, MMMM d').format(date);
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  Widget _buildDateHeader(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      // decoration: BoxDecoration(
      //   color: Colors.black.withValues(alpha: 0.05),
      //   borderRadius: BorderRadius.circular(16),
      // ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.secondaryGray,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ImageViewerScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isSaving = false;
  final Dio _dio = Dio();

  Future<void> _saveToGallery() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final status = await Permission.photos.request();

      if (status.isGranted || status.isLimited) {
        final response = await _dio.get<List<int>>(
          widget.imageUrls[_currentIndex],
          options: Options(responseType: ResponseType.bytes),
        );

        if (response.data != null) {
          final result = await ImageGallerySaverPlus.saveImage(
            Uint8List.fromList(response.data!),
            quality: 100,
            name: 'dwellly_image_${DateTime.now().millisecondsSinceEpoch}',
          );

          if (mounted) {
            if (result['isSuccess'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved to gallery')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to save: ${result['errorMessage']}'),
                ),
              );
            }
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission required')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_currentIndex + 1} / ${widget.imageUrls.length}',
          style: GoogleFonts.outfit(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save_alt),
            onPressed: _isSaving ? null : _saveToGallery,
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Hero(
                tag: 'image_${widget.imageUrls[index]}',
                child: Image.network(
                  widget.imageUrls[index],
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MediaPreviewScreen extends ConsumerStatefulWidget {
  final String filePath;
  final String messageType;
  final bool isMultiple;
  final List<String>? multiplePaths;
  final int userId;

  const MediaPreviewScreen({
    super.key,
    required this.filePath,
    required this.messageType,
    required this.userId,
    this.isMultiple = false,
    this.multiplePaths,
  });

  @override
  ConsumerState<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends ConsumerState<MediaPreviewScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      final controller = ref.read(chatHistoryProvider(widget.userId).notifier);

      if (widget.messageType == 'image') {
        if (widget.isMultiple && widget.multiplePaths != null) {
          for (final path in widget.multiplePaths!) {
            final compressedBytes = await _compressImage(File(path));
            if (compressedBytes != null) {
              final base64String = base64Encode(compressedBytes);
              final fileName = path.split('/').last;
              final attachmentUrl = await controller.uploadAttachment(
                base64String,
                fileName,
              );
              if (attachmentUrl != null) {
                await controller.sendAttachmentMessage(
                  messageType: 'image',
                  attachmentUrl: attachmentUrl,
                  attachmentSize: compressedBytes.length,
                  message: _captionController.text.trim().isNotEmpty
                      ? _captionController.text.trim()
                      : null,
                );
              }
            }
          }
        } else {
          final compressedBytes = await _compressImage(File(widget.filePath));
          if (compressedBytes != null) {
            final base64String = base64Encode(compressedBytes);
            final fileName = widget.filePath.split('/').last;
            final attachmentUrl = await controller.uploadAttachment(
              base64String,
              fileName,
            );
            if (attachmentUrl != null) {
              await controller.sendAttachmentMessage(
                messageType: 'image',
                attachmentUrl: attachmentUrl,
                attachmentSize: compressedBytes.length,
                message: _captionController.text.trim().isNotEmpty
                    ? _captionController.text.trim()
                    : null,
              );
            }
          }
        }
      } else if (widget.messageType == 'file') {
        final file = File(widget.filePath);
        final bytes = await file.readAsBytes();
        final base64String = base64Encode(bytes);
        final fileName = widget.filePath.split('/').last;
        final attachmentUrl = await controller.uploadAttachment(
          base64String,
          fileName,
        );
        if (attachmentUrl != null) {
          await controller.sendAttachmentMessage(
            messageType: 'file',
            attachmentUrl: attachmentUrl,
            attachmentSize: bytes.length,
            attachmentName: fileName,
            message: _captionController.text.trim().isNotEmpty
                ? _captionController.text.trim()
                : null,
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<Uint8List?> _compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);
      int width = decodedImage.width;
      int height = decodedImage.height;
      const maxWidth = 1200;
      if (width > maxWidth) {
        height = (height * maxWidth / width).round();
        width = maxWidth;
      }
      return bytes;
    } catch (e) {
      return await file.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.messageType == 'image' ? 'Photo' : 'File',
          style: GoogleFonts.outfit(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: widget.messageType == 'image'
                ? Image.file(
                    File(widget.filePath),
                    fit: BoxFit.contain,
                  )
                : Container(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.insert_drive_file,
                            color: AppTheme.primaryGreen,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.filePath.split('/').last,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _captionController,
                          style: GoogleFonts.outfit(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Add a caption...',
                            hintStyle: GoogleFonts.outfit(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _isSending ? null : _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isSending
                              ? Colors.grey
                              : AppTheme.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: _isSending
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
