import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';
import 'package:support/features/customer_support/models/complaint.dart';
import 'package:support/features/customer_support/models/chat_message.dart';
import 'package:support/features/customer_support/services/support_api_service.dart';
import 'package:support/core/theming/app_theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SupportChatScreen extends StatefulWidget {
  final Complaint complaint;
  final SupportApiService apiService = getIt<SupportApiService>();
  SupportChatScreen({super.key, required this.complaint});
  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  late IO.Socket chatSocket;
  List<ChatMessage> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isResolved = false;
  bool _loading = true;
  String? _userId;
  String? _accessToken;

  // Mock chat messages
  final List<ChatMessage> mockMessages = [
    ChatMessage(
      id: 'm1',
      sender: 'customer',
      senderId: 'U-1',
      content: 'Hello, my laptop is not working.',
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    ),
    ChatMessage(
      id: 'm2',
      sender: 'service',
      senderId: 'agent-1',
      content: 'Hi! Can you describe the issue in detail?',
      timestamp: DateTime.now().subtract(Duration(minutes: 28)),
    ),
    ChatMessage(
      id: 'm3',
      sender: 'customer',
      senderId: 'U-1',
      content: 'It does not power on at all.',
      timestamp: DateTime.now().subtract(Duration(minutes: 27)),
    ),
    ChatMessage(
      id: 'm4',
      sender: 'service',
      senderId: 'agent-1',
      content: 'Have you tried charging it with another adapter?',
      timestamp: DateTime.now().subtract(Duration(minutes: 25)),
    ),
    ChatMessage(
      id: 'm5',
      sender: 'customer',
      senderId: 'U-1',
      content: 'Yes, still not working.',
      timestamp: DateTime.now().subtract(Duration(minutes: 24)),
    ),
    ChatMessage(
      id: 'm6',
      sender: 'service',
      senderId: 'agent-1',
      content: 'We will arrange a pickup for repair.',
      timestamp: DateTime.now().subtract(Duration(minutes: 22)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchHistoryAndConnect();
  }

  Future<void> _fetchHistoryAndConnect() async {
    final history = await widget.apiService.getChatHistory(widget.complaint.id);
    setState(() {
      messages = history;
      _loading = false;
      _isResolved = widget.complaint.status.toLowerCase() == 'resolved';
    });
    _initAuthAndConnect();
  }

      Future<void> _initAuthAndConnect() async {
    final authService = getIt<AuthService>();
    _accessToken = await authService.getAccessToken();
    _userId = await authService.getUserId();
    _initSocket();
  }

  void _initSocket() {
    chatSocket = IO.io(
      'wss://optexeg.me/support-chat',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setAuth({'token': _accessToken})
        .build(),
    );
    chatSocket.connect();
    chatSocket.onConnect((_) {
      chatSocket.emit('join-chat', widget.complaint.id);
    });
    chatSocket.on('chat-history', (data) {
      setState(() {
        messages = (data as List).map((msg) => ChatMessage.fromJson(msg)).toList();
      });
      _scrollToBottom();
    });
    chatSocket.on('new-message', (data) {
      setState(() {
        messages.add(ChatMessage.fromJson(data));
      });
      _scrollToBottom();
    });
    chatSocket.on('complaint-resolved', (_) {
      setState(() => _isResolved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint has been resolved.'))
      );
    });
    chatSocket.onError((error) => print('Socket Error: $error'));
    chatSocket.onDisconnect((_) => print('Socket Disconnected'));
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty || _isResolved) return;
    chatSocket.emit('send-message', {
      'complaintId': widget.complaint.id,
      'content': _messageController.text
    });
    _messageController.clear();
  }

  void _resolveComplaint() async {
    await widget.apiService.resolveComplaint(widget.complaint.id);
    chatSocket.emit('resolve-complaint', widget.complaint.id);
    setState(() => _isResolved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complaint resolved!'))
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    chatSocket.emit('leave-chat', widget.complaint.id);
    chatSocket.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Chat', style: TextStyle(fontSize: 18.sp)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, size: 22.sp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Complaint Details'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Subject: ${widget.complaint.subject}'),
                      Text('Order: ${widget.complaint.orderId}'),
                      Text('Status: ${widget.complaint.status}'),
                      Text('Created: ${widget.complaint.createdAt}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(12.w),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.sender == 'service';
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppTheme.primaryColor.withOpacity(0.15)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.content,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!_isResolved)
                  Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            enabled: !_isResolved,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        FloatingActionButton(
                          onPressed: _sendMessage,
                          backgroundColor: AppTheme.primaryColor,
                          mini: true,
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!_isResolved)
                        ElevatedButton.icon(
                          onPressed: _resolveComplaint,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Resolve Complaint'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                          ),
                        ),
                      Text(
                        _isResolved ? 'Resolved' : 'Open',
                        style: TextStyle(
                          color: _isResolved ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
