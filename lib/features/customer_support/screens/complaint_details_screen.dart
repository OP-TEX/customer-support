import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/theming/app_theme.dart';
import 'package:support/features/customer_support/models/complaint.dart';
import 'package:support/features/customer_support/models/order.dart';
import 'package:support/features/customer_support/models/user_contact.dart';
import 'package:support/features/customer_support/services/support_api_service.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final Complaint complaint;

  const ComplaintDetailsScreen({Key? key, required this.complaint})
    : super(key: key);

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final SupportApiService _apiService = getIt<SupportApiService>();
  bool _loading = true;
  Order? _order;
  UserContact? _userContact;
  String? _errorMessage;
  bool _resolving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final orderFuture = _apiService.getOrderDetails(widget.complaint.orderId);
      final userFuture = _apiService.getUserContact(widget.complaint.userId);

      final results = await Future.wait([orderFuture, userFuture]);

      setState(() {
        _order = results[0] as Order;
        _userContact = results[1] as UserContact;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _resolveComplaint() async {
    setState(() {
      _resolving = true;
    });

    try {
      await _apiService.resolveComplaint(widget.complaint.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint resolved successfully')),
      );
      Navigator.pop(context, true); // Return true to indicate resolved
    } catch (e) {
      setState(() {
        _resolving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resolving complaint: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Details', style: TextStyle(fontSize: 20.sp)),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $_errorMessage'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildComplaintSection(),
                    SizedBox(height: 20.h),
                    _buildUserSection(),
                    SizedBox(height: 20.h),
                    _buildOrderSection(),
                    SizedBox(height: 30.h),
                    if (widget.complaint.status.toLowerCase() != 'resolved')
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _resolving ? null : _resolveComplaint,
                          icon:
                              _resolving
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Icon(Icons.check_circle),
                          label: Text(
                            _resolving ? 'Resolving...' : 'Resolve Complaint',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 16.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }

  Widget _buildComplaintSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaint Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            Divider(height: 24.h),
            _infoRow('Subject', widget.complaint.subject),
            SizedBox(height: 8.h),
            _infoRow('Description', widget.complaint.description),
            SizedBox(height: 8.h),
            _infoRow(
              'Status',
              widget.complaint.status,
              valueColor: _statusColor(widget.complaint.status),
            ),
            SizedBox(height: 8.h),
            _infoRow(
              'Created',
              widget.complaint.createdAt.toString().substring(0, 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection() {
    if (_userContact == null) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            Divider(height: 24.h),
            _infoRow('Name', _userContact!.fullName),
            SizedBox(height: 8.h),
            _infoRow('Email', _userContact!.email),
            SizedBox(height: 8.h),
            _infoRow('Phone', _userContact!.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSection() {
    if (_order == null) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Information',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            Divider(height: 24.h),
            _infoRow('Order ID', _order!.orderId),
            SizedBox(height: 8.h),
            _infoRow('Status', _order!.status),
            SizedBox(height: 8.h),
            _infoRow('Payment Method', _order!.paymentMethod),
            SizedBox(height: 8.h),
            _infoRow(
              'Total Amount',
              '\$${_order!.totalPrice.toStringAsFixed(2)}',
            ),
            SizedBox(height: 16.h),

            Text(
              'Products',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),

            ..._order!.products.map((product) => _buildProductItem(product)),

            SizedBox(height: 16.h),
            Text(
              'Shipping Address',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              '${_order!.address.street}, Building ${_order!.address.building}, Floor ${_order!.address.floor}, Apt ${_order!.address.apartment}, ${_order!.address.city}, ${_order!.address.governorate}',
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(OrderProduct product) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.productImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                product.productImage,
                width: 60.w,
                height: 60.w,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      width: 60.w,
                      height: 60.w,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 30.w,
                        color: Colors.grey[600],
                      ),
                    ),
              ),
            )
          else
            Container(
              width: 60.w,
              height: 60.w,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 30.w, color: Colors.grey[600]),
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Quantity: ${product.quantity} × \$${product.productPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Subtotal: \$${(product.quantity * product.productPrice).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ),
      ],
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
