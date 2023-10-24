// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets

import '../widgets/subject_settings_list.dart';

// providers

import '../providers/subject_provider.dart';

class SubjectSettingsScreen extends StatelessWidget {
  static const routeName = 'subject-settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject settings'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Provider.of<SubjectProvider>(context, listen: false)
                    .startNewSubject(ctx: context, isNew: true, id: ''),
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: SubjectSettingsList(),
    );
  }
}
