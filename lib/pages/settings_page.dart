import 'package:chat/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Center(child: Text("Settings")),
        backgroundColor: theme.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.secondary,
          borderRadius: BorderRadius.circular(12),
        ), // BoxDecoration
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // "Dark Mode" text
            const Text("Dark Mode"),
            // Switch toggle
            CupertinoSwitch(
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
            ), // CupertinoSwitch
          ],
        ), // Row
      ), // Container
    );
  }
}
