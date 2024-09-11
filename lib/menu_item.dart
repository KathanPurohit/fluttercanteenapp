import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;  // New field

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,  // New parameter
  });

  factory MenuItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MenuItem(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',  // New field
    );
  }

  static Future<String> uploadImage(File imageFile) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = FirebaseStorage.instance.ref().child('menu_images/$fileName');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  static Future<MenuItem> create({
    required String name,
    required double price,
    required File imageFile,
    required String category,  // New parameter
  }) async {
    // Upload image to Firebase Storage
    String imageUrl = await uploadImage(imageFile);

    // Create document in Firestore
    DocumentReference docRef = await FirebaseFirestore.instance.collection('menu_items').add({
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,  // New field
    });

    // Return new MenuItem instance
    return MenuItem(
      id: docRef.id,
      name: name,
      price: price,
      imageUrl: imageUrl,
      category: category,  // New field
    );
  }

  static Stream<List<MenuItem>> getMenuItems() {
    return FirebaseFirestore.instance
        .collection('menu_items')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    });
  }

  // New method to get menu items by category
  static Stream<List<MenuItem>> getMenuItemsByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('menu_items')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList();
    });
  }
}