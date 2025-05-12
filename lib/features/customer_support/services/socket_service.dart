import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:support/features/customer_support/models/complaint.dart';

class SocketService {
  late IO.Socket supportSocket;
  final void Function(Complaint) onNewComplaint;
  final void Function(Complaint) onComplaintAssigned;
  final void Function(String, String) onComplaintStatusChange;
  final void Function(dynamic) onServiceStatusChange;
  final void Function(String) onError;

  SocketService({
    required this.onNewComplaint,
    required this.onComplaintAssigned,
    required this.onComplaintStatusChange,
    required this.onServiceStatusChange,
    required this.onError,
  });

  void connect(String accessToken, String? userId) {
    supportSocket = IO.io(
      'wss://optexeg.me/support-requests',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': accessToken})
          .build(),
    );
    supportSocket.connect();
    _setupEventListeners(userId);
  }

  void _setupEventListeners(String? userId) {
    supportSocket.onConnect((_) {
      print('[Socket] Connected to /support-requests');
      supportSocket.emit('join-room', 'service-room');
      print('[Socket] Emitted join-room: service-room');

      // Join personal room for agent-specific notifications
      if (userId != null) {
        supportSocket.emit('join-room', 'user-$userId');
        print('[Socket] Emitted join personal room: user-$userId');
      }
    });

    supportSocket.on('new-complaint', (data) {
      print('[Socket] new-complaint event: $data');
      final complaint = Complaint(
        id: data['complaintId'] ?? '',
        orderId: data['orderId'] ?? '',
        userId: data['userId'] ?? '',
        subject: data['subject'] ?? '',
        description: data['description'] ?? '',
        status: data['status'] ?? 'open',
        assignedTo: data['assignedTo'] ?? '',
        createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(data['updatedAt'] ?? '') ?? DateTime.now(),
        requiresLiveChat: data['requiresLiveChat'] ?? false,
      );
      onNewComplaint(complaint);
    });

    supportSocket.on('complaint-assigned', (data) {
      print('[Socket] complaint-assigned event: $data');
      final complaint = Complaint(
        id: data['complaintId'] ?? '',
        orderId: data['orderId'] ?? '',
        userId: data['customer']?['id'] ?? '',
        subject: data['subject'] ?? '',
        description: data['description'] ?? '',
        status: 'open',
        assignedTo: userId ?? '',
        createdAt: DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
        requiresLiveChat:
            data['requiresLiveChat'] ??
            false, // Get the actual value from server
      );
      onComplaintAssigned(complaint);
    });

    supportSocket.on('complaint-status', (data) {
      print('[Socket] complaint-status event: $data');
      onComplaintStatusChange(data['complaintId'] ?? '', data['status'] ?? '');
    });

    supportSocket.on('service-status-change', (data) {
      print('[Socket] service-status-change event: $data');
      onServiceStatusChange(data);
    });

    supportSocket.on('error', (data) {
      print('[Socket] error event: $data');
      onError(data['message'] ?? 'Unknown error');
    });
  }

  void dispose() {
    supportSocket.dispose();
  }
}
