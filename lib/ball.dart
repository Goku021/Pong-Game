import 'package:flutter/material.dart';

class Ball extends StatelessWidget{
  const Ball({super.key});
  @override
  Widget build(BuildContext context){
    const double diam = 50;
    return Container(
      width: diam,
      height: diam,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
    );
  }
}