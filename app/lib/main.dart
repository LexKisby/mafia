import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Mafia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme(
            background: Colors.purple,
            primary: Colors.amber,
            primaryVariant: Colors.amber,
            onBackground: Colors.grey,
            onError: Colors.white,
            onPrimary: Colors.grey,
            onSecondary: Colors.grey,
            onSurface: Colors.amber,
            secondary: Colors.amber,
            secondaryVariant: Colors.amber,
            surface: Colors.blueGrey,
            brightness: Brightness.light,
            error: Colors.red,
          ),
          primarySwatch: Colors.amber,
          textTheme: TextTheme(
                  bodyText1: TextStyle(color: Colors.grey),
                  bodyText2: TextStyle(color: Colors.grey))
              .apply(bodyColor: Colors.grey, displayColor: Colors.grey),
        ),
        home: RoomFinder(),
      ),
    );
  }
}














