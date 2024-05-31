import 'package:flutter/material.dart';
import 'package:haj_omrah/constants.dart';
import 'chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
      theme: ThemeData(
          useMaterial3: false,
          appBarTheme: AppBarTheme(backgroundColor: kGreenColor),
          scaffoldBackgroundColor: kWhiteColor),
    );
  }
}
