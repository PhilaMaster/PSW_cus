import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/objects/authenticator.dart';
import '../../../model/objects/shop/ordine.dart';
import '../../../model/objects/utente.dart';
import '../../widgets/app_bar.dart';

class OrdiniUtentePage extends StatefulWidget {
  @override
  _OrdiniUtentePageState createState() => _OrdiniUtentePageState();
}

class _OrdiniUtentePageState extends State<OrdiniUtentePage> {
  late Future<List<Ordine>> _ordiniFuture;
  late Utente user;

  @override
  void initState() {
    super.initState();
    if (isLoggedIn) {
      user = utenteLoggato!;
      _ordiniFuture = OrdineService().trovaOrdinePerUtente();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('I Tuoi Ordini'),
      ),
      body: FutureBuilder<List<Ordine>>(
        future: _ordiniFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nessun ordine trovato.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ordine = snapshot.data![index];
                return ListTile(
                  title: Text('Ordine #${ordine.id}'),
                  subtitle: Text('Data: ${ordine.dataCreazione.toString().split(" ")[0]}'),
                  trailing: Text('Totale: ${ordine.prezzoTotale.toStringAsFixed(2)} €'),
                  onTap: () {
                    // Aggiungi logica per navigare ai dettagli dell'ordine, se necessario
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
