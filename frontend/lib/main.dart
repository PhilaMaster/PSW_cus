import 'package:flutter/material.dart';

import 'UI/pages/home.dart';
import 'UI/pages/prenotazioni/abbonamenti.dart';
import 'UI/pages/prenotazioni/prenota.dart';
import 'UI/pages/shop/shop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cus cosenza',
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.dark,
        ),
      home: const HomePage(),
      routes: {
        '/abbonamenti': (context) => const Abbonamenti(),
        '/prenota': (context) => const Prenota(),
        '/shop': (context) => const Shop(),
      },
    );
  }
}