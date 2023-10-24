// dart utility
import 'dart:io';

// packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
// theme
import '../theme/themeClass.dart';

// providers
import '../providers/question_provider.dart';
import '../providers/subject_provider.dart';

class NewQuestionBottomSheet extends StatefulWidget {
  @override
  State<NewQuestionBottomSheet> createState() => _NewQuestionBottomSheetState();
}

class _NewQuestionBottomSheetState extends State<NewQuestionBottomSheet> {
  // global key for the form

  final GlobalKey<FormState> _formKey = GlobalKey();

  // a variable to control the color of the arrow beside the subject selector so that if it is the error it will turn red
  // and it is initialized in inistate
  Color? subjectDropDownColor;

  // a string to manipulate what to display on the date button and control its color
  String dateButtonText = 'Pick A Date';
  Color dateButtonTextColor = Colors.white;

  // a string to display the subject that user will choose
  String? dropDownButtonValue;

  // a datetime object that stores which date was selected
  DateTime? _selectedDate;

  final TextEditingController questionCountController =
      TextEditingController(text: '');

  @override
  void didChangeDependencies() {
    subjectDropDownColor = Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  materialDatePickerBuilder(BuildContext ctx) {
    showDatePicker(
        context: ctx,
        initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now(),
        builder: (ctx, child) {
          return child!;
        }).then(
      (_pickedDate) {
        if (_pickedDate != null) {
          setState(() {
            dateButtonText = DateFormat.yMMMd().format(_pickedDate);
            _selectedDate = _pickedDate;
            dateButtonTextColor = Colors.white;
          });
        }
      },
    );
  }

  cupertinoDatePickerBuilder(BuildContext ctx) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (picked) {
            setState(
              () {
                dateButtonText = DateFormat.yMMMd().format(picked);
                _selectedDate = picked;
                dateButtonTextColor = Colors.white;
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    questionCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjectsProvider =
        Provider.of<SubjectProvider>(context, listen: false);
    final questionProvider =
        Provider.of<QuestionsProvider>(context, listen: false);

    // to check whether the data provided is valid and if there is an error update the ui accordingly

    bool isValid() {
      bool validity = true;

      if (dropDownButtonValue == null) {
        setState(() {
          subjectDropDownColor = Colors.red.shade800;
        });
        validity = false;
      }
      if (_selectedDate == null) {
        setState(() {
          dateButtonTextColor = Colors.red;
        });
        validity = false;
      }
      if (!_formKey.currentState!.validate()) {
        validity = false;
      }

      return validity;
    }

    // to save the question if it is valid

    void _saveQuestion() {
      bool validity = isValid();
      if (validity) {
        questionProvider.addQuestion(
            int.parse(questionCountController.text),
            subjectsProvider.correspondingItemByName(dropDownButtonValue!).id,
            _selectedDate!);

        Navigator.of(context).pop();
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 30,
        right: 20,
        left: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      borderRadius: BorderRadius.circular(20),
                      icon: Icon(
                        Icons.arrow_downward,
                        color: subjectDropDownColor,
                      ),
                      underline: Container(
                        height: 0,
                      ),
                      alignment: Alignment.center,
                      hint: Text(
                        'Subject',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      items: subjectsProvider.items
                          .map(
                            (subject) => DropdownMenuItem(
                              onTap: () => setState(() {
                                subjectDropDownColor =
                                    Theme.of(context).primaryColor;
                              }),
                              value: subject.name,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(subject.name),
                                  Icon(
                                    subject.icon,
                                    color: subject.color,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownButtonValue = newValue!;
                        });
                      },
                      value: dropDownButtonValue,
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                          controller: questionCountController,
                          keyboardType: TextInputType.number,
                          validator: (countToValidate) {
                            if (countToValidate!.isEmpty ||
                                double.tryParse(countToValidate) == null) {
                              return '';
                            }
                            return null;
                          },
                          decoration: ThemeClass.buildTextField('Count')),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      if (Platform.isAndroid) {
                        materialDatePickerBuilder(context);
                      } else if (Platform.isIOS) {
                        cupertinoDatePickerBuilder(context);
                      }
                    },
                    child: Text(
                      dateButtonText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: dateButtonTextColor),
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => _saveQuestion(),
              child: Text(
                'Add Question',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
