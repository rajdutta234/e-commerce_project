import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy orders
    final orders = [
      {
        'id': '1',
        'status': 'Delivered',
        'date': '2024-07-18',
        'total': 200.0,
      },
      {
        'id': '2',
        'status': 'Shipped',
        'date': '2024-07-17',
        'total': 120.0,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text('Order #${order['id']}'),
              subtitle: Text('Status: ${order['status']}\nDate: ${order['date']}'),
              trailing: Text('₹${order['total']}'),
            ),
          );
        },
      ),
    );
  }
} 