// MenuPage.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'OrderHistoryPage.dart';
import 'OrderSummaryPage.dart';
import 'menu_item.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<MenuItem> _selectedItems = [];
  final List<List<MenuItem>> _orderHistory = [];
  String _selectedCategory = 'Starters';

  void _addToOrder(MenuItem item) {
    setState(() {
      _selectedItems.add(item);
    });
  }

  double _calculateTotal() {
    return _selectedItems.fold(0, (total, item) => total + item.price);
  }

  void _placeOrder() {
    setState(() {
      _orderHistory.add(List.from(_selectedItems));
      _selectedItems.clear();
    });
  }

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
            title: const Text('Menu'),
            backgroundColor: Colors.purple[800],
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderHistoryPage(orderHistory: _orderHistory),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _categoryButton('Starters'),
                    _categoryButton('Main Course'),
                    _categoryButton('Cold Drinks'),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('menu_items').where('category', isEqualTo: _selectedCategory).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final menuItems = snapshot.data!.docs.map((doc) {
                      return MenuItem.fromFirestore(doc);
                    }).toList();

                    return ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Colors.white.withOpacity(0.8),
                          child: ListTile(
                            leading: item.imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.fastfood, size: 50, color: Colors.purple);
                                      },
                                    ),
                                  )
                                : const Icon(Icons.fastfood, size: 50, color: Colors.purple),
                            title: Text(item.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.black87),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.add, color: Colors.purple),
                              onPressed: () => _addToOrder(item),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                color: Colors.purple[800]!.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Selected Items:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ..._selectedItems.map((item) => Text(
                            '${item.name} - \$${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white70),
                          )),
                      const SizedBox(height: 16.0),
                      Text(
                        'Total: \$${_calculateTotal().toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSummaryPage(
                                selectedItems: _selectedItems,
                                total: _calculateTotal(),
                              ),
                            ),
                          ).then((_) => _placeOrder());
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('View Order Summary'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryButton(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: _selectedCategory == category ? Colors.purple : Colors.white,
        backgroundColor: _selectedCategory == category ? Colors.white : Colors.purple,
      ),
      child: Text(category),
    );
  }
}