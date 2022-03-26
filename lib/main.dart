import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newnotes/screens/home_screen.dart';
import 'package:newnotes/screens/login_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // var loggedInUser = FirebaseAuth.loggedInUser;
    return MaterialApp(
      title: 'MyNotes',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      // home: LoginScreen(),
      home: 
        FirebaseAuth.instance.currentUser == null ? LoginScreen() : HomeScreen(),
    );
  }
}
