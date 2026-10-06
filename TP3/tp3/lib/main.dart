import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'DiceGame'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int diceNumberL = 1;
  int diceNumberR = 1;
  int remainingThrows = 10;
  int player1Score = 0;
  int player2Score = 0;

  int randomBetween(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }

  void _swapDice() {
    if (remainingThrows <= 0) return;
    setState(() {
      diceNumberL = randomBetween(1, 6);
      diceNumberR = randomBetween(1, 6);
      if (remainingThrows % 2 == 0) {
        player1Score += diceNumberL + diceNumberR;
      } else {
        player2Score += diceNumberL + diceNumberR;
      }
      remainingThrows--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset('assets/images/logo.png', height: 36),
          ),
        ],
      ),
      body: Center(
        child: Column(
          spacing: 100,
          mainAxisAlignment: .center,
          children: [
            const Text('Click the dice !', style: TextStyle(fontSize: 30)),
            Text(
              'Remaining Throws : $remainingThrows',
              style: TextStyle(fontSize: 30),
            ),
            Row(
              mainAxisAlignment: .center,
              spacing: 100,
              children: [
                GestureDetector(
                  onTap: _swapDice,
                  child: Image.asset('assets/images/de$diceNumberL.png'),
                ),
                GestureDetector(
                  onTap: _swapDice,
                  child: Image.asset('assets/images/de$diceNumberR.png'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: .center,
              spacing: 100,
              children: [
                Text(
                  'Player 1 Score : $player1Score',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  'Player 2 Score : $player2Score',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
