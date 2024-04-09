// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:seller/widgets/preview_product.dart';

class PublishedProducts extends StatelessWidget {
  const PublishedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();
    User? user = FirebaseAuth.instance.currentUser;
    return Container(
      child: StreamBuilder(
        stream: services.products
            .where('published', isEqualTo: true)
            .where('seller.sellerUid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('No internet connection'),
            );
          } else if (snapshot.hasError) {
            return const Text('Something went wrong...');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 238, 234, 234)),
              columns: <DataColumn>[
                DataColumn(
                  label: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: GlobalStyles.screenWidth(context) * 0.09),
                    child: const Text(
                      'Image',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const DataColumn(
                  label: Expanded(
                    child: Text(
                      'Product Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const DataColumn(
                  label: Text(
                    'Actions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: _productDetails(snapshot.data),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _productDetails(QuerySnapshot? snapshot) {
    if (snapshot == null || snapshot.docs.isEmpty) {
      return []; // Return an empty list if snapshot is null or empty
    }

    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(
        cells: [
          DataCell(
            SizedBox(
              height: 50,
              child: Image.network(document['productImage'] ?? ''),
            ),
          ),
          DataCell(
            Container(
              child: Text(document['productName'] ?? ''),
            ),
          ),
          DataCell(popUpButton(document)),
        ],
      );
    }).toList();
    return newList;
  }

  Widget popUpButton(DocumentSnapshot document) {
    FirebaseServices services = FirebaseServices();
    return PopupMenuButton<String>(
        onSelected: (String value) {
          if (value == 'publish') {
            services.unpublishedProduct(
              document.id, // Pass the document ID
              published: true, // Pass the published value
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'publish',
                child: ListTile(
                  leading: Icon(Icons.check),
                  title: Text('Un Publish'),
                ),
              ),
              PopupMenuItem<String>(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PreviewProduct(productId: document['productId']),
                    ),
                  );
                },
                value: 'preview',
                child: const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Preview'),
                ),
              ),
            ]);
  }
}
