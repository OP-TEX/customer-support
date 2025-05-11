class Complaint {
  final String id;
  final String orderId;
  final String userId;
  final String subject;
  final String description;
  final String status;
  final String assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Complaint({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.subject,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['_id'],
      orderId: json['orderId'],
      userId: json['userId'],
      subject: json['subject'],
      description: json['description'] ?? '',
      status: json['status'],
      assignedTo: json['assignedTo'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }



  Complaint copyWith({
    String? id,
    String? orderId,
    String? userId,
    String? subject,
    String? description,
    String? status,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Complaint(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
