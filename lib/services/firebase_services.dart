// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference vendorBanner =
      FirebaseFirestore.instance.collection('vendorBanner');
  CollectionReference coupons =
      FirebaseFirestore.instance.collection('coupons');
  CollectionReference riders = FirebaseFirestore.instance.collection('riders');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> publishedProduct(String id, {required bool published}) {
    return products.doc(id).update({
      'published': true,
    });
  }

  Future<void> unpublishedProduct(String id, {required bool published}) {
    return products.doc(id).update({
      'published': false,
    });
  }

  Future<void> deleteProduct(String id, {required bool published}) {
    return products.doc(id).delete();
  }

  Future<void> saveBanner(url) {
    return vendorBanner.add(
      {
        'bannerUrl': url,
        'sellerUid': user!.uid,
      },
    );
  }

  Future<void> deleteBanner(String id) {
    return vendorBanner.doc(id).delete();
  }

  Future<void> saveCoupon(
      {document, title, discountRate, expiry, details, active}) {
    if (document == null) {
      return coupons.doc(title).set(
        {
          'title': title,
          'discountRate': discountRate,
          'expiry': expiry,
          'details': details,
          'active': active,
          'sellerId': user!.uid,
        },
      );
    }
    return coupons.doc(title).update(
      {
        'title': title,
        'discountRate': discountRate,
        'expiry': expiry,
        'details': details,
        'active': active,
        'sellerId': user!.uid,
      },
    );
  }

  Future<DocumentSnapshot> getShopDetails() async {
    DocumentSnapshot doc = await vendors.doc(user!.uid).get();
    return doc;
  }

  Future<void> selectedRider({orderId, location, name, image, phone, email}) {
    var result = orders.doc(orderId).update({
      'deliveryMan': {
        'location': location,
        'name': name,
        'image': image,
        'phone': phone,
        'email' : email
      }
    });
    return result;
  }

  Future<DocumentSnapshot> getCustomerDetails(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }
}
