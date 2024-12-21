import 'package:chat/components/user_tile.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/components/my_drawer.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //cahat and auth service
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

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
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Text("HomePage"),
        backgroundColor:theme.primary,
        elevation: 0,
        actions: [
          //logoutButton
          IconButton(icon: Icon(Icons.logout), onPressed: logout),
        ],
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      
      body: _buildUserList(),
    );
  }

  //build a list of users except for thte current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return const Text("Loading...");
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No users found");
          // return Text('No data found');
        }
        // return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

//build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //build a list of users except for thte current logged in user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
          text: userData["email"],
          onTap: () {
            // Tapped on a user -> go to chat page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData["email"],
                  receiverID: userData["uid"],
                ),
              ),
            );
          });
    } else {
      return (Container());
    }
  }
}
