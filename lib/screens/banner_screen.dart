// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, non_constant_identifier_names, unnecessary_this, avoid_init_to_null, unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/providers/product_provider.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:seller/widgets/vendor_banner_card.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  static const String id = 'banner-screebn';

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final FirebaseServices _services = FirebaseServices();
  final ProductProvider _provider = ProductProvider();
  File? _image = null;
  String pickerError = '';
  final _imagePathText = TextEditingController();

  Future<File?> getBannerImage() async {
    final picker = ImagePicker();
    final PickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (PickedFile != null) {
      setState(() {
        _image = File(PickedFile.path);
      });
    } else {
      this.pickerError = 'No image selected';
      print('NO IMAGE SELECTED');
    }
    return _image;
  }

  Future<String> uploadVendorBanner(filePath, shopName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage.ref('vendorBanner/${shopName}$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await storage
        .ref('vendorBanner/${shopName}$timeStamp')
        .getDownloadURL();

    return downloadURL;
  }

  bool _visible = false;
  bool _saving = false;

  var pressCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalStyles.appBarColor,
        centerTitle: true,
        title: const Text(
          'Banner',
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
        child: ModalProgressHUD(
          inAsyncCall: _saving,
          child: Scaffold(
            body: ListView(
              padding: EdgeInsetsDirectional.zero,
              children: [
                const BannerCard(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Container(
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Add New Banner',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 150,
                          width: GlobalStyles.screenWidth(context),
                          child: Card(
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    fit: BoxFit.fill,
                                  )
                                : const Center(
                                    child: Text(
                                      'No Image Selected',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _imagePathText,
                          enabled: false,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: _visible ? false : true,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _visible = true;
                              });
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
                                    'Add New Banner',
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
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Visibility(
                          visible: _visible,
                          child: Container(
                            child: Column(children: [
                              InkWell(
                                onTap: () {
                                  getBannerImage().then(
                                    (value) {
                                      if (_image != null) {
                                        setState(
                                          () {
                                            _imagePathText.text = _image!.path;
                                          },
                                        );
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  width:
                                      GlobalStyles.screenWidth(context) * 0.9,
                                  decoration: BoxDecoration(
                                    color: GlobalStyles.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Upload Image',
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
                              const SizedBox(
                                height: 5,
                              ),
                              AbsorbPointer(
                                absorbing: _image != null ? false : true,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _saving =
                                          true; // Set saving state to true when button is pressed
                                    });
                                    EasyLoading.show(status: 'Saving...');
                                    uploadVendorBanner(
                                            _image!.path, _provider.shopName)
                                        .then((url) {
                                      if (url != null) {
                                        _services.saveBanner(url);
                                        setState(() {
                                          _imagePathText.clear();
                                          _image = null;
                                          _saving =
                                              false; // Set saving state to false after saving is done
                                        });
                                        EasyLoading.dismiss();
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title:
                                                  const Text('Banner Upload'),
                                              content: const Text(
                                                  'Banner Uploaded Successfully'),
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
                                      } else {
                                        EasyLoading.dismiss();
                                        setState(() {
                                          _saving =
                                              false; // Set saving state to false if saving fails
                                        });
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title:
                                                  const Text('Banner Upload'),
                                              content: const Text(
                                                  'Banner Not Uploaded'),
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
                                    });
                                  },
                                  child: Container(
                                    width:
                                        GlobalStyles.screenWidth(context) * 0.9,
                                    decoration: BoxDecoration(
                                      color: (_image != null && !_saving)
                                          ? GlobalStyles.green
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          'Save',
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
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _visible = false;
                                    _imagePathText.clear();
                                    _image = null;
                                  });
                                },
                                child: Container(
                                  width:
                                      GlobalStyles.screenWidth(context) * 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Cancel',
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
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
