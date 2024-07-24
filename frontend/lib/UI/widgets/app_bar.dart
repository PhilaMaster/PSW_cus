import 'package:flutter/material.dart';

import '../../model/objects/authenticator.dart';



class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackFromSuccessivePage;
  const MyAppBar({super.key, required this.onBackFromSuccessivePage});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(isLoggedIn? "Cus Cosenza":"Cus Cosenza (sessione Guest)"),
      leading: Navigator.canPop(context)
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      )
          : null,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/abbonamenti').then((_) {onBackFromSuccessivePage?.call();});
          },
          child: const Text('Abbonamenti', style: TextStyle(color: Colors.white)),
        ),
        if (isLoggedIn)
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/prenota').then((_) {onBackFromSuccessivePage?.call();});
            },
            child: const Text('Prenota', style: TextStyle(color: Colors.white)),
          ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/shop');
          },
          child: const Text('Shop', style: TextStyle(color: Colors.white)),
        ),
        if (isLoggedIn)
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/ordini');
            },
            child: const Text('I miei ordini', style: TextStyle(color: Colors.white)),
          ),
        if (isLoggedIn)
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/carrello');
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
          ),
        if (isLoggedIn)
          TextButton(
            onPressed: () {
              Authenticator().logOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          )
        else
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
