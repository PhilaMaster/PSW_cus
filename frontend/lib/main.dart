import 'package:flutter/material.dart';

//import 'UI/pages/shop/carrello.dart';
import 'UI/pages/home.dart';
import 'UI/pages/login_sus.dart';
import 'UI/pages/prenotazioni/abbonamenti.dart';
import 'UI/pages/prenotazioni/prenota.dart';
import 'UI/pages/registrazione.dart';
import 'UI/pages/shop/carrello.dart';
import 'UI/pages/shop/shop.dart';
import 'UI/pages/shop/mieiOrdini.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cus cosenza',
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.dark,
        ),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/abbonamenti': (context) => const Abbonamenti(),
        '/prenota': (context) => const Prenota(),
        '/shop': (context) => const Shop(),
        '/ordini': (context) => const mieiOrdini(),
        '/login': (context) => const LoginSus(),
        '/register': (context) => const RegistrationPage(),
        '/carrello':(context) => const Carrello(),
      },
    );
  }
}