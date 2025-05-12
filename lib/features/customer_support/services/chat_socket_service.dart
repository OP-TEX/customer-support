import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:support/features/customer_support/models/chat_message.dart';

class ChatSocketService {
  late IO.Socket chatSocket;
  final String complaintId;
  final String? accessToken;
  final Function(List<ChatMessage>) onChatHistory;
  final Function(ChatMessage) onNewMessage;
  final Function() onComplaintResolved;
  final Function(dynamic) onError;

  ChatSocketService({
    required this.complaintId,
    required this.accessToken,
    required this.onChatHistory,
    required this.onNewMessage,
    required this.onComplaintResolved,
    required this.onError,
  });

  void connect() {
    chatSocket = IO.io(
      'wss://optexeg.me/support-chat',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setAuth({'token': accessToken})
        .build(),
    );
    
    chatSocket.connect();
    _setupListeners();
  }

  void _setupListeners() {
    chatSocket.onConnect((_) {
      chatSocket.emit('join-chat', complaintId);
    });
    
    chatSocket.on('chat-history', (data) {
      final messages = (data as List).map((msg) => ChatMessage.fromJson(msg)).toList();
      onChatHistory(messages);
    });
    
    chatSocket.on('new-message', (data) {
      final message = ChatMessage.fromJson(data);
      onNewMessage(message);
    });
    
    // Listen for both events that indicate a complaint has been resolved
    chatSocket.on('complaint-resolved', (_) {
      onComplaintResolved();
    });
    
    chatSocket.on('resolve-complaint', (_) {
      onComplaintResolved();
    });
    
    chatSocket.onError((error) {
      print('Socket Error: $error');
      onError(error);
    });
    
    chatSocket.onDisconnect((_) => print('Socket Disconnected'));
  }

  void sendMessage(String content) {
    chatSocket.emit('send-message', {
      'complaintId': complaintId,
      'content': content,
    });
  }

  void resolveComplaint() {
    chatSocket.emit('resolve-complaint', complaintId);
  }

  void disconnect() {
    chatSocket.emit('leave-chat', complaintId);
    chatSocket.disconnect();
    chatSocket.dispose();
  }
}
