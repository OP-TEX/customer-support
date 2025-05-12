import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';
import 'package:support/features/customer_support/cubit/complaints_cubit.dart';
import 'package:support/features/customer_support/cubit/complaints_state.dart';
import 'package:support/features/customer_support/models/complaint.dart';
import 'package:support/features/customer_support/screens/complaint_details_screen.dart';
import 'package:support/features/customer_support/screens/support_chat_screen.dart';
import 'package:support/features/customer_support/services/support_api_service.dart';
import 'package:support/core/theming/app_theme.dart';

class ComplaintsListScreen extends StatelessWidget {
  const ComplaintsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ComplaintsCubit(
            supportApiService: getIt<SupportApiService>(),
            authService: getIt<AuthService>(),
          ),
      child: DefaultTabController(
        length: 2,
        child: const _ComplaintsListView(),
      ),
    );
  }
}

class _ComplaintsListView extends StatelessWidget {
  const _ComplaintsListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assigned Complaints', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.article), text: 'Regular'),
            Tab(icon: Icon(Icons.chat), text: 'Live Chat'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: BlocConsumer<ComplaintsCubit, ComplaintsState>(
        listener: (context, state) {
          if (state is ComplaintsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ComplaintsInitial || state is ComplaintsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ComplaintsLoaded) {
            final complaints = state.complaints;

            if (complaints.isEmpty) {
              return const Center(child: Text('No complaints found'));
            }

            // Separate complaints by type
            final regularComplaints =
                complaints.where((c) => !c.requiresLiveChat).toList();
            final liveComplaints =
                complaints.where((c) => c.requiresLiveChat).toList();

            return TabBarView(
              children: [
                // Regular complaints tab
                _buildComplaintsList(context, regularComplaints, false),

                // Live chat complaints tab
                _buildComplaintsList(context, liveComplaints, true),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Something went wrong'),
                  ElevatedButton(
                    onPressed:
                        () => context.read<ComplaintsCubit>().loadComplaints(),
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

  Widget _buildComplaintsList(
    BuildContext context,
    List<Complaint> complaints,
    bool isLiveChat,
  ) {
    if (complaints.isEmpty) {
      return Center(
        child: Text(
          isLiveChat ? 'No live chat complaints' : 'No regular complaints',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ComplaintsCubit>().refreshComplaints(),
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
            color: isLiveChat ? Colors.red.shade50 : null,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.w),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      c.subject,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  if (isLiveChat)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6.h),
                  Text(
                    'Order: ${c.orderId}',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Status: ${c.status}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: _statusColor(c.status),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Created: ${c.createdAt.toLocal().toString().substring(0, 16)}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ],
              ),
              trailing: Icon(Icons.chevron_right, size: 28.sp),
              onTap: () async {
                final result =
                    isLiveChat
                        ? await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SupportChatScreen(complaint: c),
                          ),
                        )
                        : await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ComplaintDetailsScreen(complaint: c),
                          ),
                        );

                // Refresh if the complaint was resolved
                if (result == true) {
                  context.read<ComplaintsCubit>().refreshComplaints();
                }
              },
            ),
          );
        },
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
