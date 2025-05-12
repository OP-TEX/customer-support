import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';
import 'package:support/features/customer_support/cubit/complaints_state.dart';
import 'package:support/features/customer_support/models/complaint.dart';
import 'package:support/features/customer_support/services/socket_service.dart';
import 'package:support/features/customer_support/services/support_api_service.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final SupportApiService _supportApiService;
  final AuthService _authService;
  late SocketService _socketService;
  String? _userId;

  ComplaintsCubit({
    required SupportApiService supportApiService,
    required AuthService authService,
  }) : _supportApiService = supportApiService,
       _authService = authService,
       super(ComplaintsInitial()) {
    _initSocketService();
    loadComplaints();
  }

  void _initSocketService() {
    _socketService = SocketService(
      onNewComplaint: _handleNewComplaint,
      onComplaintAssigned: _handleComplaintAssigned,
      onComplaintStatusChange: _handleComplaintStatusChange,
      onServiceStatusChange: _handleServiceStatusChange,
      onError: _handleSocketError,
    );
    _initAuthAndConnect();
  }

  Future<void> _initAuthAndConnect() async {
    final accessToken = await _authService.getAccessToken();
    _userId = await _authService.getUserId();
    if (accessToken != null) {
      _socketService.connect(accessToken, _userId);
    }
  }

  void _handleNewComplaint(Complaint complaint) {
    if (state is ComplaintsLoaded) {
      final currentComplaints = (state as ComplaintsLoaded).complaints;
      emit(ComplaintsLoaded([complaint, ...currentComplaints]));
    }
  }

  void _handleComplaintAssigned(Complaint complaint) {
    if (state is ComplaintsLoaded) {
      final currentComplaints = (state as ComplaintsLoaded).complaints;
      // Check if complaint already exists to avoid duplicates
      if (!currentComplaints.any((c) => c.id == complaint.id)) {
        emit(ComplaintsLoaded([complaint, ...currentComplaints]));
      }
    }
  }

  void _handleComplaintStatusChange(String complaintId, String status) {
    if (state is ComplaintsLoaded) {
      final currentComplaints = (state as ComplaintsLoaded).complaints;
      final updatedComplaints =
          currentComplaints.map((complaint) {
            if (complaint.id == complaintId) {
              return complaint.copyWith(status: status);
            }
            return complaint;
          }).toList();

      emit(ComplaintsLoaded(updatedComplaints));
    }
  }

  void _handleServiceStatusChange(dynamic data) {
    // Handle service status change if needed
  }

  void _handleSocketError(String message) {
    // Could emit an error state or handle the error in another way
    debugPrint('[Socket Error]: $message');
  }

  Future<void> loadComplaints() async {
    emit(ComplaintsLoading());
    try {
      final complaints = await _supportApiService.getAssignedComplaints();
      emit(ComplaintsLoaded(complaints));
    } catch (e) {
      emit(ComplaintsError(e.toString()));
    }
  }

  Future<void> refreshComplaints() async {
    try {
      final complaints = await _supportApiService.getAssignedComplaints();
      emit(ComplaintsLoaded(complaints));
    } catch (e) {
      emit(ComplaintsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _socketService.dispose();
    return super.close();
  }
}
