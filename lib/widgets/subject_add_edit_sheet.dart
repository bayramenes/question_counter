// packages
import 'package:flutter/material.dart';

import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/subject_provider.dart';

class SubjectAddEditSheet extends StatefulWidget {
  bool isNew;

  SubjectAddEditSheet.newSubject(this.isNew);
  String? id;
  String? originalName;
  Color? originalColor;
  IconData? originalIcon;

  SubjectAddEditSheet.editSubject({
    this.id,
    this.originalName,
    this.originalColor,
    this.originalIcon,
    required this.isNew,
  });
  @override
  State<SubjectAddEditSheet> createState() => _SubjectAddEditSheetState();
}

class _SubjectAddEditSheetState extends State<SubjectAddEditSheet> {
  bool isLoading = false;
  bool isInit = false;
  Map<String, dynamic> initValues = {
    'name': '',
    'icon': Icons.add_a_photo_outlined,
    'color': Colors.white
  };

  @override
  void didChangeDependencies() {
    if (!isInit && !widget.isNew) {
      initValues = {
        'name': widget.originalName,
        'icon': widget.originalIcon,
        'color': widget.originalColor,
      };
      subjectNameController = TextEditingController(
        text: initValues['name'],
      );
      isInit = true;
    }
    super.didChangeDependencies();
  }

  bool shouldChangeColor = false;
  // form global key to maniuplate the form

  GlobalKey<FormState> _formKey = GlobalKey();

  // check validity of the given info

  bool isValid() {
    bool validity = true;
    if (initValues['color'] == Colors.white ||
        initValues['color'] == Color(0xFFFFFFFF)) {
      setState(() {
        shouldChangeColor = true;
      });
      validity = false;
    }
    if (!_formKey.currentState!.validate()) {
      validity = false;
    }

    return validity;
  }
  // a method to show the icon picker in order for the user ot choose an icon

  void startIconPicker(BuildContext ctx) async {
    IconData? icon = await FlutterIconPicker.showIconPicker(ctx,
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        iconColor: Theme.of(ctx).primaryColor);

    if (icon != null) {
      setState(() {
        initValues['icon'] = icon;
      });
    }
  }

  // a method to show the color picker to the user so that they can pick a color to display
  void startColorPicker(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Pick New Subjects Color',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        content: SingleChildScrollView(
            child: ColorPicker(
          pickerColor: initValues['color'],
          onColorChanged: (Color newColor) => setState(
            () {
              initValues['color'] = newColor;
              setState(() {
                shouldChangeColor = false;
              });
            },
          ),
        )),
      ),
    );
  }

  // a controller to get the text the user entered for the subject name
  TextEditingController? subjectNameController;

  @override
  Widget build(BuildContext context) {
    final subjectsProvider =
        Provider.of<SubjectProvider>(context, listen: false);
    // a function to save the new subject if the data is valid
    void _saveForm() async {
      if (isValid()) {
        _formKey.currentState!.save();

        if (widget.isNew) {
          setState(() {
            isLoading = true;
          });
          await subjectsProvider.addSubject(
            color: initValues['color'],
            name: initValues['name'],
            icon: initValues['icon'],
          );
          setState(() {
            isLoading = false;
          });
        } else {
          subjectsProvider.updateSubject(
            id: widget.id!,
            newColor: initValues['color'],
            newName: initValues['name'],
            newIcon: initValues['icon'],
          );
        }
        Navigator.of(context).pop();
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        right: 10,
        left: 10,
      ),
      child: isLoading
          ? const Center(
              heightFactor: 1,
              child: CircularProgressIndicator.adaptive(),
            )
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onSaved: (newName) {
                      initValues['name'] = newName;
                    },
                    validator: (nameToValidate) {
                      if (nameToValidate!.isEmpty ||
                          nameToValidate.length > 15) {
                        return 'please enter a value with no longer than 15 chars';
                      }
                      return null;
                    },
                    controller: subjectNameController,
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
                      hintText: 'Subject',
                      // border when the text field is being used
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Icon : '),
                        Expanded(
                          child: IconButton(
                            onPressed: () => startIconPicker(context),
                            icon: Icon(
                              initValues['icon'],
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Color : '),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => startColorPicker(context),
                                child: CircleAvatar(
                                  backgroundColor: initValues['color'],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (shouldChangeColor)
                          const FittedBox(
                              child: Text(
                            'Choose a color other than the defualt white!!',
                            softWrap: true,
                            style: TextStyle(fontSize: 15, color: Colors.red),
                          ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        _saveForm();
                      },
                      child: Text(
                        widget.isNew ? 'Add Subject' : "Submit Changes",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
