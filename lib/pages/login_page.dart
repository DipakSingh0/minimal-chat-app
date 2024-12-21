import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/components/my_button.dart';
import 'package:chat/components/my_textfield.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  //controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //tap to go to register page
  void Function()? onTap ; 


  LoginPage({super.key, required this.onTap});

  //login method
  void login(BuildContext context)async {
    //auth service
    final authService = AuthService();  

    //try login
    try {
    await authService.signInWithEmailAndPassword(_emailController.text, _passwordController.text ,);
    
    }

    //catch error
    catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: 
      (context) => AlertDialog(
        title: Text(e.toString()),
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
                "Welcome back, you've been missed!",
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


              //login button
              MyButton(
                text: 'Login', 
                onTap: ()=> login(context),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member?",
                      style: TextStyle(
                        color: theme.primary,
                      )),
                  GestureDetector(
                    // onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                    onTap: onTap ,
                    child: Text(
                      "Register now",
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
        ));
  }
}
