import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'auth_provider.dart';

class QuestionItem with ChangeNotifier {
  String id;
  DateTime date;
  int count;
  String subjectId;

  QuestionItem({
    required this.id,
    required this.count,
    required this.date,
    required this.subjectId,
  });

  // change the date of an item

  void changeDate(DateTime newDate) {
    date = newDate;
  }

  // change the question count of a question item

  void changeCount(int newCount) {
    count = newCount;
  }
}

class QuestionsProvider with ChangeNotifier {
  String userId = AuthProvider().userId!;
  List<QuestionItem> _items = [];

  FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://question-counter-d3ba5-default-rtdb.europe-west1.firebasedatabase.app/');

  // return the items in a new list so that we avoid any bugs

  List<QuestionItem> get items {
    return [..._items];
  }

  // add a question to the list and notify the interested parts of the app
  void addQuestion(int count, String subjectId, DateTime date) async {
    DatabaseReference ref = database.ref("users/$userId/questions");
    final newQuestionKey =
        FirebaseDatabase.instance.ref().child('subjects/$userId').push().key;
    await ref.child('$newQuestionKey').set({
      'count': count,
      'date': date.toIso8601String(),
      'dateInt': date.millisecondsSinceEpoch,
      'subjectId': subjectId,
    });

    _items.insert(
      0,
      QuestionItem(
        id: newQuestionKey!,
        count: count,
        date: date,
        subjectId: subjectId,
      ),
    );

    notifyListeners();
  }

  // get the total question count from the list of questions
  // and since the questions list is only the list of subjects of the last week

  List<QuestionItem> get LastWeekQuestions {
    return _items
        .where(
          (question) => question.date.isAfter(
            DateTime.now().subtract(
              const Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  int getTotalOfAWeek(List<QuestionItem> weekQuestions) {
    int total = 0;
    weekQuestions.forEach((question) => total += question.count);
    return total;
  }

  List<QuestionItem> getOneDayQuestions(
      List<QuestionItem> questions, DateTime weekDay) {
    return questions
        .where(
          (question) =>
              question.date.day == weekDay.day &&
              question.date.month == weekDay.month &&
              question.date.year == weekDay.year,
        )
        .toList();
  }

  List<QuestionItem> getLastWeekSubjectQuestions(String subjectId) {
    return LastWeekQuestions.where((question) {
      if (question.subjectId == subjectId &&
          question.date.isAfter(
            DateTime.now().subtract(
              const Duration(days: 7),
            ),
          )) {
        return true;
      }
      return false;
    }).toList();
  }

  List<QuestionItem> getLastWeek(List<QuestionItem> allQuestions) {
    return allQuestions
        .where(
          (question) => question.date.isAfter(
            DateTime.now().subtract(
              Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  int GetQuestionCountOfASubjectInAWeek(
      List<QuestionItem> weekQuestion, String subjectId) {
    int total = 0;
    List<QuestionItem> subjectQuestions = weekQuestion
        .where((question) => question.subjectId == subjectId)
        .toList();
    subjectQuestions
        .forEach((subjectQuestion) => total += subjectQuestion.count);
    return total;
  }

  // remove questions for a given subject

  Future<void> removeSubjectQuestions(String subjectId) async {
    DatabaseReference ref = database.ref('users/$userId/questions');
    try {
      final subjectQuestions =
          await ref.orderByChild("subjectId").equalTo(subjectId).get();

      for (var question in subjectQuestions.children.toList()) {
        question.ref.remove();
      }
    } catch (error) {}

    _items.removeWhere((question) => question.subjectId == subjectId);

    notifyListeners();
  }

  // fetch and set questions

  Future<void> fetchAndSetQuestions() async {
    DatabaseReference ref = database.ref("users/$userId/questions");
    try {
      DataSnapshot response = await ref
          .orderByChild("dateInt")
          .startAt(DateTime.now()
              .subtract(const Duration(days: 7))
              .millisecondsSinceEpoch)
          .get();
      List<QuestionItem> loadedQuestions = [];

      final questions =
          Map<String, dynamic>.from(response.value as Map<Object?, Object?>);

      questions.forEach((questionId, questionData) {
        loadedQuestions.add(
          QuestionItem(
            id: questionId,
            count: questionData['count'],
            date: DateTime.parse(questionData['date']),
            subjectId: questionData['subjectId'],
          ),
        );
      });

      _items = loadedQuestions;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<List<QuestionItem>> getAllQuestionsOfASubject(String subjectId) async {
    DatabaseReference ref = database.ref('users/$userId/questions');
    try {
      final subjectQuestions =
          await ref.orderByChild("subjectId").equalTo(subjectId).get();

      final questions = Map<String, dynamic>.from(
          subjectQuestions.value as Map<Object?, Object?>);
      List<QuestionItem> loadedQuestions = [];

      questions.forEach((questionId, questionData) {
        loadedQuestions.add(
          QuestionItem(
            id: questionId,
            count: questionData['count'],
            date: DateTime.parse(questionData['date']),
            subjectId: questionData['subjectId'],
          ),
        );
      });
      loadedQuestions.sort((QuestionItem first, QuestionItem second) =>
          second.date.compareTo(first.date));

      print('done');
      return loadedQuestions;
    } catch (error) {
      return [];
    }
  }

  void removeQuestion(QuestionItem questionToDelete, String subjectId) async {
    DatabaseReference ref =
        database.ref('users/$userId/questions/${questionToDelete.id}');
    await ref.remove();

    _items.remove(questionToDelete);
    notifyListeners();
  }

  // subject detail screen methods <----

  // update question

  Future<void> updateQuestion(
      QuestionItem questionToUpdate, int newCount, DateTime newDate) async {
    DatabaseReference ref =
        database.ref('users/$userId/questions/${questionToUpdate.id}');

    await ref.update(
      {
        'count': newCount,
        'date': newDate.toIso8601String(),
        'dateInt': newDate.millisecondsSinceEpoch,
      },
    );

    questionToUpdate.changeCount(newCount);
    questionToUpdate.changeDate(newDate);

    notifyListeners();
  }

  void clearQuestions() {
    _items = [];
    notifyListeners();
  }
}
