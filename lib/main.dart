import 'package:flutter/material.dart';
import 'package:pong_game/pong.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Pong Game",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Pong Game", style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: const SafeArea(
          child: Pong(),
        ),
      ),
    );
  }
}