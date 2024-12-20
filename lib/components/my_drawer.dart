import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

    //logout
  void logout() {
    //get auth service
    // ignore: no_leading_underscores_for_local_identifiers
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Drawer(
      // ignore: deprecated_member_use
      backgroundColor: theme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // DrawerHeader
            Column(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Icon(
                      Icons.message,
                      color: theme.primary,
                      size: 40,
                    ),
                  ),
                ),

                // home list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text('H O M E'),
                    leading: Icon(Icons.home),
                    onTap: () {
                      //pop the drawer
                      Navigator.pop(context);
                    },
                  ),
                ),
                // settings list tile
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    title: const Text('S E T T I N G S'),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      //pop settings page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()));
                    },
                  ),
                ),
              ],
            ),
            // logout list tile
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25),
              child: ListTile(
                title: const Text('L O G O U T'),
                leading: Icon(Icons.logout),
                onTap: logout
              ),
            ),
          ],
        ),
      ),
    );
  }
}
