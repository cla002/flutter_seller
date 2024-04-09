// // ignore_for_file: unnecessary_null_comparison

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:seller/globals/styles.dart';
// import 'package:seller/providers/product_provider.dart';
// import 'package:seller/screens/home_screen.dart';
// import 'package:seller/screens/product_screen.dart';
// import 'package:seller/widgets/category_list.dart';

// class AddNewProduct extends StatefulWidget {
//   static const String id = 'add-new-product-screen';

//   const AddNewProduct({Key? key}) : super(key: key);

//   @override
//   State<AddNewProduct> createState() => _AddNewProductState();
// }

// class _AddNewProductState extends State<AddNewProduct> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _productNameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();
//   final TextEditingController _comparedPriceController =
//       TextEditingController();
//   final TextEditingController _lowStockTextController = TextEditingController();
//   final TextEditingController _stockController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _unitController = TextEditingController();
//   final ProductProvider _provider = ProductProvider();
//   final TextEditingController _shippingController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();

//   @override
//   void dispose() {
//     _categoryController.dispose();
//     _comparedPriceController.dispose();
//     _lowStockTextController.dispose();
//     _stockController.dispose();
//     super.dispose();
//   }

//   final List<String> _collection = [
//     'Featured Products',
//     'Best Selling',
//     'Recently Added'
//   ];
//   String? dropdownValue;

//   bool _track = false;
//   late String productName;
//   late String description;
//   late double price = 0.0;
//   late double comparedPrice;
//   late String unit;
//   late double shipping;
//   late int weight;
//   int stockQuantity = 0;
//   int lowStockQuantity = 0;
//   File? _image;

//   bool _saving = false;

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       initialIndex: 1, //Avoid automatic text clearing
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: GlobalStyles.appBarColor,
//           leading: IconButton(
//             color: Colors.white,
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (context) => const ProductScreen(),
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton.icon(
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(
//                   GlobalStyles.appBarColor,
//                 ),
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                 ),
//               ),
//               onPressed: _saving
//                   ? null
//                   : () {
//                       if (_formKey.currentState!.validate()) {
//                         if (_categoryController.text.isNotEmpty) {
//                           if (_image != null) {
//                             setState(() {
//                               _saving = true;
//                             });
//                             EasyLoading.show(status: 'Saving...');
//                             _provider
//                                 .uploadProductImage(_image!.path, productName)
//                                 .then((url) {
//                               if (url != null) {
//                                 EasyLoading.dismiss();
//                                 _provider
//                                     .saveProductDataToFirestore(
//                                   context: context,
//                                   comparedPrice: double.parse(
//                                       _comparedPriceController.text),
//                                   collection: dropdownValue,
//                                   description: description,
//                                   lowStockQuantity:
//                                       int.parse(_lowStockTextController.text),
//                                   price: price,
//                                   stockQuantity:
//                                       int.parse(_stockController.text),
//                                   unit: unit,
//                                   productName: productName,
//                                   category: _categoryController.text,
//                                   shipping: _shippingController.text,
//                                   weight: _weightController.text,
//                                 )
//                                     .then((_) {
//                                   setState(() {
//                                     _saving = false;
//                                   });
//                                   Navigator.of(context).pushReplacement(
//                                     MaterialPageRoute(
//                                       builder: (context) => const HomeScreen(),
//                                     ),
//                                   );
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                         title: const Text('Success'),
//                                         content: const Text(
//                                             'Data is Saved Successfully'),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context).pop();
//                                             },
//                                             child: const Text('OK'),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 });
//                               }
//                             });
//                           } else {
//                             _provider.AlertDialog(
//                               context: context,
//                               title: 'Upload Image',
//                               content: 'Failed to Upload Product Image',
//                             );
//                           }
//                         } else {
//                           _provider.AlertDialog(
//                             context: context,
//                             title: 'Category',
//                             content: 'No Category Selected',
//                           );
//                         }
//                       }
//                     },
//               icon: const Icon(Icons.save, color: Colors.white),
//               label: const Padding(
//                 padding: EdgeInsets.only(right: 5.0),
//                 child: Text(
//                   'Save',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: _saving // Show loading indicator while saving
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Form(
//                 key: _formKey,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Column(
//                     children: [
//                       const Material(
//                         elevation: 5,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 15.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Products',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   color: Colors.black54,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       TabBar(
//                         indicatorColor: GlobalStyles.green,
//                         labelColor: GlobalStyles.green,
//                         unselectedLabelColor: Colors.grey,
//                         tabs: const [
//                           Tab(
//                             text: 'General',
//                           ),
//                           Tab(
//                             text: 'Inventory',
//                           ),
//                         ],
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Card(
//                             child: TabBarView(
//                               children: [
//                                 ListView(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         children: [
//                                           TextFormField(
//                                             controller: _productNameController,
//                                             onChanged: (value) {
//                                               productName = value;
//                                             },
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return 'Please Enter Your Product Name';
//                                               }

//                                               return null;
//                                             },
//                                             decoration: const InputDecoration(
//                                               labelText: 'Product Name',
//                                               labelStyle: TextStyle(
//                                                 color: Colors.grey,
//                                               ),
//                                               enabledBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey),
//                                               ),
//                                             ),
//                                           ),
//                                           TextFormField(
//                                             controller: _descriptionController,
//                                             onChanged: (value) {
//                                               description = value;
//                                             },
//                                             keyboardType:
//                                                 TextInputType.multiline,
//                                             maxLines: 5,
//                                             maxLength: 500,
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return 'Please Provide Your Product Description';
//                                               }

//                                               return null;
//                                             },
//                                             decoration: const InputDecoration(
//                                               labelText: 'Description',
//                                               labelStyle: TextStyle(
//                                                 color: Colors.grey,
//                                               ),
//                                               enabledBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 20),
//                                           InkWell(
//                                             onTap: () {
//                                               _provider
//                                                   .getProductImage()
//                                                   .then((image) {
//                                                 setState(() {
//                                                   _image = image;
//                                                 });
//                                               });
//                                             },
//                                             child: SizedBox(
//                                               width: 200,
//                                               height: 150,
//                                               child: Center(
//                                                 child: _image == null
//                                                     ? const Text(
//                                                         'Select Image',
//                                                         style: TextStyle(
//                                                             fontSize: 16,
//                                                             color: Colors.grey),
//                                                       )
//                                                     : Image.file(_image!),
//                                               ),
//                                             ),
//                                           ),
//                                           TextFormField(
//                                             controller: _priceController,
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 if (value.isNotEmpty) {
//                                                   price = double.parse(value);
//                                                 } else {
//                                                   price =
//                                                       0.0; // Set price to 0 if the text field is empty
//                                                 }
//                                                 print(
//                                                     'Price: $price'); // Print the value of price for debugging
//                                               });
//                                             },
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return 'Please Enter Your Product Price';
//                                               }
//                                               if (price > double.parse(value)) {
//                                                 return 'Compared Price should be higher than Price';
//                                               }
//                                               return null;
//                                             },
//                                             keyboardType: TextInputType.number,
//                                             decoration: const InputDecoration(
//                                               labelText: 'Price',
//                                               labelStyle: TextStyle(
//                                                 color: Colors.grey,
//                                               ),
//                                               enabledBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey),
//                                               ),
//                                             ),
//                                           ),
//                                           TextFormField(
//                                             onChanged: (value) {
//                                               comparedPrice =
//                                                   double.parse(value);
//                                             },
//                                             controller:
//                                                 _comparedPriceController,
//                                             validator: (value) {
//                                               if (price >
//                                                   double.parse(value!)) {
//                                                 return 'Compared Price should be higher than Price';
//                                               }

//                                               return null;
//                                             },
//                                             keyboardType: TextInputType.number,
//                                             decoration: const InputDecoration(
//                                               labelText: 'Compared Price',
//                                               labelStyle: TextStyle(
//                                                 color: Colors.grey,
//                                               ),
//                                               enabledBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             children: [
//                                               const Text(
//                                                 'Shipping',
//                                                 style: TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 16),
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Expanded(
//                                                 child: TextFormField(
//                                                   keyboardType:
//                                                       TextInputType.number,
//                                                   controller:
//                                                       _shippingController,
//                                                   onChanged: (value) {
//                                                     shipping =
//                                                         double.parse(value);
//                                                   },
//                                                   validator: (value) {
//                                                     if (value!.isEmpty) {
//                                                       return 'Enter Shipping Cost';
//                                                     }
//                                                     return null;
//                                                   },
//                                                   decoration:
//                                                       const InputDecoration(
//                                                     labelText: '₱50',
//                                                     labelStyle: TextStyle(
//                                                       color: Colors.grey,
//                                                     ),
//                                                     enabledBorder:
//                                                         OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           color: Colors.grey),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               const Text(
//                                                 'per',
//                                                 style: TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 16),
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Expanded(
//                                                 child: TextFormField(
//                                                   controller: _weightController,
//                                                   onChanged: (value) {
//                                                     weight = int.parse(value);
//                                                   },
//                                                   validator: (value) {
//                                                     if (value!.isEmpty) {
//                                                       return 'Provide the weight unit (ex. kg, g, sack)';
//                                                     }
//                                                     return null;
//                                                   },
//                                                   decoration:
//                                                       const InputDecoration(
//                                                     labelText: '10',
//                                                     labelStyle: TextStyle(
//                                                       color: Colors.grey,
//                                                     ),
//                                                     enabledBorder:
//                                                         OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           color: Colors.grey),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Expanded(
//                                                 child: TextFormField(
//                                                   controller: _unitController,
//                                                   onChanged: (value) {
//                                                     unit = value;
//                                                   },
//                                                   validator: (value) {
//                                                     if (value!.isEmpty) {
//                                                       return 'Please Provide the Unit';
//                                                     }
//                                                     return null;
//                                                   },
//                                                   decoration:
//                                                       const InputDecoration(
//                                                     labelText: 'kg',
//                                                     labelStyle: TextStyle(
//                                                       color: Colors.grey,
//                                                     ),
//                                                     enabledBorder:
//                                                         OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           color: Colors.grey),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 height: 5,
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Container(
//                                             child: Row(
//                                               children: [
//                                                 const Text(
//                                                   'Collection :',
//                                                   style: TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 16,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 20,
//                                                 ),
//                                                 DropdownButton<String>(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(vertical: 5),
//                                                   hint: const Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             vertical: 10.0,
//                                                             horizontal: 20.0),
//                                                     child: Text(
//                                                       'Select Collection',
//                                                       style: TextStyle(
//                                                           color: Colors.grey),
//                                                     ),
//                                                   ),
//                                                   value: dropdownValue,
//                                                   icon: const Icon(
//                                                       Icons.arrow_drop_down),
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue = value;
//                                                     });
//                                                   },
//                                                   items: _collection
//                                                       .map((String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   return const CategoryList();
//                                                 },
//                                               ).then((value) {
//                                                 setState(() {
//                                                   _categoryController.text =
//                                                       value;
//                                                 });
//                                               });
//                                             },
//                                             child: AbsorbPointer(
//                                               absorbing:
//                                                   true, // Prevents user input on the text field
//                                               child: TextFormField(
//                                                 controller: _categoryController,
//                                                 validator: (value) {
//                                                   if (value!.isEmpty) {
//                                                     return 'Select Product category';
//                                                   }
//                                                   return null;
//                                                 },
//                                                 decoration: InputDecoration(
//                                                   labelText:
//                                                       'Category Not Selected',
//                                                   labelStyle: const TextStyle(
//                                                     color: Colors.grey,
//                                                   ),
//                                                   enabledBorder:
//                                                       const UnderlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                         color: Colors.grey),
//                                                   ),
//                                                   suffixIcon: IconButton(
//                                                     onPressed:
//                                                         () {}, // Empty onPressed to keep icon enabled
//                                                     icon: Icon(
//                                                       Icons.edit_outlined,
//                                                       color: GlobalStyles.green,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SingleChildScrollView(
//                                   child: Column(
//                                     children: [
//                                       SwitchListTile(
//                                         title: const Text(
//                                           'Track Inventory',
//                                         ),
//                                         activeColor: GlobalStyles.green,
//                                         value: _track,
//                                         onChanged: (selected) {
//                                           setState(() {
//                                             _track = !_track;
//                                           });
//                                         },
//                                       ),
//                                       Visibility(
//                                         visible: _track,
//                                         child: SizedBox(
//                                           height: 300,
//                                           width: double.infinity,
//                                           child: Card(
//                                             elevation: 3,
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(10),
//                                               child: Column(
//                                                 children: [
//                                                   TextFormField(
//                                                     controller:
//                                                         _stockController,
//                                                     keyboardType:
//                                                         TextInputType.number,
//                                                     validator: (value) {
//                                                       if (_track) {
//                                                         if (value!.isEmpty) {
//                                                           return 'Enter Stock Quantity';
//                                                         }
//                                                       }
//                                                       return null;
//                                                     },
//                                                     decoration:
//                                                         const InputDecoration(
//                                                       labelText:
//                                                           'Inventory Quantity',
//                                                       labelStyle: TextStyle(
//                                                         color: Colors.grey,
//                                                       ),
//                                                       enabledBorder:
//                                                           UnderlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             color: Colors.grey),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   TextFormField(
//                                                     keyboardType:
//                                                         TextInputType.number,
//                                                     controller:
//                                                         _lowStockTextController,
//                                                     decoration:
//                                                         const InputDecoration(
//                                                       labelText:
//                                                           'Inventory Low Stock Quantity',
//                                                       labelStyle: TextStyle(
//                                                         color: Colors.grey,
//                                                       ),
//                                                       enabledBorder:
//                                                           UnderlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             color: Colors.grey),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }

// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/providers/product_provider.dart';
import 'package:seller/screens/home_screen.dart';
import 'package:seller/screens/product_screen.dart';
import 'package:seller/widgets/category_list.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'add-new-product-screen';

  const AddNewProduct({Key? key}) : super(key: key);

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _comparedPriceController =
      TextEditingController();
  final TextEditingController _lowStockTextController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final ProductProvider _provider = ProductProvider();
  final TextEditingController _shippingController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _comparedPriceController.dispose();
    _lowStockTextController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  final List<String> _collection = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String? dropdownValue;

  bool _track = false;
  late String productName;
  late String description;
  late double price = 0.0;
  late double comparedPrice;
  late String unit;
  late double shipping;
  late int weight;
  int stockQuantity = 0;
  int lowStockQuantity = 0;
  File? _image;

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1, //Avoid automatic text clearing
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalStyles.appBarColor,
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ProductScreen(),
                ),
              );
            },
          ),
          actions: [
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  GlobalStyles.appBarColor,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              onPressed: _saving
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        if (_categoryController.text.isNotEmpty) {
                          if (_image != null) {
                            setState(() {
                              _saving = true;
                            });
                            EasyLoading.show(status: 'Saving...');
                            _provider
                                .uploadProductImage(_image!.path, productName)
                                .then((url) {
                              if (url != null) {
                                EasyLoading.dismiss();
                                _provider
                                    .saveProductDataToFirestore(
                                  context: context,
                                  comparedPrice: double.parse(
                                      _comparedPriceController.text),
                                  collection: dropdownValue,
                                  description: description,
                                  lowStockQuantity:
                                      int.parse(_lowStockTextController.text),
                                  price: price,
                                  stockQuantity:
                                      int.parse(_stockController.text),
                                  unit: unit,
                                  productName: productName,
                                  category: _categoryController.text,
                                  shipping: _shippingController.text,
                                  weight: _weightController.text,
                                )
                                    .then((_) {
                                  setState(() {
                                    _saving = false;
                                  });
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: const Text(
                                            'Data is Saved Successfully'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            });
                          } else {
                            _provider.AlertDialog(
                              context: context,
                              title: 'Upload Image',
                              content: 'Failed to Upload Product Image',
                            );
                          }
                        } else {
                          _provider.AlertDialog(
                            context: context,
                            title: 'Category',
                            content: 'No Category Selected',
                          );
                        }
                      }
                    },
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: _saving // Show loading indicator while saving
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      const Material(
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Products',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TabBar(
                        indicatorColor: GlobalStyles.green,
                        labelColor: GlobalStyles.green,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(
                            text: 'General',
                          ),
                          Tab(
                            text: 'Inventory',
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: TabBarView(
                              children: [
                                ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _productNameController,
                                            onChanged: (value) {
                                              productName = value;
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Your Product Name';
                                              }

                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'Product Name',
                                              labelStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _descriptionController,
                                            onChanged: (value) {
                                              description = value;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 5,
                                            maxLength: 500,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Provide Your Product Description';
                                              }

                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'Description',
                                              labelStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          InkWell(
                                            onTap: () {
                                              _provider
                                                  .getProductImage()
                                                  .then((image) {
                                                setState(() {
                                                  _image = image;
                                                });
                                              });
                                            },
                                            child: SizedBox(
                                              width: 200,
                                              height: 150,
                                              child: Center(
                                                child: _image == null
                                                    ? const Text(
                                                        'Select Image',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.grey),
                                                      )
                                                    : Image.file(_image!),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _priceController,
                                            onChanged: (value) {
                                              setState(() {
                                                if (value.isNotEmpty) {
                                                  price = double.parse(value);
                                                } else {
                                                  price =
                                                      0.0; // Set price to 0 if the text field is empty
                                                }
                                                print(
                                                    'Price: $price'); // Print the value of price for debugging
                                              });
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Your Product Price';
                                              }
                                              if (price > double.parse(value)) {
                                                return 'Compared Price should be higher than Price';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: 'Price',
                                              labelStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            onChanged: (value) {
                                              comparedPrice =
                                                  double.parse(value);
                                            },
                                            controller:
                                                _comparedPriceController,
                                            validator: (value) {
                                              if (price >
                                                  double.parse(value!)) {
                                                return 'Compared Price should be higher than Price';
                                              }

                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: 'Compared Price',
                                              labelStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Shipping',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      _shippingController,
                                                  onChanged: (value) {
                                                    shipping =
                                                        double.parse(value);
                                                  },
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Enter Shipping Cost';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: '₱50',
                                                    labelStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                'per',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: _weightController,
                                                  onChanged: (value) {
                                                    weight = int.parse(value);
                                                  },
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Provide the weight unit (ex. kg, g, sack)';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: '10',
                                                    labelStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: _unitController,
                                                  onChanged: (value) {
                                                    unit = value;
                                                  },
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please Provide the Unit';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'kg',
                                                    labelStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                const Text(
                                                  'Collection :',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                DropdownButton<String>(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  hint: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 20.0),
                                                    child: Text(
                                                      'Select Collection',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  value: dropdownValue,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      dropdownValue = value;
                                                    });
                                                  },
                                                  items: _collection
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const CategoryList();
                                                },
                                              ).then((value) {
                                                setState(() {
                                                  _categoryController.text =
                                                      value;
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
                                                  labelText:
                                                      'Category Not Selected',
                                                  labelStyle: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  enabledBorder:
                                                      const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  suffixIcon: IconButton(
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SwitchListTile(
                                        title: const Text(
                                          'Track Inventory',
                                        ),
                                        activeColor: GlobalStyles.green,
                                        value: _track,
                                        onChanged: (selected) {
                                          setState(() {
                                            _track = !_track;
                                          });
                                        },
                                      ),
                                      Visibility(
                                        visible: _track,
                                        child: SizedBox(
                                          height: 300,
                                          width: double.infinity,
                                          child: Card(
                                            elevation: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        _stockController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (_track) {
                                                        if (value!.isEmpty) {
                                                          return 'Enter Stock Quantity';
                                                        }
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Inventory Quantity',
                                                      labelStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller:
                                                        _lowStockTextController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Inventory Low Stock Quantity',
                                                      labelStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
