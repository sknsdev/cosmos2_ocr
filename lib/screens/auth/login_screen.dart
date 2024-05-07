import 'package:flutter/material.dart';
import 'package:ocr_cosmos2/components/common/my_button.dart';
import 'package:ocr_cosmos2/components/common/my_textfield.dart';
import 'package:ocr_cosmos2/router/go_router.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // username validator
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  // password validator
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

// кпнока для перехода на следующую страницу при успешной валидации формы
  void signInUser(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      goRouterCustom.go('/main_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 223, 255),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                // logo
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                // welcome back, you've been missed!
                const SizedBox(height: 50),
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),

                // username text field
                MyTextField(
                  controller: usernameController,
                  labelText: 'Username',
                  obscureText: false,
                  // validator: validateUsername,
                ),

                const SizedBox(height: 25),

                // password text field
                MyTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  // validator: validatePassword,
                ),

                const SizedBox(height: 50),

                // sign in button
                MyButton(
                  title: 'Sign-in',
                  onTap: () => signInUser(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
