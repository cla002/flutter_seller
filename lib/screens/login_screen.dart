// ignore_for_file: unnecessary_null_comparison, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/providers/auth_provider.dart';
import 'package:seller/screens/home_screen.dart';
import 'package:seller/screens/registration_screen.dart';
import 'package:seller/screens/reset_password_screen.dart';
import 'package:seller/screens/waiting_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late Icon icon;
  bool _visible = false;
  var _emailController = TextEditingController();
  var _passwordController =
      TextEditingController(); // Define password controller
  late String email;
  late String password;
  late AuthProvider _authData;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'L',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 48),
                        ),
                        Image.asset(
                          'lib/images/logo.png',
                          height: 45,
                        ),
                        const Text(
                          'GIN',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 48),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your Email';
                        }
                        final bool isValid =
                            EmailValidator.validate(_emailController.text);
                        if (!isValid) {
                          return 'Invalid Email Address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController, // Assign controller
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your Password';
                        }
                        if (value.length < 6) {
                          return 'Password should be a minimum of 6';
                        }
                        setState(() {
                          password = value;
                        });
                        return null;
                      },
                      obscureText: !_visible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.vpn_key),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _visible = !_visible;
                            });
                          },
                          icon: _visible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ResetPasswordScreen.id);
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FilledButton(
                      onPressed: _attemptLogin,
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(GlobalStyles.screenWidth(context), 40)),
                        backgroundColor: MaterialStateProperty.all(
                          GlobalStyles.green,
                        ),
                        shape: MaterialStateProperty.all(
                          const BeveledRectangleBorder(side: BorderSide.none),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Login'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an Account?",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _attemptLogin() {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _loading = true;
  //     });
  //     email = _emailController.text;
  //     final password = _passwordController.text;

  //     _authData.loginVendor(email, password).then((credential) {
  //       if (credential != null &&
  //           credential.user != null &&
  //           credential.user!.uid != null) {
  //         setState(() {
  //           _loading = false;
  //         });
  //         Navigator.pushReplacementNamed(context, HomeScreen.id);
  //       } else {
  //         setState(() {
  //           _loading = false;
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             backgroundColor: Colors.red,
  //             content: Text(_authData.error),
  //           ),
  //         );
  //       }
  //     });
  //   }
  // }

  void _attemptLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      email = _emailController.text;
      final password = _passwordController.text;

      _authData.loginVendor(email, password).then((credential) {
        if (credential != null &&
            credential.user != null &&
            credential.user!.uid != null) {
          // Fetch accountVerified status from Firestore for the logged-in user
          FirebaseFirestore.instance
              .collection('vendors')
              .doc(credential.user!.uid)
              .get()
              .then((doc) {
            if (doc.exists) {
              // Check if the account is verified
              bool accountVerified = doc['accountVerified'];
              if (accountVerified) {
                setState(() {
                  _loading = false;
                });
                Navigator.pushReplacementNamed(context, HomeScreen.id);
              } else {
                // Account not verified, navigate to WaitingScreen
                setState(() {
                  _loading = false;
                });
                Navigator.pushReplacementNamed(context, WaitingScreen.id);
              }
            } else {
              // Document does not exist, handle error
              setState(() {
                _loading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Error: User data not found"),
                ),
              );
            }
          });
        } else {
          setState(() {
            _loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(_authData.error),
            ),
          );
        }
      });
    }
  }
}
