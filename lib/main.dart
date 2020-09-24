import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
  void main()  async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MaterialApp(debugShowCheckedModeBanner: false,home: HomePage()));
  }


class myData{
  int score;
  myData(this.score);
}