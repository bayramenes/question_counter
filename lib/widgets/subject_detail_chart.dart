// packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/question_provider.dart';

// widgets
import './subject_detail_chart_bar.dart';

class SubjectDetailChart extends StatelessWidget {
  final String subjectId;

  SubjectDetailChart(this.subjectId);

  // get the total question count for the whole week

  // get the questions list for a certina given weekday
  List<QuestionItem> getOneDayQuestion(
      List<QuestionItem> recentQuestions, DateTime weekDay) {
    List<QuestionItem> weekDayQuestions = [];
    for (var question in recentQuestions) {
      if (question.date.day == weekDay.day &&
          question.date.month == weekDay.month &&
          question.date.year == weekDay.year) {
        weekDayQuestions.add(question);
      }
    }
    return weekDayQuestions;
  }

  // get the question count for a specific week day
  int _weekDayCount({required List<QuestionItem> questions}) {
    int totalCount = 0;
    questions.forEach((question) {
      totalCount += question.count;
    });
    return totalCount;
  }

  @override
  Widget build(BuildContext context) {
    final questionProvider =
        Provider.of<QuestionsProvider>(context, listen: false);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            7,
            (index) {
              DateTime weekDay = DateTime.now().subtract(Duration(days: index));

              List<QuestionItem> lastWeekSubjectQuestions =
                  questionProvider.getLastWeekSubjectQuestions(subjectId);

              return ChartBar(
                label: DateFormat.E().format(weekDay),
                weekDayQuestionCount: _weekDayCount(
                  questions: questionProvider.getOneDayQuestions(
                    lastWeekSubjectQuestions,
                    weekDay,
                  ),
                ),
                totalCount: questionProvider.getTotalOfAWeek(
                  lastWeekSubjectQuestions,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
