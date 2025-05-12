import 'package:support/features/customer_support/models/chat_message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isResolved;
  
  ChatLoaded({
    required this.messages, 
    this.isResolved = false,
  });
  
  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isResolved,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isResolved: isResolved ?? this.isResolved,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  
  ChatError(this.message);
}
