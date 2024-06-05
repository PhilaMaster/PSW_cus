import 'package:flutter/material.dart';
import 'package:frontend/UI/widgets/app_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Text('Benvenuti alla nostra palestra!'),
      ),
    );
  }
}