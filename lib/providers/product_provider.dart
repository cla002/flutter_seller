// ignore_for_file: unnecessary_this, prefer_if_null_operators, unnecessary_null_comparison, unused_local_variable

import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  File? image;
  String pickerError = '';
  String shopName = '';
  String productUrl = '';

  Future<File?> getProductImage() async {
    final picker = ImagePicker();
    final PickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (PickedFile != null) {
      this.image = File(PickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected';
      print('NO IMAGE SELECTED');
      notifyListeners();
    }
    return this.image;
  }

  Future<String> uploadProductImage(filePath, productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage
          .ref('productImage/${this.shopName}$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await storage
        .ref('productImage/${this.shopName}$productName$timeStamp')
        .getDownloadURL();
    this.productUrl = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  AlertDialog({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<void> saveProductDataToFirestore({
    productName,
    description,
    price,
    comparedPrice,
    unit,
    collection,
    category,
    stockQuantity,
    lowStockQuantity,
    context,
    shipping,
    weight,
  }) async {
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    try {
      // Fetch the user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        // Extract the shopName from the user document
        this.shopName = userDoc.get('shopName');

        // Save product data to Firestore
        await products.doc(timeStamp.toString()).set(
          {
            'seller': {'shopName': shopName, 'sellerUid': user.uid},
            'productName': productName,
            'description': description,
            'price': price,
            'comparedPrice': comparedPrice,
            'unit': unit,
            'collection': collection,
            'category': category,
            'stockQuantity': stockQuantity,
            'lowStockQuantity': lowStockQuantity,
            'published': false,
            'productId': timeStamp.toString(),
            'productImage': this.productUrl,
            'shipping': shipping,
            'weight': weight,
          },
        );

        print('Product data saved to Firestore successfully');
        showAlertDialog(
            context, 'Save Product', 'Product Details saved Successfully');
      } else {
        showAlertDialog(
            context, 'Save Product', 'User document does not exist');
      }
    } catch (e) {
      print('Error saving product data: $e');
      showAlertDialog(context, 'Save Product', e.toString());
    }
  }

  Future<void> updateProductDeatils({
    productName,
    description,
    price,
    comparedPrice,
    unit,
    collection,
    category,
    stockQuantity,
    lowStockQuantity,
    context,
    productId,
    image,
  }) async {
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

// Fetch the user document from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(user!.uid)
        .get();

    if (userDoc.exists) {
      // Extract the shopName from the user document
      this.shopName = userDoc.get('shopName');
    } else {
      print('User document does not exist');
      return;
    }

    try {
      await products.doc(productId).update(
        {
          'productName': productName,
          'description': description,
          'price': price,
          'comparedPrice': comparedPrice,
          'unit': unit,
          'collection': collection,
          'category': category,
          'stockQuantity': stockQuantity,
          'lowStockQuantity': lowStockQuantity,
          'productImage': this.productUrl.isNotEmpty ? this.productUrl : image,
        },
      );
      print('Product data updated in Firestore successfully');
    } catch (e) {
      print(e);
    }
    return;
  }

  void showAlertDialog(BuildContext context, String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
