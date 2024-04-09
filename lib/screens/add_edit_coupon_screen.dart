// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/services/firebase_services.dart';

class AddEditCouponScreen extends StatefulWidget {
  final DocumentSnapshot? document;
  static const String id = 'add-edit-screen';
  const AddEditCouponScreen({super.key, required this.document});

  @override
  State<AddEditCouponScreen> createState() => _AddEditCouponScreenState();
}

class _AddEditCouponScreenState extends State<AddEditCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseServices _services = FirebaseServices();
  DateTime _selectedDate = DateTime.now();
  var dateText = TextEditingController();
  var titleText = TextEditingController();
  var detailsText = TextEditingController();
  var discountRate = TextEditingController();
  bool _active = false;

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      titleText.text = widget.document!['title'];
      discountRate.text = widget.document!['discountRate'].toString();
      detailsText.text = widget.document!['details'].toString();
      dateText.text =
          DateFormat('yyyy-MM-dd').format(widget.document!['expiry'].toDate());
      _active = widget.document!['active'];
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateText.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalStyles.appBarColor,
        centerTitle: true,
        title: const Text(
          'Add Coupons',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleText,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Coupon title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Coupon Title',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextFormField(
                    controller: discountRate,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Discount %';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Discount %',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  TextFormField(
                    controller: dateText,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Expiry Date';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      labelStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: const Icon(
                          Icons.date_range_outlined,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: detailsText,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Details';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Details',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                  SwitchListTile(
                    activeColor: GlobalStyles.green,
                    title: const Text(
                      'Manage Coupons',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    value: _active,
                    onChanged: (bool newValue) {
                      setState(
                        () {
                          _active = newValue;
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        EasyLoading.show(status: 'Please Wait...');
                        _services
                            .saveCoupon(
                          document: widget.document,
                          title: titleText.text.toUpperCase(),
                          details: detailsText.text,
                          discountRate: int.parse(discountRate.text),
                          expiry: _selectedDate,
                          active: _active,
                        )
                            .then((value) {
                          setState(() {
                            titleText.clear();
                            discountRate.clear();
                            detailsText.clear();
                            _active = false;
                          });
                          EasyLoading.dismiss();
                          EasyLoading.showSuccess('Coupon Saved Successfully');
                        });
                      }
                    },
                    child: Container(
                      width: GlobalStyles.screenWidth(context) * 0.9,
                      decoration: BoxDecoration(
                        color: GlobalStyles.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
