// OrderSummaryPage.dart
import 'package:flutter/material.dart';
import 'menu_item.dart';

class OrderSummaryPage extends StatelessWidget {
  final List<MenuItem> selectedItems;
  final double total;

  const OrderSummaryPage({super.key, required this.selectedItems, required this.total});

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
            title: const Text('Order Summary'),
            backgroundColor: Colors.purple[800],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = selectedItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: Colors.white.withOpacity(0.8),
                      child: ListTile(
                        title: Text(item.name, style: const TextStyle(color: Colors.black)),
                        trailing: Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black)),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.purple[800]!.withOpacity(0.9),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Here you would typically process the order
                    // For now, we'll just pop back to the menu
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Place Order', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}