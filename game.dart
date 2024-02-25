import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Tech Heads Adventure',
    home: TechHeadsAdventureGame(),
  ));
}

class TechHeadsAdventureGame extends StatefulWidget {
  @override
  _TechHeadsAdventureGameState createState() => _TechHeadsAdventureGameState();
}

class _TechHeadsAdventureGameState extends State<TechHeadsAdventureGame> {
  static const int numEnemies = 5;
  static const double gravity = 0.8;
  static const double jumpStrength = -12.0;

  double playerY = 0;
  double playerDY = 0;
  double playerSize = 50;

  List<double> enemyX = [];
  List<double> enemyY = [];
  double enemySize = 50;

  double castleX = 800;
  double castleY = 400;
  double castleSize = 100;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {
        // Update player's vertical position
        playerDY += gravity;
        playerY += playerDY;

        // Check player collision with ground
        if (playerY >= 400 - playerSize) {
          playerY = 400 - playerSize;
          playerDY = 0;
        }

        // Check player collision with castle
        if (playerY <= castleY + castleSize &&
            playerY >= castleY - playerSize &&
            castleX <= 100) {
          timer.cancel(); // Stop the game
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Congratulations!'),
                content: Text('You won the game!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      startGame(); // Restart the game
                    },
                    child: Text('Play Again'),
                  ),
                ],
              );
            },
          );
        }

        // Update enemies' positions
        for (int i = 0; i < numEnemies; i++) {
          enemyX[i] -= 5;
          if (enemyX[i] <= 0) {
            enemyX[i] = 800;
            enemyY[i] = Random().nextDouble() * (400 - enemySize);
          }

          // Check player collision with enemies
          if (playerY + playerSize >= enemyY[i] &&
              playerY <= enemyY[i] + enemySize &&
              50 >= enemyX[i] &&
              0 <= enemyX[i] + enemySize) {
            timer.cancel(); // Stop the game
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Text('You lost the game!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        startGame(); // Restart the game
                      },
                      child: Text('Play Again'),
                    ),
                  ],
                );
              },
            );
          }
        }
      });
    });

    // Initialize enemies' positions
    for (int i = 0; i < numEnemies; i++) {
      enemyX.add(800 + i * 300);
      enemyY.add(Random().nextDouble() * (400 - enemySize));
    }
  }

  void jump() {
    if (playerY == 400 - playerSize) {
      playerDY = jumpStrength;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tech Heads Adventure'),
      ),
      body: GestureDetector(
        onTap: jump,
        child: Container(
          color: Colors.blue,
          child: Stack(
            children: [
              // Draw player
              Positioned(
                left: 50,
                top: playerY,
                child: Icon(
                  Icons.person,
                  size: playerSize,
                  color: Colors.green,
                ),
              ),
              // Draw enemies
              for (int i = 0; i < numEnemies; i++)
                Positioned(
                  left: enemyX[i],
                  top: enemyY[i],
                  child: Icon(
                    Icons.accessibility,
                    size: enemySize,
                    color: Colors.red,
                  ),
                ),
              // Draw castle
              Positioned(
                left: castleX,
                top: castleY,
                child: Icon(
                  Icons.home,
                  size: castleSize,
                  color: Colors.yellow,
                ),
              ),
              // Draw Ambiora logo on castle
              if (castleX <= 100)
                Positioned(
                  left: castleX + 10,
                  top: castleY + 10,
                  child: Image.asset(
                    'assets/https://tse4.mm.bing.net/th?id=OIP.B1fzbVZf50ANIUDgX1VhmwHaHa&pid=Api&P=0&h=180',
                    width: castleSize - 20,
                    height: castleSize - 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
