import 'package:flutter/material.dart';

class Ingressiwidget extends StatelessWidget {
  final int ingressi;

  const Ingressiwidget(this.ingressi, {super.key});



  @override
  Widget build(BuildContext context) {
    IconData iconData;
    String message;
    Color iconColor;

    if (ingressi > 15) {
      iconData = Icons.sentiment_very_satisfied;
      message = 'Buon allenamento!';
      iconColor = Colors.green;
    } else if (ingressi >= 7) {
      iconData = Icons.sentiment_neutral;
      message = 'Ingressi in esaurimento, fai un salto nella sezione "Abbonamenti" per acqusitarli!';
      iconColor = Colors.yellow;
    } else {
      iconData = Icons.sentiment_very_dissatisfied;
      message = 'Acquistane altri nella sezione "Abbonamenti"!';
      iconColor = Colors.red;
    }

    return Row(
      children: [
        Text('Ti restano in totale $ingressi ingressi.', style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 20),
        Icon(
          iconData,
          size: 30,
          color: iconColor,
        ),
        const SizedBox(width: 20),
        Text(
          message,
          style:  const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
