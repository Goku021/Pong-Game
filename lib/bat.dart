import 'package:flutter/material.dart';

class Bat extends StatelessWidget{
  final double height;
  final double width;
  Bat(this.height, this.width);
  @override
  Widget build(BuildContext context){
    return Container(
      height: height,
      width: width,
      decoration:const BoxDecoration(
        color: Colors.red,
      ),
    );
  }

}