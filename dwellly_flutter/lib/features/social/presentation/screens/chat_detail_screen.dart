import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dwellly_client/room_rental_client.dart';
import 'package:dwellly_flutter/core/theme/app_theme.dart';
import 'package:dwellly_flutter/features/social/presentation/controllers/chat_controller.dart';
import 'package:dwellly_flutter/features/auth/presentation/providers/user_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final int userId;
  final String userName;
  final String avatarUrl;
  final bool isOnline;

  const ChatDetailScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.avatarUrl,
    required this.isOnline,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  String? _recordingPath;
  DateTime? _recordingStartTime;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  bool _isSending = false;
  String? _sendingType;

  final Map<int, AudioPlayer> _audioPlayers = {};
  final Map<int, StreamSubscription> _playerSubscriptions = {};
  final Map<int, Duration> _playerPositions = {};
  final Map<int, Duration> _playerDurations = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatHistoryProvider(widget.userId).notifier).markRead();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primaryGreen,
                  child: Icon(Icons.photo_library, color: Colors.white),
                ),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMultipleImages();
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primaryGreen,
                  child: Icon(Icons.camera_alt, color: Colors.white),
                ),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primaryGreen,
                  child: Icon(Icons.insert_drive_file, color: Colors.white),
                ),
                title: const Text('Document'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFile();
                },
              ),
            ],
          ),
        ),
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
        setState(() {
          _isSending = true;
          _sendingType = 'image';
        });

        for (final image in images) {
          await _sendImageWithCompression(image.path);
        }

        setState(() {
          _isSending = false;
          _sendingType = null;
        });
      }
    } catch (e) {
      setState(() {
        _isSending = false;
        _sendingType = null;
      });
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
        setState(() {
          _isSending = true;
          _sendingType = 'image';
        });
        await _sendImageWithCompression(image.path);
        setState(() {
          _isSending = false;
          _sendingType = null;
        });
      }
    } catch (e) {
      setState(() {
        _isSending = false;
        _sendingType = null;
      });
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
        setState(() {
          _isSending = true;
          _sendingType = 'file';
        });
        await _sendAttachment(result.files.single.path!, 'file');
        setState(() {
          _isSending = false;
          _sendingType = null;
        });
      }
    } catch (e) {
      setState(() {
        _isSending = false;
        _sendingType = null;
      });
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

        setState(() {
          _isRecording = true;
          _recordingPath = path;
          _recordingStartTime = DateTime.now();
          _recordingDuration = 0;
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

  Future<void> _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
      });

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
        _isSending = false;
        _sendingType = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error stopping recording: $e')),
        );
      }
    }
  }

  Future<void> _toggleVoicePlayback(ChatMessage message) async {
    if (message.attachmentUrl == null) return;

    final messageId = message.id;
    if (messageId == null) return;

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
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.avatarUrl),
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
                    _scrollToBottom();
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe =
                            message.senderId == currentUserId ||
                            (message.sender?.userInfoId == currentUserId);
                        return _buildMessageBubble(message, isMe, messages);
                      },
                    );
                  },
                  loading: () => _buildSkeletonMessages(),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
              _buildMessageInput(),
            ],
          ),
          if (_isSending) _buildSendingOverlay(),
        ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.mic, color: Colors.red),
          const SizedBox(width: 12),
          Text(
            'Recording... ${_formatDuration(_recordingDuration)}',
            style: GoogleFonts.outfit(color: Colors.red),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _stopRecording,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Send',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
          onLongPressEnd: (_) => _stopRecording(),
          child: CircleAvatar(
            backgroundColor: AppTheme.primaryGreen,
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
        final msgIsMe =
            msg.senderId == message.senderId ||
            (msg.sender?.userInfoId == message.sender?.userInfoId);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withOpacity(0.2)
                  : AppTheme.primaryGreen.withOpacity(0.1),
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
                          ? Colors.white.withOpacity(0.7)
                          : AppTheme.secondaryGray,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_currentIndex + 1} / ${widget.imageUrls.length}',
          style: GoogleFonts.outfit(color: Colors.white),
        ),
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
