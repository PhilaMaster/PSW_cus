import 'package:flutter/material.dart';
import 'package:frontend/UI/widgets/app_bar.dart';

import '../../model/objects/prenotazioni/prenotazione.dart';
import '../../model/objects/prenotazioni/sala.dart';
import '../../model/objects/utente.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Prenotazione>> futurePrenotazioni;
  Utente utenteLoggato = Utente(id:1,nome:"Pasquale",cognome: "Papalia",sesso:Sesso.MASCHIO);//esempio finchè non facciamo il login
  bool mostraPrenotazioniPassate = false;

  @override
  void initState() {
    super.initState();
    futurePrenotazioni = PrenotazioneService.getPrenotazioniFutureUtente(utenteLoggato.id);
  }
  void togglePrenotazioni() {
    setState(() {
      mostraPrenotazioniPassate = !mostraPrenotazioniPassate;
      futurePrenotazioni = !mostraPrenotazioniPassate
          ? PrenotazioneService.getPrenotazioniFutureUtente(utenteLoggato.id) // Sostituisci 1 con l'ID dell'utente reale
          : PrenotazioneService.getPrenotazioniUtente(utenteLoggato.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benvenuto, ${utenteLoggato.nome}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Le tue prenotazioni:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Prenotazione>>(
              future: futurePrenotazioni,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Errore nel caricamento delle prenotazioni. ${snapshot.error}'));//debug
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nessuna prenotazione trovata.'));
                } else {

                  // return Column(
                  //   children: [
                  //     Expanded(
                  //       child: SingleChildScrollView(
                  //         scrollDirection: Axis.vertical,
                  //         child:

                          return DataTable(
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
                          );

                  //       )
                  //     )
                  //   ],
                  // );

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


