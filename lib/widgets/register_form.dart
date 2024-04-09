// ignore_for_file: unnecessary_null_comparison
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/providers/auth_provider.dart';
import 'package:seller/screens/waiting_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _dialogController = TextEditingController();
  late String email;
  late String mobile;
  late String password;
  late String shopName;
  bool _isLoading = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);

    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      await storage
          .ref('uploads/storeProfilePicture/${_nameController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    //after upload file, file url path to save in firebase

    String downloadUrl = await storage
        .ref('uploads/storeProfilePicture/${_nameController.text}')
        .getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: GlobalStyles.green,
          content: Text(message),
        ),
      );
    }

    return _isLoading
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              GlobalStyles.green,
            ),
          )
        : Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Store Name';
                      }
                      setState(() {
                        _nameController.text = value;
                      });
                      setState(() {
                        shopName = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.add_business,
                        color: Colors.grey,
                      ),
                      labelText: 'Store Name',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter  Your Number';
                      }
                      setState(() {
                        mobile = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixText: '+63',
                      prefixIcon: const Icon(
                        Icons.phone_android,
                        color: Colors.grey,
                      ),
                      labelText: 'Mobile Number',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter  Your Email Address';
                      }
                      final bool isvalid =
                          EmailValidator.validate(_emailController.text);
                      if (!isvalid) {
                        return 'Invalid Email Format';
                      }
                      setState(() {
                        email = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      labelText: 'Email Address',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Password';
                      }
                      if (value.length < 6) {
                        return 'Password Should be a Minimum of 6';
                      }
                      setState(() {
                        password = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: Colors.grey,
                      ),
                      labelText: 'Password',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm Your Password';
                      }
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        return "Password doesn't Match";
                      }
                      if (value.length < 6) {
                        return 'Password Should be a Minimum of 6';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: Colors.grey,
                      ),
                      labelText: 'Confirm Password',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    maxLines: 5,
                    controller: _addressController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide Your Address';
                      }
                      if (authData.shopLatitude == null) {
                        return 'Please Provide Your Address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.contact_mail,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.location_searching),
                        onPressed: () {
                          _addressController.text = 'Locating... Please Wait.';
                          authData.getCurrentAddress().then(
                            (address) {
                              if (address != null) {
                                setState(
                                  () {
                                    _addressController.text =
                                        '${authData.storePlaceName} \n ${authData.shopAddress}';
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                      labelText: 'Store Address',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      _dialogController.text = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.comment,
                        color: Colors.grey,
                      ),
                      labelText: 'Store Dialog',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (authData.image == null) {
                        scaffoldMessage('Please select your store image');
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      authData
                          .registerVendor(email, password)
                          .then((credential) {
                        if (credential != null &&
                            credential.user != null &&
                            credential.user!.uid != null) {
                          uploadFile(authData.image.path).then((url) {
                            if (url != null) {
                              authData
                                  .saveVendorDataToFirestore(
                                url: url,
                                mobile: mobile,
                                shopName: shopName,
                                dialog: _dialogController.text,
                              )
                                  .then((_) {
                                setState(() {
                                  _isLoading = false;
                                });
                                scaffoldMessage('Registration successful');
                                Navigator.pushReplacementNamed(
                                    context, WaitingScreen.id);
                              }).catchError((error) {
                                scaffoldMessage(
                                    'Failed to save vendor data: $error');
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            } else {
                              scaffoldMessage('Failed to upload store image');
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          });
                        } else {
                          scaffoldMessage(authData.error);
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    } else {
                      scaffoldMessage('Please Select Your Store Image...');
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(
                        Size(GlobalStyles.screenWidth(context), 40)),
                    backgroundColor: MaterialStatePropertyAll(
                      GlobalStyles.green,
                    ),
                    shape: const MaterialStatePropertyAll(
                      BeveledRectangleBorder(side: BorderSide.none),
                    ),
                  ),
                  child: const Text('Register'),
                )
              ],
            ),
          );
  }
}
