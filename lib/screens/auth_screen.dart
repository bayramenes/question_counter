import 'package:flutter/material.dart';

import '../widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              minRadius: MediaQuery.of(context).size.width * 0.2,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: 80,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            AuthCard(),
          ],
        ),
      ),
    );
  }
}
