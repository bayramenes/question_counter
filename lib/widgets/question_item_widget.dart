// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// providers

import '../providers/question_provider.dart';

// widget
import './question_edit_bottom_sheet.dart';

class QuestionItemWidget extends StatelessWidget {
  final QuestionItem question;

  QuestionItemWidget(this.question);

  void startQuestionEdit(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx,
      builder: (context) => QuestionEditBottomSheet(
        question: question,
        count: question.count,
        originalDate: question.date,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionsProvider = Provider.of<QuestionsProvider>(context);
    // final singleQuestionProvider = Provider.of<QuestionItem>(context);

    void submitChanges(int count, DateTime date) {
      questionsProvider.updateQuestion(question, count, date);
    }

    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      child: Dismissible(
        onDismissed: (direction) {
          questionsProvider.removeQuestion(question, '');
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
        key: ValueKey(question.id),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                question.count.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white),
              ),
            ),
            title: Text(
              DateFormat('dd/MM/yyyy').format(question.date),
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => startQuestionEdit(context),
            ),
          ),
        ),
      ),
    );
  }
}
