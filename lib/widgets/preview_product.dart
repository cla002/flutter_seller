// ignore_for_file: unnecessary_null_comparison, unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/providers/product_provider.dart';
import 'package:seller/services/firebase_services.dart';

class PreviewProduct extends StatefulWidget {
  final String productId;

  const PreviewProduct({super.key, required this.productId});

  @override
  State<PreviewProduct> createState() => _PreviewProductState();
}

class _PreviewProductState extends State<PreviewProduct> {
  final FirebaseServices _services = FirebaseServices();

  final _formKey = GlobalKey<FormState>();
  final ProductProvider _provider = ProductProvider();

  final _productName = TextEditingController();
  final _unit = TextEditingController();
  final _price = TextEditingController();
  final _comparedPrice = TextEditingController();
  final _description = TextEditingController();
  final _collection = TextEditingController();

  late DocumentSnapshot? doc;
  double discount = 0;
  late String image = '';
  File? _image;
  bool _isLoading = true;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    await _services.products.doc(widget.productId).get().then((document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _productName.text = document['productName'];
          _unit.text = document['unit'];
          _price.text = document['price'].toString();
          _comparedPrice.text = document['comparedPrice'].toString();
          _description.text = document['description'].toString();
          // _category.text = document['category'].toString();
          _collection.text = document['collection'].toString();
          // _stockQuantity.text = document['stockQuantity'].toString();
          // _lowStockQuantity.text = document['lowStockQuantity'].toString();
          // _tax.text = document['tax'].toString();
          image = document['productImage'];
          _isLoading = false; // Set loading to false when data is fetched

          try {
            // Parsing _price.text to double
            double price = double.parse(_price.text);
            print("Parsed price: $price (Type: ${price.runtimeType})");

            // Validating and parsing _comparedPrice.text to double
            double? comparedPrice = double.tryParse(_comparedPrice.text);
            if (comparedPrice == null) {
              throw FormatException(
                  "Invalid comparedPrice value: ${_comparedPrice.text}");
            }
            print(
                "Parsed comparedPrice: $comparedPrice (Type: ${comparedPrice.runtimeType})");

            // Handling case where original price and current price are equal
            if (price == comparedPrice) {
              discount =
                  0; // No discount if original price and current price are equal
              print("Prices are equal. Discount set to 0.");
            } else {
              // Calculating the amount saved
              double amountSaved = comparedPrice - price;
              print("Amount saved: $amountSaved");

              // Calculating discount percentage
              if (comparedPrice != 0) {
                discount = (amountSaved / comparedPrice) * 100;
                print("Discount percentage: $discount%");
              } else {
                discount = 0;
                print("Compared price is 0. Discount set to 0.");
              }
            }
          } catch (e) {
            print("Error parsing price or compared price: $e");
            // Handle the error gracefully, perhaps by setting discount to 0 or showing an error message to the user
            discount = 0;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Preview'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : doc != null
              ? _buildForm()
              : const Center(child: Text('Error: Product not found')),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: GlobalStyles.screenWidth(context),
                    height: GlobalStyles.screenHeight(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: GlobalStyles.screenWidth(context),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(137, 233, 231, 231),
                              ),
                              child: _image != null
                                  ? Image.file(
                                      _image!,
                                      height: 300,
                                    )
                                  : Image.network(
                                      image,
                                      height: 300,
                                    ),
                            ),

                            TextFormField(
                              controller: _productName,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),

                            SizedBox(
                              height: 30,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  const Text(
                                    'Before:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _comparedPrice,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                      decoration: const InputDecoration(
                                        prefixText: '₱ ',
                                        prefixStyle:
                                            TextStyle(color: Colors.red),
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  const Text(
                                    'Price: ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _price,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      decoration: const InputDecoration(
                                        prefixText: '₱ ',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration:
                                        const BoxDecoration(color: Colors.red),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 2.0),
                                    child: Text(
                                      '${discount.toStringAsFixed(0)} % OFF',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'About This Product: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 300,
                              child: TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                controller: _description,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  'Collection: ',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _collection,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.baseline,
                            //   textBaseline: TextBaseline.alphabetic,
                            //   children: [
                            //     const Text(
                            //       'Stock Quantity: ',
                            //       style: TextStyle(fontSize: 16),
                            //     ),
                            //     Expanded(
                            //       child: TextFormField(
                            //         controller: _stockQuantity,
                            //         style: const TextStyle(
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold),
                            //         decoration: const InputDecoration(
                            //           contentPadding:
                            //               EdgeInsets.only(left: 10, right: 10),
                            //           border: InputBorder.none,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.baseline,
                            //   textBaseline: TextBaseline.alphabetic,
                            //   children: [
                            //     const Text(
                            //       'Low Stock Quantity: ',
                            //       style: TextStyle(fontSize: 16),
                            //     ),
                            //     Expanded(
                            //       child: TextFormField(
                            //         controller: _lowStockQuantity,
                            //         style: const TextStyle(
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold),
                            //         decoration: const InputDecoration(
                            //           contentPadding:
                            //               EdgeInsets.only(left: 10, right: 10),
                            //           border: InputBorder.none,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
