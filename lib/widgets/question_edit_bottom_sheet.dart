// dart utility
import 'dart:io';

// packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/question_provider.dart';
// theme
import '../theme/themeClass.dart';

import '';

class QuestionEditBottomSheet extends StatefulWidget {
  final QuestionItem question;
  final int count;
  final DateTime originalDate;
  QuestionEditBottomSheet({
    required this.question,
    required this.count,
    required this.originalDate,
  });

  @override
  _QuestionEditBottomSheetState createState() =>
      _QuestionEditBottomSheetState();
}

class _QuestionEditBottomSheetState extends State<QuestionEditBottomSheet> {
  // form key to manipulate data

  GlobalKey<FormState> _formKey = GlobalKey();

  // date button text which will be the original date
  String? dateButtonText;
  // a datetime object to able to initialize from the original one and update the ui and question accordingly
  DateTime? _selectedDate;

  // to be able to fetch data from the text field
  TextEditingController? newCountController;
  @override
  void initState() {
    super.initState();

    newCountController = TextEditingController(text: widget.count.toString());
    dateButtonText = DateFormat.yMMMd().format(widget.originalDate);
    _selectedDate = widget.originalDate;
  }

  materialDatePickerBuilder(BuildContext ctx) {
    showDatePicker(
        context: ctx,
        initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
        firstDate: DateTime.now().subtract(
          const Duration(days: 365),
        ),
        lastDate: DateTime.now(),
        builder: (ctx, child) {
          return Theme(
            data: ThemeClass.datePickerTheme,
            child: child!,
          );
        }).then(
      (_pickedDate) {
        if (_pickedDate != null) {
          setState(() {
            dateButtonText = DateFormat.yMMMd().format(_pickedDate);
            _selectedDate = _pickedDate;
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
                },
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final questionsProvider = Provider.of<QuestionsProvider>(context);

    _saveFrom() {
      if (_formKey.currentState!.validate()) {
        questionsProvider.updateQuestion(widget.question,
            int.parse(newCountController!.text), _selectedDate!);
        Navigator.of(context).pop();
      }
    }

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          right: 10,
          left: 10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (countToValidate) {
                if (countToValidate!.isEmpty ||
                    double.tryParse(countToValidate) == null) {
                  return 'Please provide a valid value';
                }
                return null;
              },
              controller: newCountController,
              decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red.shade800),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.red.shade800),
                ),
                // style of the place holder
                hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2!.color),
                // the border that shows up when the modal bottom sheet is opened even if the user didn't press on it
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(10),
                hintText: 'Count',
                // border when the text field is being used
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
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
                  dateButtonText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () => _saveFrom(),
                child: Text(
                  'Submit Changes',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
