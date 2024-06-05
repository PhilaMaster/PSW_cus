import 'package:flutter/material.dart';

import '../../widgets/app_bar.dart';

class Prenota extends StatelessWidget {
  const Prenota({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Text('Questa è la pagina Prenota.'),
      ),
    );
  }
}