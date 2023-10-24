// packages

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:question_counter/providers/question_provider.dart';
import 'package:question_counter/providers/subject_provider.dart';

// screens

import '../screens/settings_screen.dart';
import '../screens/week_summary_screen.dart';

// proviers
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget listTileBuilder(String routeName, String label, IconData icon) {
      return ListTile(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(routeName);
        },
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      );
    }

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Center(
              child: Text('Questionerd'),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          listTileBuilder(
            WeekSummaryScreen.routeName,
            'Week Summary',
            Icons.school,
          ),
          listTileBuilder(
            SettingsScreen.routeName,
            'Settings',
            Icons.settings,
          ),
          Spacer(),
          ListTile(
            onTap: () {
              Provider.of<SubjectProvider>(context, listen: false)
                  .clearSubjects();
              Provider.of<QuestionsProvider>(context, listen: false)
                  .clearQuestions();
              Provider.of<AuthProvider>(context, listen: false).logOut();
            },
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
