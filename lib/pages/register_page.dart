import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/components/my_textfield.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  //tap to go to login page
  void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  //register
  void register(BuildContext context) {
    // get auth service
    final _auth = AuthService();

    //if password match then create user 
    if (_passwordController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    //password dont match show error that user fixes
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Passwords do not match'),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: theme.primary,
            ),

            const SizedBox(height: 50),
            //welcome back message
            Text(
              "Let's create an account for you!",
              style: TextStyle(
                color: theme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            //email textfield
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(height: 10),

            //email textfield
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 10),

            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confirmPwController,
            ),
            const SizedBox(height: 15),

            //login button
            MyButton(text: 'Register', onTap: () => register(context)),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account?",
                  style: TextStyle(
                    color: theme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      color: theme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
