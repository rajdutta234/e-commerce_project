import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double total;
  final String status;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'],
        userId: json['userId'],
        items: (json['items'] as List)
            .map((e) => CartItemModel.fromJson(e))
            .toList(),
        total: (json['total'] as num).toDouble(),
        status: json['status'],
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'status': status,
        'date': date.toIso8601String(),
      };
} 