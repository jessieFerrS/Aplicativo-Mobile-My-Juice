import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/juice.dart';

class FirestoreService {
  final CollectionReference orders = FirebaseFirestore.instance.collection('Pedidos');
  final CollectionReference juices = FirebaseFirestore.instance.collection('Sucos');

  Future<void> saveOrderToDataBase(String receipt, String address) async {
    await orders.add({
      'data': DateTime.now(),
      'pedido': receipt,
      'endereco': address,
      'email': FirebaseAuth.instance.currentUser?.email
    });
  }

  Future<String> getLastOrderAddress() async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      return '';
    }

    QuerySnapshot querySnapshot = await orders
        .where('email', isEqualTo: email)
        .get();

    List<DocumentSnapshot> userOrders = querySnapshot.docs;

    if (userOrders.isNotEmpty) {
      userOrders.sort((a, b) => b['data'].compareTo(a['data']));
      String address = userOrders.first['endereco'];
      return address;
    } else {
      return '';
    }
  }

  Future<List<Map<String, dynamic>>> getUserOrders() async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      return [];
    }

    QuerySnapshot querySnapshot = await orders.where('email', isEqualTo: email).get();

    List<Map<String, dynamic>> userOrders = querySnapshot.docs.map((doc) {
      return {
        'data': doc['data'],
        'pedido': doc['pedido'],
        'endereco': doc['endereco'],
        'email': doc['email'],
      };
    }).toList();

    userOrders.sort((a, b) => b['data'].compareTo(a['data']));

    return userOrders;
  }

  Future<List<Juice>> getJuicesFromDatabase() async {
    QuerySnapshot querySnapshot = await juices.get();
    List<Juice> juiceList = [];

    for (var doc in querySnapshot.docs) {
      Juice juice = Juice(
        name: doc['name'],
        description: doc['description'],
        imagePath: doc['imagePath'],
        price: doc['price'],
        category: enumFromString(JuiceCategory.values, doc['category']),
        availableVersions:
        [
          Version(name: "Açúcar", price: 0.79),
          Version(name: "Mel", price: 1.69),
          Version(name: "Adoçante", price: 1.99),
        ],
      );
      juiceList.add(juice);
    }

    return juiceList;
  }

  T enumFromString<T>(List<T> values, String value) {
    return values.firstWhere((type) => type.toString().split('.').last == value,
        orElse: () {
          throw ArgumentError('String $value is not in enum $T');
        });
  }
}