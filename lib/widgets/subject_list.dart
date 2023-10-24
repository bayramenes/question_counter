// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/subject_provider.dart';

// widget
import './subject_item.dart';

// screens

// configuration
import '../configuration/scroll_behavior.dart';

class SubjectList extends StatelessWidget {
  Widget build(BuildContext context) {
    // a listener to the changes in the subjects provider

    final Subjects = Provider.of<SubjectProvider>(context);
    final SubjectsList = Subjects.items;
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: SubjectsList.length,
        itemBuilder: (BuildContext context, int index) {
          // the current subject based on the index given from the builder
          var currentSubject = SubjectsList[index];
          return subjectItem(
            id: currentSubject.id,
            name: currentSubject.name,
            icon: Icon(currentSubject.icon),
            color: currentSubject.color,
          );
        },
      ),
    );
  }
}
