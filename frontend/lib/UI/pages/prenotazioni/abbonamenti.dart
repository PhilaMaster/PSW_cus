import 'package:flutter/material.dart';
import 'package:frontend/model/objects/prenotazioni/abbonamento.dart';
import 'package:frontend/model/objects/prenotazioni/pacchetto.dart';

import '../../../model/objects/utente.dart';

class Abbonamenti extends StatefulWidget {
  const Abbonamenti({super.key});

  @override
  State<Abbonamenti> createState() => _AbbonamentiState();
}

class _AbbonamentiState extends State<Abbonamenti> {
  late Future<List<Pacchetto>> futurePacchetti;
  late Future<List<Abbonamento>> futureAbbonamenti;
  Utente utenteLoggato = Utente(id:1,nome:"Pasquale",cognome: "Papalia",sesso:Sesso.MASCHIO);//esempio finchè non facciamo il login

  @override
  void initState() {
    super.initState();
    futurePacchetti = PacchettoService().getAllPacchetti();
    futureAbbonamenti = AbbonamentoService().getAbbonamentiByUtenteWithPositiveRimanenti(utenteLoggato.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abbonamenti'),
        automaticallyImplyLeading: false,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child:Column(
          children: [
            Text(
              '${utenteLoggato.nome}, in questa pagina puoi trovare i pacchetti disponibili e gli abbonamenti che hai sottoscritto',
              style: const TextStyle(fontSize: 18),
                ),
              const SizedBox(height: 16),
              const Text(
                'Pacchetti disponibili:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            Expanded(//TODO aggiungere scrollbar
              child: FutureBuilder<List<Pacchetto>>(
                future: futurePacchetti,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Errore nel caricamento dei pacchetti'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nessun pacchetto disponibile'));
                  } else {
                    final listaPacchetti = snapshot.data!;
                    return ListView.builder(
                      itemCount: listaPacchetti.length,
                      itemBuilder: (context, index) {
                        final pacchetto = listaPacchetti[index];
                        return ListTile(
                          title: Text('${pacchetto.ingressi} ingressi'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Prezzo unitario: ${pacchetto.prezzoUnitario} €'),
                              Text('Prezzo complessivo: ${pacchetto.prezzoUnitario*pacchetto.ingressi} €'),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Logica per acquistare il pacchetto
                            },
                            child: const Text('Acquista'),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Abbonamenti sottoscritti:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Expanded(//TODO aggiungere scrollbar
              child: FutureBuilder<List<Abbonamento>>(
                future: futureAbbonamenti,
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Errore nel caricamento degli abbonamenti ${snapshot.error} (debug)'));//TODO debug
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Non hai sottoscritto alcun abbonamento'));
                  } else {
                    final abbonamenti = snapshot.data!;
                    return ListView.builder(
                      itemCount: abbonamenti.length,
                      itemBuilder: (context, index) {
                        final abbonamento = abbonamenti[index];
                        return ListTile(
                          title: Text('Abbonamento ${index+1}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pacchetto con ${abbonamento.rimanenti}/${abbonamento.pacchetto.ingressi} ingressi'),
                              Text('Data acquisto: ${abbonamento.dataAcquisto.toString().split(' ')[0]}'),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),


            ),
          ],
        ),
      )
    );
  }

  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     body:Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child:Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             '${utenteLoggato.nome}, in questa pagina puoi trovare i pacchetti disponibili e gli abbonamenti che hai sottoscritto',
  //             style: const TextStyle(fontSize: 24),
  //           ),
  //           const SizedBox(height: 16),
  //           const Text(
  //             'Pacchetti disponibili:',
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  //           ),
  //           FutureBuilder<List<Pacchetto>>(
  //             future: futurePackages,
  //             builder: (context, snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const CircularProgressIndicator();
  //               } else if (snapshot.hasError) {
  //                 return Text('Errore: ${snapshot.error}');
  //               } else if (snapshot.hasData) {
  //                 return SizedBox(
  //                     height: 600,
  //                     width: MediaQuery.of(context).size.width,//allarga quanto lo schermo
  //                     child:
  //                     Expanded(
  //                         child: SingleChildScrollView(
  //                             scrollDirection: Axis.vertical,
  //                             child:
  //                             DataTable(
  //                               columns: const [
  //                                 DataColumn(label: Text('Numero ingressi')),
  //                                 DataColumn(label: Text('Prezzo unitario')),
  //                                 DataColumn(label: Text('Prezzo complessivo')),
  //                                 // DataColumn(label: Text('Acquista')),
  //                               ],
  //                               rows: snapshot.data!.map((pacchetto) {
  //                                 return DataRow(cells: [
  //                                   DataCell(Text(pacchetto.ingressi.toString())),
  //                                   DataCell(Text(pacchetto.prezzoUnitario.toString())),
  //                                   DataCell(Text((pacchetto.prezzoUnitario*pacchetto.ingressi).toString())),
  //                                   // DataCell(MaterialButton(onPressed: () {  },))
  //                                 ]);
  //                               }).toList(),
  //                             )
  //
  //                         )
  //                     )
  //                 );
  //               } else {
  //                 return const Text('Nessun pacchetto disponibile');
  //               }
  //             },
  //           ),
  //         ],
  //       )
  //     )
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // appBar: MyAppBar(),
  //     body: Center(
  //       child: FutureBuilder<List<Pacchetto>>(
  //         future: futurePackages,
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return CircularProgressIndicator();
  //           } else if (snapshot.hasError) {
  //             return Text('Errore: ${snapshot.error}');
  //           } else if (snapshot.hasData) {
  //             return ListView.builder(
  //               itemCount: snapshot.data!.length,
  //               itemBuilder: (context, index) {
  //                 final p = snapshot.data![index];
  //                 return ListTile(
  //                   title: Text('Ingressi: ${p.ingressi}'),
  //                   subtitle: Text('Prezzo per ingresso: ${p.prezzoUnitario} €'),
  //                 );
  //               },
  //             );
  //           } else {
  //             return Text('Nessun pacchetto disponibile');
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }
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