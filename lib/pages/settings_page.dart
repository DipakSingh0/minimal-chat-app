import 'package:chat/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blocked_users_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Center(child: Text("Settings")),
        backgroundColor: theme.primary,
        elevation: 0,
        // centerTitle: true,
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            //dark mode
            Container(
              decoration: BoxDecoration(
                color: theme.secondary,
                borderRadius: BorderRadius.circular(12),
              ), // BoxDecoration
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Dark Mode" text
                  const Text("Dark Mode"),
                  // Switch toggle
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context, listen: false)
                        .isDarkMode,
                    onChanged: (value) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(),
                  ), // CupertinoSwitch
                ],
              ), // Row
            ),

            //block user
            Container(
              decoration: BoxDecoration(
                color: theme.secondary,
                borderRadius: BorderRadius.circular(12),
              ), // BoxDecoration
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Blocked Users"),
                  // button to go to blocked user page
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlockedUsersPage(),
                      ),
                    ),
                    icon:
                        Icon(Icons.arrow_forward_rounded, color: theme.primary),
                  ),
                ],
              ), // Row
            ),
          ],
        ),
      ), // Container
    );
  }
}
