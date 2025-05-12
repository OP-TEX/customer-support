import 'package:support/features/customer_support/models/complaint.dart';

abstract class ComplaintsState {}

class ComplaintsInitial extends ComplaintsState {}

class ComplaintsLoading extends ComplaintsState {}

class ComplaintsLoaded extends ComplaintsState {
  final List<Complaint> complaints;

  ComplaintsLoaded(this.complaints);

  ComplaintsLoaded copyWith({List<Complaint>? complaints}) {
    return ComplaintsLoaded(complaints ?? this.complaints);
  }
}

class ComplaintsError extends ComplaintsState {
  final String message;

  ComplaintsError(this.message);
}
