import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';
import 'package:support/features/customer_support/cubit/chat_state.dart';
import 'package:support/features/customer_support/models/chat_message.dart';
import 'package:support/features/customer_support/models/complaint.dart';
import 'package:support/features/customer_support/services/chat_socket_service.dart';
import 'package:support/features/customer_support/services/support_api_service.dart';

class ChatCubit extends Cubit<ChatState> {
  final SupportApiService _apiService = getIt<SupportApiService>();
  final Complaint complaint;
  late ChatSocketService _socketService;
  String? _userId;
  String? _accessToken;
  
  ChatCubit({required this.complaint}) : super(ChatInitial()) {
    _init();
  }
  
  Future<void> _init() async {
    emit(ChatLoading());
    await _initAuth();
    await _loadChatHistory();
  }
  
  Future<void> _initAuth() async {
    final authService = getIt<AuthService>();
    _accessToken = await authService.getAccessToken();
    _userId = await authService.getUserId();
  }
  
  Future<void> _loadChatHistory() async {
    try {
      final messages = await _apiService.getChatHistory(complaint.id);
      final isResolved = complaint.status.toLowerCase() == 'resolved';
      
      emit(ChatLoaded(messages: messages, isResolved: isResolved));
      _initSocket();
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
  
  void _initSocket() {
    _socketService = ChatSocketService(
      complaintId: complaint.id,
      accessToken: _accessToken,
      onChatHistory: _handleChatHistory,
      onNewMessage: _handleNewMessage,
      onComplaintResolved: _handleComplaintResolved,
      onError: _handleError,
    );
    
    _socketService.connect();
  }
  
  void _handleChatHistory(List<ChatMessage> messages) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(currentState.copyWith(messages: messages));
    }
  }
  
  void _handleNewMessage(ChatMessage message) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedMessages = [...currentState.messages, message];
      emit(currentState.copyWith(messages: updatedMessages));
    }
  }
  
  void _handleComplaintResolved() {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      emit(currentState.copyWith(isResolved: true));
    }
  }
  
  void _handleError(dynamic error) {
    // Could log the error or show a notification
    print('Socket error: $error');
  }
  
  void sendMessage(String content) {
    if (state is ChatLoaded && content.isNotEmpty && !(state as ChatLoaded).isResolved) {
      _socketService.sendMessage(content);
    }
  }
  
  Future<void> resolveComplaint() async {
    try {
      await _apiService.resolveComplaint(complaint.id);
      _socketService.resolveComplaint();
      
      if (state is ChatLoaded) {
        final currentState = state as ChatLoaded;
        emit(currentState.copyWith(isResolved: true));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
  
  @override
  Future<void> close() {
    _socketService.disconnect();
    return super.close();
  }
}
