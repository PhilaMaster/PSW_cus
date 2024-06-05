import 'package:flutter/material.dart';

import '../../widgets/app_bar.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Text('Questa è la pagina Shop.'),
      ),
    );
  }
}