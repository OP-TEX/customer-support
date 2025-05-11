import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/features/customer_support/models/performance_stats.dart';
import 'package:support/features/customer_support/services/support_api_service.dart';
import 'package:support/core/theming/app_theme.dart';
import 'package:dio/dio.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final SupportApiService _supportApiService = getIt<SupportApiService>();
  late Future<PerformanceStats> _statsFuture;
  String _period = 'today';

  @override
  void initState() {
    super.initState();
    _statsFuture = _supportApiService.getPerformanceStats(period: _period);
  }

  void _changePeriod(String period) {
    setState(() {
      _period = period;
      _statsFuture = _supportApiService.getPerformanceStats(period: period);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance Statistics', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Responses', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 24.h),
            Row(
              children: [
                _periodButton('today', 'Today'),
                SizedBox(width: 12.w),
                _periodButton('week', 'Week'),
                SizedBox(width: 12.w),
                _periodButton('month', 'Month'),
                SizedBox(width: 12.w),
                _periodButton('all', 'All'),
              ],
            ),
            SizedBox(height: 32.h),
            FutureBuilder<PerformanceStats>(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final stats = snapshot.data;
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Center(
                      child: Text(
                        stats == null ? '-' : stats.responses.toString(),
                        style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodButton(String value, String label) {
    return ElevatedButton(
      onPressed: () => _changePeriod(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: _period == value ? AppTheme.primaryColor : Colors.grey[200],
        foregroundColor: _period == value ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(label, style: TextStyle(fontSize: 16.sp)),
    );
  }
}
