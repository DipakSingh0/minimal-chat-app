import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/my_button.dart';
import 'package:chat/components/my_textfield.dart';
import 'package:flutter/material.dart';

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
      showDialog(context: context, builder: 
      (context) => AlertDialog(
        title: Text(e.toString()),
      ));
    }

  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.message,
                size: 60,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 50),
              //welcome back message
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                  color: theme.colorScheme.primary,
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
                        color: theme.colorScheme.primary,
                      )),
                  GestureDetector(
                    // onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                    onTap: onTap ,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
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
