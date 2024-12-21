import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  //tap to go to login page
  void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  //register
  void register(BuildContext context) async {
    // get auth service
    // ignore: no_leading_underscores_for_local_identifiers
    final _auth = AuthService();
    

    //if password match then create user
    if (_passwordController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        // Save additional details (name)
        // await  _auth.saveUserDetails(
        //   // email: _emailController.text,
        //   uid: UserCredential.user!.uid,
        //   firstName: _firstNameController.text,
        //   lastName: _lastNameController.text, 
        // );

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
      // ignore: deprecated_member_use
      backgroundColor: theme.background,
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: theme.primary,
            ),
            //welcome back message
            Text(
              "Let's create an account for you!",
              style: TextStyle(
                color: theme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            MyTextField(
              hintText: "First Name",
              obscureText: false,
              controller: _firstNameController,
            ),
            MyTextField(
              hintText: "Last Name",
              obscureText: false,
              controller: _lastNameController,
            ),

            //email textfield
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            //email textfield
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _passwordController,
            ),

            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confirmPwController,
            ),
            const SizedBox(height: 5),

            //login button
            MyButton(text: 'Register', onTap: () => register(context)),

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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
