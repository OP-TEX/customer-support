class Order {
  final String id;
  final String orderId;
  final String status;
  final List<OrderProduct> products;
  final double totalPrice;
  final String userId;
  final String paymentMethod;
  final Address address;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.orderId,
    required this.status,
    required this.products,
    required this.totalPrice,
    required this.userId,
    required this.paymentMethod,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      orderId: json['orderId'],
      status: json['status'],
      products:
          (json['products'] as List)
              .map((p) => OrderProduct.fromJson(p))
              .toList(),
      totalPrice: json['totalPrice'].toDouble(),
      userId: json['userId'],
      paymentMethod: json['payment_method'],
      address: Address.fromJson(json['address']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class OrderProduct {
  final String id;
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final int quantity;

  OrderProduct({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['_id'],
      productId: json['productId'],
      productName: json['productName'],
      productPrice: json['productPrice'].toDouble(),
      productImage: json['productImage'] ?? '',
      quantity: json['quantity'],
    );
  }
}

class Address {
  final String street;
  final String governorate;
  final String city;
  final String building;
  final String floor;
  final String apartment;

  Address({
    required this.street,
    required this.governorate,
    required this.city,
    required this.building,
    required this.floor,
    required this.apartment,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      governorate: json['Gover'] ?? '',
      city: json['city'] ?? '',
      building: json['building'] ?? '',
      floor: json['floor'] ?? '',
      apartment: json['apartment'] ?? '',
    );
  }
}
