import 'package:flutter/material.dart';

import '../../widgets/app_bar.dart';

class mieiOrdini extends StatelessWidget {
  const mieiOrdini({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(onBackFromSuccessivePage: null,),
      body: Center(
        child: Text('Questa è la pagina degli ordini.'),
      ),
    );
  }
}