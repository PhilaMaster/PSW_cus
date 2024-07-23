import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/objects/authenticator.dart';
import '../../../model/objects/shop/ordine.dart';
import '../../../model/objects/utente.dart';
import '../../widgets/app_bar.dart';

class MieiOrdini extends StatefulWidget {
  const MieiOrdini({super.key});

  @override
  _MieiOrdiniState createState() => _MieiOrdiniState();
}

class _MieiOrdiniState extends State<MieiOrdini> {
  late Future<List<Ordine>> _ordiniFuture;
  DateTimeRange? _selectedDateRange;
  late Utente user;

  @override
  void initState() {
    super.initState();
    if (isLoggedIn) {
      user = utenteLoggato!;
      _ordiniFuture = OrdineService().trovaOrdinePerUtente(user.id);
    } else {
      // Handle the case where the user is not logged in
      _ordiniFuture = Future.value([]);
    }
  }

  Future<void> _filterOrdiniPerData(DateTimeRange dateRange) async {
    final ordiniFiltrati = await OrdineService().filtraPerData(dateRange.start, dateRange.end);
    setState(() {
      _ordiniFuture = Future.value(ordiniFiltrati);
      _selectedDateRange = dateRange;
    });
  }

  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange ?? DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), end: DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDateRange) {
      _filterOrdiniPerData(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(onBackFromSuccessivePage: null,),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          const Center(
            child: Text(
              'I Miei Ordini',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _selectDateRange(context),
                  child: const Text('Filtra per data'),
                ),
                if (_selectedDateRange != null)
                  Text(
                    'Dal ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} al ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: FutureBuilder<List<Ordine>>(
              future: _ordiniFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Errore: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nessun ordine trovato'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final ordine = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ordine #${ordine.id}',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Data: ${DateFormat('dd/MM/yyyy').format(ordine.dataCreazione)}'),
                              Text('Prezzo Totale: \$${ordine.prezzoTotale.toStringAsFixed(2)}'),
                              const SizedBox(height: 10.0),
                              ...ordine.prodotti.map((prodottoCarrello) {
                                return ListTile(
                                  title: Text(prodottoCarrello.prodotto.nome),
                                  subtitle: Text('Quantità: ${prodottoCarrello.quantita}'),
                                  trailing: Text('\$${prodottoCarrello.prodotto.prezzo.toStringAsFixed(2)}'),
                                );
                              }).toList(),
                              const SizedBox(height: 10.0),
                              ElevatedButton(
                                onPressed: () async {
                                  await OrdineService().eliminaOrdine(ordine.id);
                                  setState(() {
                                    _ordiniFuture = OrdineService().trovaOrdinePerUtente(user.id);
                                  });
                                },
                                child: const Text('Elimina Ordine'),
                              ),
                            ],
                          ),
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
    );
  }
}
