// OrderHistoryPage.dart
import 'package:flutter/material.dart';
import 'menu_item.dart';

class OrderHistoryPage extends StatelessWidget {
  final List<List<MenuItem>> orderHistory;

  const OrderHistoryPage({super.key, required this.orderHistory});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Order History'),
            backgroundColor: Colors.purple[800],
          ),
          body: ListView.builder(
            itemCount: orderHistory.length,
            itemBuilder: (context, index) {
              final order = orderHistory[index];
              final total = order.fold(0.0, (sum, item) => sum + item.price);
              return Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.white.withOpacity(0.8),
                child: ExpansionTile(
                  title: Text('Order ${orderHistory.length - index}', style: const TextStyle(color: Colors.black)),
                  subtitle: Text('Total: \$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black87)),
                  children: order.map((item) => ListTile(
                    title: Text(item.name, style: const TextStyle(color: Colors.black)),
                    trailing: Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black)),
                  )).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}