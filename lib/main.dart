// dart utility

// packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// providers
import './providers/subject_provider.dart';
import 'providers/question_provider.dart';
import './providers/auth_provider.dart';

// screens
import './screens/week_summary_screen.dart';
import './screens/settings_screen.dart';
import './screens/subject_detail_screen.dart';
import './screens/auth_screen.dart';
import './screens/forgot_password_screen.dart';

import './screens/subject_settings_screen.dart';

// theme
import 'theme/themeClass.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SubjectProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => QuestionsProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeClass.darkTheme,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              );
            } else if (snapshot.hasData) {
              return WeekSummaryScreen();
            }
            return AuthScreen();
          },
        ),
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          WeekSummaryScreen.routeName: (ctx) => WeekSummaryScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          SubjectSettingsScreen.routeName: (ctx) => SubjectSettingsScreen(),
          SubjectDetailScreen.routeName: (ctx) => SubjectDetailScreen(),
          ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
        },
      ),
    );
  }
}
