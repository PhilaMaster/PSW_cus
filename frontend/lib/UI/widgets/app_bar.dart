import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Cus cosenza'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/abbonamenti');
          },
          child: const Text('Abbonamenti', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/prenota');
          },
          child: const Text('Prenota', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/shop');
          },
          child: const Text('Shop', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/ordini');
          },
          child: const Text('I miei ordini', style: TextStyle(color: Colors.white)),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/carrello');
          },
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
