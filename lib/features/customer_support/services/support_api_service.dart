import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:support/features/customer_support/models/complaint.dart';
import 'package:support/features/customer_support/models/chat_message.dart';
import 'package:support/features/customer_support/models/performance_stats.dart';

class SupportApiService {
  
  final Dio dio;
  SupportApiService(this.dio);
  // static final SupportApiService instance = SupportApiService._internal();



  // factory SupportApiService(Dio? _) => instance;

  Future<List<Complaint>> getAssignedComplaints() async {
    final response = await dio.get('/support/assigned');
    return (response.data as List)
        .map((e) => Complaint.fromJson(e))
        .toList();
  }

  Future<void> resolveComplaint(String complaintId) async {
    await dio.put('/support/resolve/$complaintId');
  }

  Future<List<ChatMessage>> getChatHistory(String complaintId) async {
    final response = await dio.get('/support/chat/$complaintId');
    return (response.data as List)
        .map((e) => ChatMessage.fromJson(e))
        .toList();
  }

  Future<PerformanceStats> getPerformanceStats({String period = 'today'}) async {
    final response = await dio.get('/support/performance', queryParameters: {'period': period});
    return PerformanceStats.fromJson(response.data);
  }
}
