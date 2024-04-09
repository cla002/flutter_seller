// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/widgets/dashboard/inventory.dart';
import 'package:seller/widgets/dashboard/ordered.dart';
import 'package:seller/widgets/drawer_menu_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var pressCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalStyles.appBarColor,
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const DrawerMenu(),
      body: WillPopScope(
        onWillPop: () async {
          pressCount++;
          if (pressCount == 2) {
            exit(0);
          } else {
            var snackBar = const SnackBar(content: Text('Press Again to Exit'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return false;
          }
        },
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductInventory(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
                child: Text(
                  'Orders',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 400,
                child: DisplayOrdersInDashboard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
