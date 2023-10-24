// packages

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

// screens

// providers

import './auth_provider.dart';
// widgets

import '../widgets/subject_add_edit_sheet.dart';

// subject class for the subject object that will be defined by default and for the ones that the user will be able to add
class SubjectItem with ChangeNotifier {
  String id;
  String name;

  IconData icon;
  Color color;
  SubjectItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // change the details of the subject item

  // change the name of the subject
  void ChangeName(String newName) {
    name = newName;
    // notifyListeners();
  }

  // change the icon of the subjct
  void ChangeIcon(IconData newIcon) {
    icon = newIcon;
    // notifyListeners();
  }

  // change the color of the subjct
  void ChangeColor(Color newColor) {
    color = newColor;
    // notifyListeners();
  }

  static SubjectItem toSubject(String subjectId, subjectData) {
    return SubjectItem(
        id: subjectId,
        name: subjectData['name'],
        icon: subjectData['icon'],
        color: subjectData['color']);
  }
}

class SubjectProvider with ChangeNotifier {
  String userId = AuthProvider().userId!;

  FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://question-counter-d3ba5-default-rtdb.europe-west1.firebasedatabase.app/');

  List<SubjectItem> _items = [];

  // a getter to return the list in a new pointer in the memory

  List<SubjectItem> get items {
    return [..._items];
  }

  // get the corresponding subject item

  SubjectItem correspondingItemById(String subjectId) {
    return _items.firstWhere((item) => item.id == subjectId);
  }
  // get the corresponding subject item

  SubjectItem correspondingItemByName(String name) {
    return _items.firstWhere((item) => item.name == name);
  }

  // fetch and set subjects of the user

  Future<void> fetchAndSetSubjects() async {
    DatabaseReference ref = database.ref();
    DataSnapshot response = await ref.child("users/$userId/subjects").get();

    List<SubjectItem> loadedSubjects = [];

    final subjects =
        Map<String, dynamic>.from(response.value as Map<Object?, Object?>);
    subjects.forEach((subjectId, subjectData) {
      loadedSubjects.add(
        SubjectItem(
          id: subjectId,
          name: subjectData['name'],
          color: Color(subjectData['color']),
          icon: IconData(subjectData['icon'], fontFamily: 'MaterialIcons'),
        ),
      );
    });

    _items = loadedSubjects;

    notifyListeners();
  }

  // add a new subject

  Future<void> addSubject({
    required Color color,
    required String name,
    required IconData icon,
  }) async {
    final newSubjectKey =
        FirebaseDatabase.instance.ref().child('subjects/$userId').push().key;
    DatabaseReference ref =
        database.ref("users/$userId/subjects/$newSubjectKey");

    await ref.set({
      'name': name,
      'icon': icon.codePoint,
      'color': color.value,
    });

    _items.add(
      SubjectItem(
        id: newSubjectKey!,
        name: name,
        icon: icon,
        color: color,
      ),
    );

    notifyListeners();
  }

  // remove a subject given it's name

  void removeSubject(String subjectId) async {
    DatabaseReference ref = database.ref("users/$userId/subjects/$subjectId");
    SubjectItem oldSubject = correspondingItemById(subjectId);

    ref.remove();

    // remove it from the list
    _items.remove(oldSubject);
    notifyListeners();
  }

  // update subject

  void updateSubject({
    required String id,
    required Color newColor,
    required String newName,
    required IconData newIcon,
  }) async {
    DatabaseReference ref = database.ref();

    await ref.child('users/$userId/subjects/$id').update({
      "color": newColor.value,
      "icon": newIcon.codePoint,
      "name": newName,
    });

    final SubjectItem itemToEdit = correspondingItemById(id);

    itemToEdit.ChangeColor(newColor);

    itemToEdit.ChangeIcon(newIcon);

    itemToEdit.ChangeName(newName);

    notifyListeners();
  }

  void startNewSubject({
    required String id,
    required BuildContext ctx,
    required bool isNew,
    String? originalName,
    Color? originalColor,
    IconData? originalIcon,
  }) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      context: ctx,
      builder: (context) {
        return isNew
            ? SubjectAddEditSheet.newSubject(isNew)
            : SubjectAddEditSheet.editSubject(
                id: id,
                isNew: isNew,
                originalColor: originalColor,
                originalName: originalName,
                originalIcon: originalIcon,
              );
      },
    );
  }

  void clearSubjects() {
    _items = [];
    notifyListeners();
  }
}
