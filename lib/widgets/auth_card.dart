// pakcages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_counter/screens/forgot_password_screen.dart';

// theme
import '../theme/themeClass.dart';

// providers
import '../providers/auth_provider.dart';

enum userAuthPref {
  register,
  login,
}

class AuthCard extends StatefulWidget {
  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  // focus nodes for the text fields

  FocusNode passwordFocusNode = FocusNode();
  FocusNode verificationPassFocusNode = FocusNode();
  // text editing controller for the password in order to be able to compare with the other password whether they are identical or not
  TextEditingController passController = TextEditingController();
  userAuthPref authState = userAuthPref.login;
  GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> userCreds = {
    "email": '',
    'password': '',
    'verificationPass': ''
  };

  void toggleAuthPref() {
    setState(() {
      authState = authState == userAuthPref.login
          ? userAuthPref.register
          : userAuthPref.login;
    });
  }

  @override
  void dispose() {
    passController.dispose();
    passwordFocusNode.dispose();
    verificationPassFocusNode.dispose();
    super.dispose();
  }

  void authUser() async {
    bool validity = _formKey.currentState!.validate();
    if (validity) {
      _formKey.currentState!.save();
      if (authState == userAuthPref.register) {
        final String dialogContent =
            await Provider.of<AuthProvider>(context, listen: false)
                .registerUser(
          userCreds['email']!,
          userCreds['password']!,
        );
        if (dialogContent.isNotEmpty) {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Authentication Error'),
                    content: Text(dialogContent),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Ok'),
                      ),
                    ],
                  ));
        }
      } else {
        final String dialogContent =
            await Provider.of<AuthProvider>(context, listen: false).singUserIn(
          userCreds['email']!,
          userCreds['password']!,
        );
        if (dialogContent.isNotEmpty) {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Authentication Error'),
                    content: Text(
                      dialogContent,
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Ok'),
                      ),
                    ],
                  ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    onSaved: (newEmail) {
                      userCreds['email'] = newEmail!;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (newPassword) {
                      userCreds['password'] = newPassword!;
                    },
                    focusNode: passwordFocusNode,
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(verificationPassFocusNode),
                    textInputAction: TextInputAction.next,
                    controller: passController,
                    validator: (passToValidate) {
                      if (passToValidate!.length < 6) {
                        return 'please enter a password at least 6 characters long';
                      }
                      return null;
                    },
                    decoration: ThemeClass.buildTextField('Password'),
                    obscureText: true,
                  ),
                  authState == userAuthPref.register
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: true,
                              focusNode: verificationPassFocusNode,
                              textInputAction: TextInputAction.done,
                              validator: (secondPassToValidate) {
                                if (secondPassToValidate !=
                                    passController.text) {
                                  return 'Password do not match !';
                                }
                                return null;
                              },
                              decoration:
                                  ThemeClass.buildTextField('Verify Password'),
                            ),
                          ],
                        )
                      : TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ForgotPasswordScreen.routeName);
                          },
                          child: Text('Forgot Password')),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () => authUser(),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => toggleAuthPref(),
                child: Text(
                    authState == userAuthPref.login ? 'Register' : 'Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
