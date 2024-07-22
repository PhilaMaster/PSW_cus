import 'package:flutter/material.dart';
import 'package:frontend/UI/widgets/ingressi_widget.dart';
import 'package:frontend/UI/widgets/app_bar.dart';
import 'package:frontend/model/objects/authenticator.dart';

import '../../model/objects/prenotazioni/prenotazione.dart';
import '../../model/objects/utente.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Prenotazione>> futurePrenotazioni;
  Utente user = Utente(id:-1,nome:"guest",cognome: "guest",sesso:Sesso.MASCHIO);//esempio finchè non facciamo il login
  bool mostraPrenotazioniPassate = false;
  // String username = "guest";

  @override
  void initState() {
    super.initState();

    if(isLoggedIn){
      user = utenteLoggato!;
    }
    futurePrenotazioni = PrenotazioneService.getPrenotazioniFutureUtente();
  }
  void togglePrenotazioni() {
    setState(() {
      mostraPrenotazioniPassate = !mostraPrenotazioniPassate;
      futurePrenotazioni = !mostraPrenotazioniPassate
          ? PrenotazioneService.getPrenotazioniFutureUtente()
          : PrenotazioneService.getPrenotazioniUtente();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(onBackFromSuccessivePage: (){
        //codice da eseguire quando da un'altra pagina torno indietro alla home
        setState(() {
          //aggiorno le prenotazioni future
          futurePrenotazioni = PrenotazioneService.getPrenotazioniFutureUtente();
          //aggiorno gli ingressi (non è richiesta l'esecuzione di altro codice ma basta il setState() stesso)
        });
      }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benvenuto, ${user.nome}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder(future: UtenteService.getIngressi(user.id),
                builder: (context,snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    String errorMessage;
                    if (user.id == -1){
                      errorMessage = "Effettua il login per visualizzare il numero di ingressi rimanenti!";
                    }else if(snapshot.error.toString().contains('Utente non trovato')) {
                      errorMessage = 'Utente non trovato';
                    } else {
                      errorMessage = 'C\'è stato un errore nel caricamento degli ingressi';
                    }
                    return Text(errorMessage);
                  } else if (snapshot.hasData) {
                    final int ingressi = snapshot.data!;
                    return Ingressiwidget(ingressi);
                  } else {
                    return const SizedBox(height: 16); //gestisce il caso in cui non ci siano dati
                  }
                }
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Ecco le tue prenotazioni:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Prenotazione>>(
              future: futurePrenotazioni,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  String errorMessage;
                  if (user.id == -1){
                    errorMessage = "Effettua il login per visualizzare le prenotazioni!";
                  }else if(snapshot.error.toString().contains('Utente non trovato')) {
                    errorMessage = 'Utente non trovato';
                  } else {
                    errorMessage = 'Errore nel caricamento delle prenotazioni.';
                  }
                  return Center(child: Text(errorMessage));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nessuna prenotazione trovata.'));
                } else {

                  return SizedBox(
                    height: 600,
                    width: MediaQuery.of(context).size.width,//allarga quanto lo schermo
                    child:
                      // Expanded(
                      //   child:
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child:
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Sala')),
                            DataColumn(label: Text('Data')),
                            DataColumn(label: Text('Fascia Oraria')),
                          ],
                          rows: snapshot.data!.map((prenotazione) {
                            return DataRow(cells: [
                              DataCell(Text(prenotazione.sala.toString())),
                              DataCell(Text(prenotazione.data.toString().split(" ")[0])),
                              DataCell(Text(prenotazione.fasciaOraria.orario)),
                            ]);
                          }).toList(),
                        )

                      )
                      // )

                  );

                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Mostra anche prenotazioni passate"),
                Switch(
                  value: mostraPrenotazioniPassate,
                  onChanged: (value) {
                    togglePrenotazioni();
                  },
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}


