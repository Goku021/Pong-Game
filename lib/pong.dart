import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this package

import 'ball.dart';
import 'bat.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  Direction verticalDirection = Direction.down;
  Direction horizontalDirection = Direction.right;
  double increment = 5;
  AnimationController? animationController;
  double? screenHeight;
  double? screenWidth;
  double ballPosX = 0;
  double ballPosY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  int score = 0;

  void checkBorders() {
    if (ballPosX <= 0 && horizontalDirection == Direction.left) {
      horizontalDirection = Direction.right;
    }
    if (ballPosX >= (screenWidth! - 50) && horizontalDirection == Direction.right) {
      horizontalDirection = Direction.left;
    }
    if (ballPosY >= (screenHeight! - batHeight - 50) && verticalDirection == Direction.down) {
      if (ballPosX >= batPosition && ballPosX <= batPosition + batWidth &&
          ballPosY >= screenHeight! - batHeight - 50 && ballPosY <= screenHeight! - 50) {
        verticalDirection = Direction.up;
        score++;
        if (score % 10 == 0) {
          increment++;
        }
      } else {
        showGameOverDialog();
      }
    }
    if (ballPosY <= 0 && verticalDirection == Direction.up) {
      verticalDirection = Direction.down;
    }
  }

  void showGameOverDialog() {
    animationController?.stop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text("Your score: $score"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text("Restart"),
            ),
            TextButton(
              onPressed: () {
                // Use SystemChannels to ensure compatibility in local environment
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      ballPosX = 0;
      ballPosY = 0;
      increment = 5;
      verticalDirection = Direction.down;
      horizontalDirection = Direction.right;
    });
    animationController?.forward();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 10000),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
        batWidth = screenWidth! / 5;
        batHeight = screenHeight! / 20;

        animationController?.addListener(() {
          if (animationController != null && animationController!.isAnimating) {
            setState(() {
              ballPosX += (horizontalDirection == Direction.right) ? increment : -increment;
              ballPosY += (verticalDirection == Direction.down) ? increment : -increment;
            });
            checkBorders();
          }
        });
        animationController?.forward();
      }
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails update) {
        setState(() {
          batPosition += update.delta.dx;
          if (batPosition < 0) {
            batPosition = 0;
          }
          if (batPosition > screenWidth! - batWidth) {
            batPosition = screenWidth! - batWidth;
          }
        });
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          screenHeight = constraints.maxHeight;
          screenWidth = constraints.maxWidth;
          batWidth = screenWidth! / 5;
          batHeight = screenHeight! / 20;

          return Stack(
            children: [
              Positioned(
                top: ballPosY,
                left: ballPosX,
                child: const Ball(),
              ),
              Positioned(
                width: batWidth,
                height: batHeight,
                bottom: 0,
                left: batPosition,
                child: Bat(batHeight, batWidth),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Text("Score: $score", style: const TextStyle(fontSize: 20)),
              ),
            ],
          );
        },
      ),
    );
  }
}
