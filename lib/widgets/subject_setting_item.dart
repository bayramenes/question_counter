// packages
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// providers

import '../providers/question_provider.dart';
import '../providers/subject_provider.dart';

class SubjectSettingItem extends StatelessWidget {
  final String id;
  final Color color;
  final String name;
  final IconData icon;

  SubjectSettingItem({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final subjectsProvider =
        Provider.of<SubjectProvider>(context, listen: false);
    final questionsProvider =
        Provider.of<QuestionsProvider>(context, listen: false);
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      child: Dismissible(
        confirmDismiss: (_) => showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: Text("Are you sure that you want to delete $name ? "),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ),
        onDismissed: (direction) {
          subjectsProvider.removeSubject(id);
          questionsProvider.removeSubjectQuestions(id);
        },
        direction: DismissDirection.endToStart,
        background: Container(
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          color: Colors.red.shade900,
          child: const Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
        key: ValueKey(name),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            title: Text(
              name,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                subjectsProvider.startNewSubject(
                  id: id,
                  ctx: context,
                  isNew: false,
                  originalColor: color,
                  originalName: name,
                  originalIcon: icon,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
