import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 27, 58, 96),
        body: SafeArea(
          // L'espace "affichable" qui ne recouvre pas les zones système (en haut, l'état de la batterie et du réseau, l'heure, etc et en bas, la zone home notamment)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 100.0,
                backgroundImage: AssetImage('images/man_avatar.jpg'),
              ),
              const Text(
                'Albert MICHOU',
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Quelqu\'un d\'important',
                style: TextStyle(
                  //fontFamily: 'Source Sans Pro',
                  color: Colors.blue.shade100,
                  fontSize: 15.0,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 150.0,
                child: Divider(color: Colors.blue.shade100),
              ),
              const SizedBox(
                width: 300,
                child: Text(
                  "personne qui a du pouvoir, de l'influence ou un statut élevé. On dit, il a rencontré quelqu'un d'important lors de cette réunion ou parle-lui avec respect, c'est quelqu'un d'important ici ou encore, dans ce domaine, elle est vraiment quelqu'un d'important.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 50.0,
                width: 150.0,
                child: Divider(color: Colors.blue.shade100),
              ),
              Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25.0,
                ),
                child: ListTile(
                  leading: const Icon(Icons.phone, color: Colors.blue),
                  title: Text(
                    '+33 2 38 41 42 43',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      //fontFamily: 'Source Sans Pro',
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25.0,
                ),
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue),
                  title: Text(
                    'albert.michou@grande-entreprise.fr',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue.shade900,
                      fontFamily: 'Source Sans Pro',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
