import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_a_z/auth/auth_service.dart';
import 'package:shop_a_z/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errMsg = '';
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email Address'
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Provide a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password (at least 6 characters)',
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: _obscureText
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)
                    )
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Provide a valid password';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _authenticate,
                child: const Text('Login as Admin'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_errMsg, style: const TextStyle(fontSize: 18, color: Colors.red),)
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticate() async {
    if(_formKey.currentState!.validate()) {
      // EasyLoading.show(status: 'Please wait');
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator(),);
          },
      );
      final email = _emailController.text;
      final pass = _passwordController.text;
      try {
        final status = await AuthService.loginAdmin(email, pass);
        // EasyLoading.dismiss();
        Navigator.of(context).pop();
        if(status) {
          context.goNamed(DashboardPage.routeName);
        } else {
          await AuthService.logout();
          setState(() {
            _errMsg = 'Invalid Admin Account';
          });
        }
      } on FirebaseAuthException catch(err) {
        // EasyLoading.dismiss();
        Navigator.of(context).pop();
        setState(() {
          _errMsg = err.message!;
        });
      }
    }
  }
}
