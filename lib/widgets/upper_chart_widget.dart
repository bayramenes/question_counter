// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers

import '../providers/question_provider.dart';
// widgets
import './pie_chart_widget.dart';

class Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionsProvider>(context);

    return FutureBuilder(
      future: questionProvider.fetchAndSetQuestions(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (questionProvider.items.isEmpty) {
          return Image.asset(
            'assets/images/cat.jpeg',
            height: 400,
          );
        }
        return PieChartWidget();
      },
    );
  }
}
