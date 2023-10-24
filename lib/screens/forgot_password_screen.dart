import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_counter/providers/auth_provider.dart';

import '../theme/themeClass.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;
  String userEmail = '';

  void sendEmail() {
    bool validity = _formKey.currentState!.validate();
    if (validity) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      print(userEmail);

      Provider.of<AuthProvider>(context, listen: false)
          .resetPass(context, userEmail)
          .then(
        (_) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: !isLoading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 150,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Forgot Password',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Provide your email and we will send you a link to reset your password',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onSaved: (newEmail) {
                            userEmail = newEmail!;
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          validator: (emailToValidate) {
                            if (emailToValidate!.isEmpty ||
                                !emailToValidate.contains('@')) {
                              return 'invalid email please enter a correct one';
                            }
                            return null;
                          },
                          decoration: ThemeClass.buildTextField('Email'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () => sendEmail(),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  )
                ],
              )
            : Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
