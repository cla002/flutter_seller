// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_this, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {
  DocumentSnapshot? snapshot;
  late File image;
  bool isPickAvailable = false;
  String pickerError = '';
  late String error = '';

  //Store data
  late double shopLatitude;
  late double shopLongitude;
  late String shopAddress;
  late String storePlaceName;
  late String email;

  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      pickerError = 'No image selected';
      print('No image selected');
    }
    return image;
  }

  Future getCurrentAddress() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    shopLatitude = _locationData.latitude!;
    shopLongitude = _locationData.longitude!;
    notifyListeners();

    final coordinates =
        Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var shopAddress = _addresses.first;
    this.shopAddress = shopAddress.addressLine!;
    storePlaceName = shopAddress.featureName!;
    notifyListeners();
    return shopAddress;
  }

  Future<UserCredential?> registerVendor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password is too weak';
        notifyListeners();
        print('The password is too weak');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exist for that email';
        notifyListeners();
        print('The account already exist for that email');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

//LOGIN
  Future<UserCredential?> loginVendor(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

//RESET PASSWORD
  Future<void> resetPassword(email) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<void> saveVendorDataToFirestore(
      {String? url, String? shopName, String? mobile, String? dialog}) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        FirebaseFirestore.instance.collection('vendors').doc(user!.uid);
    _vendors.set(
      {
        'uid': user.uid,
        'shopName': shopName,
        'email': this.email,
        'mobile': mobile,
        'dialog': dialog,
        'address': '${this.storePlaceName} : ${this.shopAddress}',
        'location': GeoPoint(this.shopLatitude, this.shopLongitude),
        'shopOpen': true,
        'rating': 0.00,
        'totalRating': 0,
        'isTopPicked': false,
        'imageUrl': url,
        'accountVerified': false,
      },
    );
  }
}
