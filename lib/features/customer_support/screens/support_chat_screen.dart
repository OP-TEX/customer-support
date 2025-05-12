import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/features/customer_support/cubit/chat_cubit.dart';
import 'package:support/features/customer_support/cubit/chat_state.dart';
import 'package:support/features/customer_support/models/complaint.dart';
import 'package:support/core/theming/app_theme.dart';

class SupportChatScreen extends StatelessWidget {
  final Complaint complaint;
  
  const SupportChatScreen({super.key, required this.complaint});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(complaint: complaint),
      child: _SupportChatView(complaint: complaint),
    );
  }
}

class _SupportChatView extends StatefulWidget {
  final Complaint complaint;
  
  const _SupportChatView({required this.complaint});
  
  @override
  State<_SupportChatView> createState() => _SupportChatViewState();
}

class _SupportChatViewState extends State<_SupportChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.complaint.requiresLiveChat ? 'Live Chat Support' : 'Complaint Chat',
          style: TextStyle(fontSize: 18.sp),
        ),
        backgroundColor: widget.complaint.requiresLiveChat ? Colors.red : AppTheme.primaryColor,
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
                      Text('Type: ${widget.complaint.requiresLiveChat ? "Live Chat" : "Regular"}'),
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
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            // Scroll to bottom when messages change
            _scrollToBottom();
            
            // Show snackbar when complaint is resolved
            if (state.isResolved && widget.complaint.status.toLowerCase() != 'resolved') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Complaint has been resolved.')),
              );
            }
          } else if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatInitial || state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            final messages = state.messages;
            final isResolved = state.isResolved;
            
            return Column(
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
                if (!isResolved)
                  Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            enabled: !isResolved,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            ),
                            onSubmitted: (_) => _sendMessage(context),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        FloatingActionButton(
                          onPressed: () => _sendMessage(context),
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
                      if (!isResolved)
                        ElevatedButton.icon(
                          onPressed: () => _resolveComplaint(context),
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Resolve Complaint'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                          ),
                        ),
                      Text(
                        isResolved ? 'Resolved' : 'Open',
                        style: TextStyle(
                          color: isResolved ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Error state
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Something went wrong'),
                  ElevatedButton(
                    onPressed: () => context.read<ChatCubit>()..close()..emit(ChatInitial()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  
  void _sendMessage(BuildContext context) {
    if (_messageController.text.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(_messageController.text);
      _messageController.clear();
    }
  }
  
  void _resolveComplaint(BuildContext context) {
    context.read<ChatCubit>().resolveComplaint();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complaint resolved!')),
    );
  }
}
