// packages

import 'package:flutter/material.dart';

// screens
import '../screens/subject_detail_screen.dart';

// the list item for list view that displays subject icon along with subject name and the question count for the last week

class subjectItem extends StatelessWidget {
  // properties which will be passed from listview builder function from the subject object from the subject list
  final String id;
  final String name;
  final Icon icon;
  final Color color;

  subjectItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          SubjectDetailScreen.routeName,
          arguments: {
            'name': name,
            'icon': icon,
            'id': id,
          },
        );
      },
      child: Card(
        child: GridTile(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: icon,
                foregroundColor: Theme.of(context).primaryIconTheme.color,
              ),
              FittedBox(child: Text(name)),
            ],
          ),
        ),
      ),
    );
  }
}
