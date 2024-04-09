// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/providers/product_provider.dart';
import 'package:seller/screens/product_screen.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:seller/widgets/category_list.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;

  const EditViewProduct({super.key, required this.productId});

  @override
  State<EditViewProduct> createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  final FirebaseServices _services = FirebaseServices();

  final _formKey = GlobalKey<FormState>();
  final ProductProvider _provider = ProductProvider();

  final List<String> _collection = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String? dropdownValue;

  final _productName = TextEditingController();
  final _unit = TextEditingController();
  final _price = TextEditingController();
  final _comparedPrice = TextEditingController();
  final _description = TextEditingController();
  final _stockQuantity = TextEditingController();
  final _lowStockQuantity = TextEditingController();
  final _categoryController = TextEditingController();

  late DocumentSnapshot? doc;
  double discount = 0;
  late String image = '';
  File? _image;
  bool _isLoading = true;
  bool _editing = true;

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
          _categoryController.text = document['category'].toString();
          dropdownValue = document['collection'].toString();
          _stockQuantity.text = document['stockQuantity'].toString();
          _lowStockQuantity.text = document['lowStockQuantity'].toString();

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
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _editing = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                'Edit',
                style: TextStyle(color: GlobalStyles.green, fontSize: 16),
              ),
            ),
          )
        ],
      ),
      bottomSheet: SizedBox(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.red,
                  child: const Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AbsorbPointer(
                absorbing: _editing,
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (_image != null) {
                        _provider
                            .uploadProductImage(_image!.path, _productName.text)
                            .then((url) {
                          if (url != null) {
                            _provider.updateProductDeatils(
                              context: context,
                              productName: _productName.text,
                              unit: _unit.text,
                              price: double.parse(_price.text),
                              comparedPrice: double.parse(_comparedPrice.text),
                              description: _description.text,
                              category: _categoryController.text,
                              collection: dropdownValue,
                              stockQuantity: int.parse(_stockQuantity.text),
                              lowStockQuantity:
                                  int.parse(_lowStockQuantity.text),
                              productId: widget.productId,
                              image: image,
                            );

                            _provider.showAlertDialog(
                              context,
                              'Save Product',
                              'Product Details saved Successfully',
                            );
                          }
                        });
                      } else {
                        _provider
                            .updateProductDeatils(
                          context: context,
                          productName: _productName.text,
                          unit: _unit.text,
                          price: double.parse(_price.text),
                          comparedPrice: double.parse(_comparedPrice.text),
                          description: _description.text,
                          category: _categoryController.text,
                          collection: dropdownValue,
                          stockQuantity: int.parse(_stockQuantity.text),
                          lowStockQuantity: int.parse(_lowStockQuantity.text),
                          productId: widget.productId,
                          image: image,
                        )
                            .then((_) {
                          Navigator.pushNamed(context, ProductScreen.id);
                        });
                        print('Image is not Changed');
                        _provider.showAlertDialog(
                          context,
                          'Save Product',
                          'Product Details saved Successfully',
                        );
                      }
                    }
                  },
                  child: Container(
                    color: GlobalStyles.green,
                    child: const Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
      child: ListView(
        children: [
          AbsorbPointer(
            absorbing: _editing,
            child: Column(
              children: [
                SizedBox(
                  width: GlobalStyles.screenWidth(context) - 20,
                  height: GlobalStyles.screenHeight(context) * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Product Name: ',
                              style: TextStyle(fontSize: 14),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _productName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Unit: ',
                              style: TextStyle(fontSize: 14),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _unit,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Price: ',
                              style: TextStyle(fontSize: 14),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _price,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  prefixText: '₱ ',
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              decoration:
                                  const BoxDecoration(color: Colors.red),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: Text(
                                '${discount.toStringAsFixed(0)} % OFF',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Compared Price: ',
                              style: TextStyle(fontSize: 14),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _comparedPrice,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  prefixText: '₱ ',
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              _provider.getProductImage().then((image) {
                                setState(() {
                                  _image = image;
                                });
                              });
                            },
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
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'About this Product: ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                controller: _description,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Category: ',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CategoryList();
                                    },
                                  ).then((value) {
                                    setState(() {
                                      _categoryController.text = value;
                                    });
                                  });
                                },
                                child: AbsorbPointer(
                                  absorbing:
                                      true, // Prevents user input on the text field
                                  child: TextFormField(
                                    controller: _categoryController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Select Product category';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      suffixIcon: Visibility(
                                        visible: _editing ? false : true,
                                        child: IconButton(
                                          onPressed:
                                              () {}, // Empty onPressed to keep icon enabled
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            color: GlobalStyles.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Row(
                            children: [
                              const Text(
                                'Collection :',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              DropdownButton<String>(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                hint: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Text(
                                    'Select Collection',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownValue = value;
                                  });
                                },
                                items: _collection.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Stock Quantity: ',
                              style: TextStyle(fontSize: 14),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _stockQuantity,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Low Stock Quantity: ',
                              style: TextStyle(fontSize: 14),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _lowStockQuantity,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
