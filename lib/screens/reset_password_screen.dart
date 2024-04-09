// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/providers/auth_provider.dart';
import 'package:seller/screens/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  static const String id = 'reset-password-screen';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  late String email;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset('lib/images/forgot-password.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Enter Your Registered Email, We will send you and Email to Reset yout Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Email';
                    }
                    final bool _isValid =
                        EmailValidator.validate(_emailController.text);
                    if (!_isValid) {
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
                  height: 30,
                ),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                        email = _emailController.text;
                      });
                      _authData.resetPassword(email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: GlobalStyles.green,
                          content: Text(
                              'We have sent a reset link to you email (${_emailController.text}).'),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                    Future.delayed(const Duration(seconds: 5), () {
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
                    });
                  },
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
                      : const Text('Reset Password'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
