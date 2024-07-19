import 'package:flutter/material.dart';

import '../../widgets/app_bar.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(onBackFromSuccessivePage: null,),
      body: Center(
        child: Text('Questa è il carrello.'),
      ),
    );
  }
}