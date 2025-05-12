import 'package:dio/dio.dart';
import 'package:support/features/customer_support/models/complaint.dart';
import 'package:support/features/customer_support/models/chat_message.dart';
import 'package:support/features/customer_support/models/performance_stats.dart';
import 'package:support/features/customer_support/models/order.dart';
import 'package:support/features/customer_support/models/user_contact.dart';

class SupportApiService {
  final Dio dio;
  SupportApiService(this.dio);
  // static final SupportApiService instance = SupportApiService._internal();

  // factory SupportApiService(Dio? _) => instance;

  Future<List<Complaint>> getAssignedComplaints() async {
    // Get both types of complaints and combine them
    final regularComplaints = await getRegularComplaints();
    final liveChatComplaints = await getLiveChatComplaints();

    return [...regularComplaints, ...liveChatComplaints];
  }

  Future<List<Complaint>> getRegularComplaints() async {
    final response = await dio.get('/support/complaints/regular');
    return (response.data as List).map((e) => Complaint.fromJson(e)).toList();
  }

  Future<List<Complaint>> getLiveChatComplaints() async {
    final response = await dio.get('/support/complaints/live-chat');
    return (response.data as List).map((e) => Complaint.fromJson(e)).toList();
  }

  Future<void> resolveComplaint(String complaintId) async {
    await dio.put('/support/resolve/$complaintId');
  }

  Future<List<ChatMessage>> getChatHistory(String complaintId) async {
    final response = await dio.get('/support/chat/$complaintId');
    return (response.data as List).map((e) => ChatMessage.fromJson(e)).toList();
  }

  Future<PerformanceStats> getPerformanceStats({
    String period = 'today',
  }) async {
    final response = await dio.get(
      '/support/performance',
      queryParameters: {'period': period},
    );
    return PerformanceStats.fromJson(response.data);
  }

  Future<Order> getOrderDetails(String orderId) async {
    final response = await dio.get('/orders/$orderId');
    if (response.data['success'] == true && response.data['order'] != null) {
      return Order.fromJson(response.data['order']);
    } else {
      throw Exception('Failed to load order details');
    }
  }

  Future<UserContact> getUserContact(String userId) async {
    final response = await dio.get('user/contact/$userId');
    return UserContact.fromJson(response.data);
  }
}
