// packages

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// providers
import '../providers/question_provider.dart';

// widgets

import '../widgets/question_item_widget.dart';
import '../widgets/subject_detail_chart.dart';

class SubjectDetailScreen extends StatelessWidget {
  static const routeName = '/subject-detail';

  @override
  Widget build(BuildContext context) {
    // subject name get from the arguments of the push
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // a listener to the changes in questions for a certain subject
    final questionsProvider =
        Provider.of<QuestionsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              routeArgs['name'] as String,
            ),
            const SizedBox(
              width: 10,
            ),
            routeArgs['icon'] as Widget,
          ],
        ),
      ),
      body: FutureBuilder(
        future: questionsProvider.getAllQuestionsOfASubject(routeArgs['id']),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final List<QuestionItem> questionsList = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Consumer<QuestionsProvider>(
                      builder: (context, value, child) => SubjectDetailChart(
                        routeArgs['id'],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ListView.builder(
                      itemCount: questionsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return QuestionItemWidget(questionsList[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text('Sorry an error occured :(('),
          );
        },
      ),
    );
  }
}
