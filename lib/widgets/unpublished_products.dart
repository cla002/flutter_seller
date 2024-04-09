import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:seller/widgets/edit_view_product.dart';

class UnpublishedProducts extends StatelessWidget {
  const UnpublishedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices services = FirebaseServices();
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: services.products
          .where('published', isEqualTo: false)
          .where('seller.sellerUid', isEqualTo: user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a full-screen loading indicator while data is loading
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        } else {
          return buildDataTable(snapshot.data, context);
        }
      },
    );
  }

  Widget buildDataTable(QuerySnapshot? snapshot, BuildContext context) {
    if (snapshot == null || snapshot.docs.isEmpty) {
      return const Center(
        child: Text('No unpublished products found.'),
      );
    }

    return SingleChildScrollView(
      child: DataTable(
        showBottomBorder: true,
        dataRowHeight: 60,
        headingRowColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 238, 234, 234),
        ),
        columns: <DataColumn>[
          DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: GlobalStyles.screenWidth(context) * 0.02,
              ),
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
        rows: _productDetails(snapshot, context),
      ),
    );
  }

  List<DataRow> _productDetails(QuerySnapshot snapshot, BuildContext context) {
    return snapshot.docs.map((DocumentSnapshot document) {
      try {
        var productImage = document['productImage'] ?? '';
        var productName = document['productName'] ?? '';

        return DataRow(
          cells: [
            DataCell(
              SizedBox(
                height: 50,
                child: Image.network(productImage),
              ),
            ),
            DataCell(
              Container(
                child: Text(productName),
              ),
            ),
            DataCell(popUpButton(document)),
          ],
        );
      } catch (e) {
        print('Error accessing productImage: $e');
        // Handle the error gracefully, for example, by showing a placeholder image
        return DataRow(
          cells: [
            const DataCell(
              SizedBox(
                width: 50,
                child: Icon(Icons.error),
              ),
            ),
            DataCell(
              Container(
                child: const Text('Error loading product'),
              ),
            ),
            DataCell(popUpButton(document)),
          ],
        );
      }
    }).toList();
  }

  Widget popUpButton(DocumentSnapshot document) {
    FirebaseServices services = FirebaseServices();
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == 'published') {
          services.publishedProduct(
            document.id, // Pass the document ID
            published: true, // Pass the published value
          );
        }
        if (value == 'delete') {
          services.deleteProduct(document.id, published: false);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'published',
          child: ListTile(
            leading: Icon(Icons.check),
            title: Text('Published'),
          ),
        ),
        PopupMenuItem<String>(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditViewProduct(productId: document['productId']),
              ),
            );
          },
          value: 'edit',
          child: const ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Delete'),
          ),
        ),
      ],
    );
  }
}
