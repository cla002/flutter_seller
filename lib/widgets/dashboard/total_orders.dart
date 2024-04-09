import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller/services/firebase_services.dart';

class TotalProductOrders extends StatelessWidget {
  const TotalProductOrders({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: services.orders
          .where('seller.sellerId', isEqualTo: user!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        int currentOrders = 0;
        int totalProductsSold = 0;

        if (snapshot.hasData) {
          for (var document in snapshot.data!.docs) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            if (data['orderStatus'] == 'Ordered') {
              // Counting products in current orders
              if (data.containsKey('products')) {
                dynamic products = data['products'];
                if (products is List) {
                  currentOrders += products.length;
                } else if (products is Map<String, dynamic>) {
                  currentOrders += products.length;
                }
              }
            } else if (data['orderStatus'] == 'Delivered') {
              // Counting products in delivered orders
              if (data.containsKey('products')) {
                dynamic products = data['products'];
                if (products is List) {
                  for (var product in products) {
                    totalProductsSold +=
                        int.tryParse(product['quantity'].toString()) ?? 0;
                  }
                } else if (products is Map<String, dynamic>) {
                  products.forEach((productId, productData) {
                    totalProductsSold +=
                        int.tryParse(productData['quantity'].toString()) ?? 0;
                  });
                }
              }
            }
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(3, 3),
                  ),
                ],
                color: Colors.yellow.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 140,
              height: 160,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Current Orders',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentOrders.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(3, 3),
                  ),
                ],
                color: Colors.green.shade500,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 140,
              height: 160,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Products Sold',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      totalProductsSold.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
