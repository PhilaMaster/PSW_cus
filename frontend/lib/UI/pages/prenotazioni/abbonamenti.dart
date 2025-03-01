import 'package:flutter/material.dart';
import 'package:frontend/model/objects/authenticator.dart';
import 'package:frontend/model/objects/prenotazioni/abbonamento.dart';
import 'package:frontend/model/objects/prenotazioni/pacchetto.dart';

import '../../../model/objects/utente.dart';
import '../../widgets/app_bar.dart';

class Abbonamenti extends StatefulWidget {
  const Abbonamenti({super.key});

  @override
  State<Abbonamenti> createState() => _AbbonamentiState();
}

class _AbbonamentiState extends State<Abbonamenti> {
  late Future<List<Pacchetto>> futurePacchetti;
  late Future<List<Abbonamento>> futureAbbonamenti;
  Utente uLoggato = Utente(id:-1,nome:"Guest",cognome: "Guest",sesso:Sesso.MASCHIO);

  @override
  void initState() {
    super.initState();
    futurePacchetti = PacchettoService.getAllPacchetti();
    futureAbbonamenti = AbbonamentoService.getAbbonamentiByUtenteWithPositiveRimanenti();
    if(isLoggedIn) {
      uLoggato = utenteLoggato!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        onBackFromSuccessivePage: null,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child:Column(
          children: [
            Text(
              '${uLoggato.nome}, in questa pagina puoi trovare i pacchetti disponibili e gli abbonamenti che hai sottoscritto',
              style: const TextStyle(fontSize: 18),
                ),
              const SizedBox(height: 16),
              const Text(
                'Pacchetti disponibili:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            Expanded(
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
                            onPressed: () async {
                              try {
                                Abbonamento abb = Abbonamento(
                                  id: -1,//lo creo lato backend
                                  rimanenti: pacchetto.ingressi,
                                  pacchetto: pacchetto,
                                  utente: uLoggato,
                                  dataAcquisto: DateTime.now(),
                                );
                                Abbonamento created = await AbbonamentoService.createAbbonamento(abb);
                                if (created.id != -1) {
                                  _showConfirmationDialog(context);
                                  // widget.updateIngressi();
                                }
                              } on UnauthorizedException catch(e){
                                _showErrorDialog(context, "effettua prima il login", () {Navigator.pushNamed(context,"/login");});
                              } catch (error) {
                                print("errore $error");//stampo in console ma la vedo solo io
                                _showErrorDialog(context, "errore generico",null);
                              }},
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
            Expanded(
              child: FutureBuilder<List<Abbonamento>>(
                future: futureAbbonamenti,
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Errore nel caricamento degli abbonamenti.'));
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Acquisto confermato'),
          content: const Text('Il tuo acquisto è stato completato con successo!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  //aggiorno gli abbonamenti visualizzati nella pagina stessa
                  futureAbbonamenti = AbbonamentoService.getAbbonamentiByUtenteWithPositiveRimanenti();
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errore, Function? f) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Errore nella prenotazione'),
          content: Text(errore),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                f?.call();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
