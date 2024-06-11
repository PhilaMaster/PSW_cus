import 'package:flutter/material.dart';

import '../../../model/objects/prenotazioni/sala.dart';


class Prenota extends StatefulWidget {
  const Prenota({super.key});

  @override
  State<Prenota> createState() => _PrenotaState();
}

class _PrenotaState extends State<Prenota> {
  late Future<List<Sala>> futureSale;
  Sala? _salaSelezionata;
  DateTime? dataSelezionata;
  Set<DateTime> _dateSelezionata = {};
  List<DateTime> _dateDisponibili = [];

  @override
  void initState() {
    super.initState();
    futureSale = SalaService.getAllSale();
    _dateDisponibili = getDateDisponibili();
    _dateSelezionata.add(_dateDisponibili[0]);
  }

  void aggiornaDataSelezionata(Set<DateTime> newSelection){
    setState(() {
      _dateSelezionata = newSelection;
      dataSelezionata = newSelection.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova prenotazione'),
        automaticallyImplyLeading: false,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
          children: [
            const Text("Seleziona la sala:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            FutureBuilder(
                future: futureSale,
                builder: (context,snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Errore nel caricamento delle sale'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nessuna sala disponibile'));
                  } else {
                    List<Sala> sale = snapshot.data!;
                    return DropdownButton<Sala>(
                      hint: const Text("Seleziona una sala"),
                      value: _salaSelezionata,
                      onChanged: (Sala? newValue) {
                        setState(() {
                          _salaSelezionata = newValue!;
                        });
                      },
                      items: sale.map<DropdownMenuItem<Sala>>((Sala sala) {
                        return DropdownMenuItem<Sala>(
                          value: sala,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(sala.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 20,),
                              Text(sala.indirizzo),
                              const SizedBox(width: 20,),
                              Text("Capienza [${sala.capienza.toString()}]")
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                }
            ),
            const SizedBox(height: 60),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Seleziona il giorno della prenotazione", style: TextStyle(fontSize: 18)),
                Tooltip(
                  message: "è possibile prenotare fino a un massimo di due giornate lavorative successiva alla data odierna (sabato e domenica la palestra è chiusa)",
                  child: Icon(Icons.help_outline)
                )
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child:
              SegmentedButton(
                  segments: _dateDisponibili.map((data) {
                    return ButtonSegment(value: data, label: Text(estraiData(data)));
                  }).toList(),
                  selected: _dateSelezionata,
                  onSelectionChanged: aggiornaDataSelezionata,
              )
            ),
            const SizedBox(height: 60),
            const Text("Seleziona la fascia oraria desiderata:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Placeholder()
            //TODO aggiungere un altro segmented tutto disabilitato all'inizio, dopo aver selezionato sala e data mostra tutte le fasce,
            //se piena rossa, gialla se meno di metà posti, verde se più di metà posti,
            //effettuare richieste localhost:8080/api/sale/2/postiOccupati?fasciaOraria=DIECI_DODICI&data=2024-06-06 per vedere i posti disponibili

          ],
        )
      )


    );
  }

  String estraiData(DateTime data) => data.toIso8601String().split('T')[0];

  getDateDisponibili() {//è possibile prenotare per il giorno stesso o per i successivi due tranne sabato e domenica(palestra chiusa)
    List<DateTime> ret = [];
    DateTime now = DateTime.now();
    // ret.add(now);
    // return ret;
    int i=0;
    while (ret.length < 3) {
      DateTime data = now.add(Duration(days: i++));
      if (data.weekday != DateTime.saturday && data.weekday != DateTime.sunday) {
        ret.add(data);
      }
    }

    return ret;
  }
}
