import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/my_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //logout
  void logout() {
    //get auth service
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.secondary,
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [
          //logoutButton
          IconButton(icon: Icon(Icons.logout), onPressed: logout),
        ],
        centerTitle: true,
      ),

      drawer: MyDrawer(),
    );
  }
}
