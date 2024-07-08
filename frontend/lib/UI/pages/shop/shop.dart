import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          const Center(
            child: Text(
              'SHOP',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
            },
            child: const Text('Prezzo'),
          ),
          ElevatedButton(
            onPressed: () {
            },
            child: const Text('Categoria'),
          ),
          ElevatedButton(
            onPressed: () {
            },
            child: const Text('Sesso'),
          ),
          // Add more buttons as needed
        ],
      ),
    );
  }
}
