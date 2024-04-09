// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:seller/providers/auth_provider.dart';
import 'package:seller/providers/order_provider.dart';
import 'package:seller/screens/add_edit_coupon_screen.dart';
import 'package:seller/screens/add_newproduct_screen.dart';
import 'package:seller/screens/banner_screen.dart';
import 'package:seller/screens/coupon_screen.dart';
import 'package:seller/screens/home_screen.dart';
import 'package:seller/screens/login_screen.dart';
import 'package:seller/screens/orders_screen.dart';
import 'package:seller/screens/product_screen.dart';
import 'package:seller/screens/account_screen.dart';
import 'package:seller/screens/registration_screen.dart';
import 'package:seller/screens/reset_password_screen.dart';
import 'package:seller/screens/splash_screen.dart';
import 'package:seller/screens/waiting_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple.shade900,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (conext) => SplashScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
        AddNewProduct.id: (context) => AddNewProduct(),
        ProductScreen.id: (context) => ProductScreen(),
        BannerScreen.id: (context) => BannerScreen(),
        CouponScreen.id: (context) => CouponScreen(),
        OrderScreen.id: (context) => OrderScreen(),
        WaitingScreen.id: (context) => WaitingScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        AddEditCouponScreen.id: (context) => AddEditCouponScreen(
            document:
                ModalRoute.of(context)!.settings.arguments as DocumentSnapshot),
      },
      builder: EasyLoading.init(),
    );
  }
}
