// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/screens/banner_screen.dart';
import 'package:seller/screens/home_screen.dart';
import 'package:seller/screens/orders_screen.dart';
import 'package:seller/screens/product_screen.dart';
import 'package:seller/screens/account_screen.dart';
import 'package:seller/utils/logout_utils.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  late User? user;
  DocumentSnapshot? vendorData;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getVendorData();
    }
  }

  Future<void> getVendorData() async {
    var result = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(user!.uid)
        .get();
    setState(() {
      vendorData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
//DRAWER HEADER
          UserAccountsDrawerHeader(
            accountName: Text(
              vendorData != null ? vendorData!['shopName'] : 'Store Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user?.email ?? 'Email'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: vendorData != null &&
                          (vendorData!.data()
                                  as Map<String, dynamic>)['imageUrl'] !=
                              null
                      ? DecorationImage(
                          image: NetworkImage(
                            (vendorData!.data()
                                as Map<String, dynamic>)['imageUrl'] as String,
                          ),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: AssetImage(
                              'lib/images/user.png'), // Provide a fallback image
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: GlobalStyles.appBarColor,
            ),
          ),

//NAVIGATION
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, HomeScreen.id);
            },
            child: ListTile(
              title: Text('Dashboard'),
              leading: Icon(
                Icons.home,
                color: GlobalStyles.green,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ProductScreen.id);
            },
            child: ListTile(
              title: Text('Products'),
              leading: Icon(
                Icons.grain,
                color: GlobalStyles.green,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, BannerScreen.id);
            },
            child: ListTile(
              title: Text('Banners'),
              leading: Icon(
                Icons.image,
                color: GlobalStyles.green,
              ),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     Navigator.pushNamed(context, CouponScreen.id);
          //   },
          //   child: ListTile(
          //     title: Text('Coupons'),
          //     leading: Icon(
          //       Icons.discount,
          //       color: GlobalStyles.green,
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, OrderScreen.id);
            },
            child: ListTile(
              title: Text('Orders'),
              leading: Icon(
                Icons.view_list_sharp,
                color: GlobalStyles.green,
              ),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     Navigator.pushNamed(context, ReportScreen.id);
          //   },
          //   child: ListTile(
          //     title: Text('Report'),
          //     leading: Icon(
          //       Icons.analytics,
          //       color: GlobalStyles.green,
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.id);
            },
            child: ListTile(
              title: Text('Account'),
              leading: Icon(
                Icons.settings,
                color: GlobalStyles.green,
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 2,
          ),
          //SIGN OUT
          InkWell(
            onTap: () async {
              logout(context);
            },
            child: const ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              leading: Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
