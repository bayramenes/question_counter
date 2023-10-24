// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/subject_provider.dart';

// widgets

import 'subject_setting_item.dart';

// config
import '../configuration/scroll_behavior.dart';

class SubjectSettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subjectsProvider = Provider.of<SubjectProvider>(context);
    final subjectsList = subjectsProvider.items;
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView.builder(
        itemCount: subjectsProvider.items.length,
        itemBuilder: (BuildContext context, int index) {
          return SubjectSettingItem(
            id: subjectsList[index].id,
            name: subjectsList[index].name,
            color: subjectsList[index].color,
            icon: subjectsList[index].icon,
          );
        },
      ),
    );
  }
}
