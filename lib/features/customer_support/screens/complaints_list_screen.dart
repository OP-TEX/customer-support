import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';
import 'package:support/features/customer_support/models/complaint.dart';
import 'package:support/features/customer_support/screens/support_chat_screen.dart';
import 'package:support/features/customer_support/services/support_api_service.dart';
import 'package:support/core/theming/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ComplaintsListScreen extends StatefulWidget {
  const ComplaintsListScreen({super.key});

  @override
  State<ComplaintsListScreen> createState() => _ComplaintsListScreenState();
}

class _ComplaintsListScreenState extends State<ComplaintsListScreen> {
  final SupportApiService _supportApiService = getIt<SupportApiService>();
  List<Complaint> complaints = [];
  late Future<List<Complaint>> _complaintsFuture;
  late IO.Socket supportSocket;
  String? _userId;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _complaintsFuture = _supportApiService.getAssignedComplaints();
    _initAuthAndConnect();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    final loaded = await _complaintsFuture;
    setState(() {
      complaints = loaded;
    });
  }

  Future<void> _initAuthAndConnect() async {
    final authService = getIt<AuthService>();
    _accessToken = await authService.getAccessToken();
    _userId = await authService.getUserId();
    _initSocket();
  }

  void _initSocket() {
    supportSocket = IO.io(
      'wss://optexeg.me/support-requests',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setAuth({'token': _accessToken})
        .build(),
    );
    supportSocket.connect();
    supportSocket.onConnect((_) {
      print('[Socket] Connected to /support-requests with $_accessToken');
      supportSocket.emit('join-room', 'service-room');
      print('[Socket] Emitted join-room: service-room');
    });

    supportSocket.on('new-complaint', (data) {
      print('[Socket] new-complaint event: $data');
      setState(() {
        complaints.insert(
          0,
          Complaint(
            id: data['complaintId'] ?? '',
            orderId: data['orderId'] ?? '',
            userId: data['userId'] ?? '',
            subject: data['subject'] ?? '',
            description: data['description'] ?? '',
            status: data['status'] ?? 'open',
            assignedTo: data['assignedTo'] ?? '',
            createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
            updatedAt: DateTime.tryParse(data['updatedAt'] ?? '') ?? DateTime.now(),
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New complaint received: ${data['subject']}')),
      );
    });

    supportSocket.on('complaint-status', (data) {
      print('[Socket] complaint-status event: $data');
      final idx = complaints.indexWhere((c) => c.id == data['complaintId']);
      if (idx != -1) {
        setState(() {
          complaints[idx] = complaints[idx].copyWith(
            status: data['status'] ?? complaints[idx].status,
          );
        });
      }
    });

    supportSocket.on('service-status-change', (data) {
      print('[Socket] service-status-change event: $data');
    });

    supportSocket.on('error', (data) {
      print('[Socket] error event: $data');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Socket error: ${data['message']}')),
      );
    });
  }

  @override
  void dispose() {
    supportSocket.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final loaded = await _supportApiService.getAssignedComplaints();
    setState(() {
      complaints = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Complaints', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: complaints.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: complaints.length,
                itemBuilder: (context, i) {
                  final c = complaints[i];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16.h),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.w),
                      title: Text(c.subject, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.h),
                          Text('Order: ${c.orderId}', style: TextStyle(fontSize: 14.sp)),
                          SizedBox(height: 2.h),
                          Text('Status: ${c.status}', style: TextStyle(fontSize: 14.sp, color: _statusColor(c.status))),
                          SizedBox(height: 2.h),
                          Text('Created: ${c.createdAt}', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right, size: 28.sp),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SupportChatScreen(
                              complaint: c,
                              //apiService: SupportApiService.instance,
                            ),
                          ),
                        );
                        _refresh();
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'pending':
        return Colors.amber;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}
