import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          child: Text('Prenota', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/shop');
          },
          child: Text('Shop', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}