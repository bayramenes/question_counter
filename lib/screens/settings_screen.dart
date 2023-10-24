// packages
import 'package:flutter/material.dart';

// widgets

import '../widgets/app_drawer.dart';

// screens

import './subject_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [],
            ),
            ListTile(
              onTap: () => Navigator.of(context)
                  .pushNamed(SubjectSettingsScreen.routeName),
              leading: Icon(
                Icons.class_,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Subject Settings'),
            ),
            const Spacer(),
            const Text(
              'copyright\u00a9  bayram.enes1928@gmail.com ',
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
