import 'package:flutter/material.dart';
import 'package:frontend/model/objects/authenticator.dart';

import '../../../model/objects/prenotazioni/prenotazione.dart';
import '../../../model/objects/prenotazioni/sala.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/textStyles.dart';


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
  List<int> postiOccupatiFasce = [];

  @override
  void initState() {
    super.initState();
    futureSale = SalaService.getAllSale();
    _dateDisponibili = getDateDisponibili();
    _dateSelezionata.add(_dateDisponibili[0]);
    dataSelezionata = _dateDisponibili[0];
    for(int i=0;i<FasciaOraria.values.length;i++) {
      postiOccupatiFasce.add(-1);//di default se non seleziono niente
    }
  }

  void aggiornaDataSelezionata(Set<DateTime> newSelection){
    setState(() {
      _dateSelezionata = newSelection;
      dataSelezionata = newSelection.first;
      aggiornaPostiOccupati();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        onBackFromSuccessivePage: null,
      ),
      body:SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child:
          Column(
            children: [
              Text("Seleziona la sala:", style: MediumTitleStyle()),
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
                            aggiornaPostiOccupati();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Seleziona il giorno della prenotazione", style: MediumTitleStyle()),
                  const Tooltip(
                    message: "è possibile prenotare i prossimi tre giorni lavorativi (sabato e domenica la palestra sarà chiusa)",
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
              Text("Seleziona la fascia oraria desiderata:", style: MediumTitleStyle()),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                child:ListView.builder(
                  shrinkWrap: true,
                  itemCount: FasciaOraria.values.length,
                  itemBuilder: (context, index) {
                    FasciaOraria fascia = FasciaOraria.values[index];
                    int postiOccupati = postiOccupatiFasce[index];
                    int postiTotali = _salaSelezionata?.capienza ?? -1;
                    String testo = "";
                    Color textColor = Colors.red;

                    if(postiOccupati == -1 || postiTotali == -1){
                      testo = "(seleziona prima una sala)";
                    }else{
                      double percentualeOccupata = postiTotali > 0 ? postiOccupati / postiTotali : 0.0;
                      textColor = percentualeOccupata < 0.5
                          ? Colors.green
                          : percentualeOccupata < 1.0
                          ? Colors.yellow
                          : Colors.red;
                      testo = "[$postiOccupati/$postiTotali]";

                      testo += percentualeOccupata < 0.5
                          ? " posti disponibili"
                          : percentualeOccupata < 1.0
                          ? " in esaurimento"
                          : " posti esauriti";
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                        border: Border.all(color: Colors.white), // Colore e spessore del bordo
                        borderRadius: BorderRadius.circular(10.0), // Bordo arrotondato
                        ),
                        child: ListTile(
                          title:Center(
                            child:Text(
                              "Fascia ${index+1}: ${fascia.orario}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              const Text(
                                "Posti occupati: ",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                testo,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],

                          ),
                          onTap: () async {
                            try{
                              if(_salaSelezionata==null){
                                _showErrorDialog(context,"Seleziona prima una sala",null);
                                return;
                              }else if(utenteLoggato==null){
                                _showErrorDialog(context,"Devi prima effettuare il login",() {Navigator.pushNamed(context,"/login");});
                                return;
                              }
                              await PrenotazioneService.createPrenotazione(Prenotazione(id: -1, fasciaOraria: fascia, sala: _salaSelezionata!, utente: utenteLoggato!, data: dataSelezionata!));
                              _showConfirmationDialog(context);
                              setState(() {
                                aggiornaPostiOccupati();
                              });
                            }catch (e) {
                              // Gestione specifica degli errori in base all'eccezione lanciata
                              if (e is Exception) {
                                if (e.toString().contains('Utente non loggato')) {
                                  _showErrorDialog(context,"Effettua il login per effettuare una prenotazione",() {Navigator.pushNamed(context,"/login");});
                                } else if (e.toString().contains('Prenotazione duplicata')) {
                                  _showErrorDialog(context,"Prenotazione già esistente",null);
                                } else if (e.toString().contains('Ingressi insufficienti')) {
                                  _showErrorDialog(context,"Ingressi esauriti, acquistali nella sezione Abbonamenti",null);
                                } else if (e.toString().contains('Sala al completo')) {
                                  _showErrorDialog(context,"Sala al completo",(){setState(() {
                                    aggiornaPostiOccupati();
                                  });});
                                }else {
                                  _showErrorDialog(context,"Impossibile creare la prenotazione",null);
                                }
                              } else {
                                _showErrorDialog(context,"Errore generico",null);
                              }
                            }
                          },
                        ),
                      )

                    );
                  },
                ),
              ),
            ],
          )
        )
      )

    );
  }

  String estraiData(DateTime data) => data.toIso8601String().split('T')[0];

  getDateDisponibili() {//è possibile prenotare per il giorno successivo o per i successivi due tranne sabato e domenica(palestra chiusa)
    List<DateTime> ret = [];
    DateTime now = DateTime.now();
    DateTime data = now.add(const Duration(days: 1));
    int i=0;
    while (ret.length < 3) {
      DateTime data = now.add(Duration(days: i++));
      if (data.weekday != DateTime.saturday && data.weekday != DateTime.sunday) {
        ret.add(data);
      }
    }

    return ret;
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Prenotazione confermata'),
          content: const Text('Buon allenamento!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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

  Future<void> aggiornaPostiOccupati() async {
    if (_salaSelezionata!=null){
      int i = 0;
      for(FasciaOraria f in FasciaOraria.values){
        postiOccupatiFasce[i++] = await SalaService.getPostiOccupati(_salaSelezionata!.id, f, dataSelezionata!);
      }
      setState(() {});//aggiorno la pagina dopo aver preso i dati nuovi dal backend
    }
  }
}

