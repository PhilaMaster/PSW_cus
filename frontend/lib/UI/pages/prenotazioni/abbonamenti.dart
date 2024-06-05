import 'package:flutter/material.dart';
import 'package:frontend/model/objects/prenotazioni/pacchetto.dart';

import '../../widgets/app_bar.dart';

class Abbonamenti extends StatefulWidget {
  @override
  _AbbonamentiState createState() => _AbbonamentiState();
}

class _AbbonamentiState extends State<Abbonamenti> {
  late Future<List<Pacchetto>> futurePackages;

  @override
  void initState() {
    super.initState();
    futurePackages = PacchettoService().getAllPacchetti();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: FutureBuilder<List<Pacchetto>>(
          future: futurePackages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Errore: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final p = snapshot.data![index];
                  return ListTile(
                    title: Text('Ingressi: ${p.ingressi}'),
                    subtitle: Text('Prezzo per ingresso: ${p.prezzoUnitario} €'),
                  );
                },
              );
            } else {
              return Text('Nessun pacchetto disponibile');
            }
          },
        ),
      ),
    );
  }
}

// class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text('Palestra Web'),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.pushNamed(context, '/home');
//           },
//           child: Text('Home', style: TextStyle(color: Colors.white)),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.pushNamed(context, '/abbonamenti');
//           },
//           child: Text('Abbonamenti', style: TextStyle(color: Colors.white)),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.pushNamed(context, '/prenota');
//           },
//           child: Text('Prenota', style: TextStyle(color: Colors.white)),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.pushNamed(context, '/shop');
//           },
//           child: Text('Shop', style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }