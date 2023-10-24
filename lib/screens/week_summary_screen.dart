// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// widgets

import '../widgets/app_drawer.dart';

import '../widgets/subject_list.dart';
import '../widgets/question_add_sheet.dart';
import '../widgets/upper_chart_widget.dart';

import '../providers/subject_provider.dart';

class WeekSummaryScreen extends StatelessWidget {
  static const routeName = '/week-summary';

  // show the modal bottom sheet to be able to add a new question

  void startNewQuestion(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (context) {
        return NewQuestionBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text("Questionerd"),
        centerTitle: true,
        actions: [
          // appbar add button to be able to add a question later
          IconButton(
            onPressed: () => startNewQuestion(context),
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.filter_alt,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<SubjectProvider>(context, listen: false)
            .fetchAndSetSubjects(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Chart(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    flex: 4,
                    child: SubjectList(),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text('Sorry for inconvinience an error occured :(('),
          );
        },
      ),
    );
  }
}
