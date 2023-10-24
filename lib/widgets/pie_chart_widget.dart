// packages

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

// providers

import '../providers/question_provider.dart';
import '../providers/subject_provider.dart';

class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subjectsProvider =
        Provider.of<SubjectProvider>(context, listen: false);
    final questionsProvider =
        Provider.of<QuestionsProvider>(context, listen: false);

    final List<QuestionItem> lastWeekQuestions =
        questionsProvider.LastWeekQuestions;

    final totalQuestionCount =
        questionsProvider.getTotalOfAWeek(lastWeekQuestions);
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sections: subjectsProvider.items.map((subject) {
              double questionCountForASubject =
                  questionsProvider.GetQuestionCountOfASubjectInAWeek(
                          lastWeekQuestions, subject.id) *
                      1;

              return PieChartSectionData(
                  // titleStyle: const TextStyle(fontSize: 15),
                  titlePositionPercentageOffset: 0.5,
                  color: subject.color,
                  value: questionCountForASubject,
                  title: questionCountForASubject.toStringAsFixed(0),
                  titleStyle: const TextStyle(color: Colors.white));
            }).toList(),
          ),
          swapAnimationCurve: Curves.linear,
          swapAnimationDuration: const Duration(milliseconds: 240),
        ),
        Text(
          totalQuestionCount.toString(),
          style: const TextStyle(fontSize: 25),
        ),
      ],
    );
  }
}
// '% ${((questionCountForASubject / totalQuestionCount) * 100).toStringAsFixed(1)}'