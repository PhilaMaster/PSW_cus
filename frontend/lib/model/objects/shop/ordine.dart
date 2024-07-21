import 'dart:convert';
import 'package:http/http.dart' as http;
import '../authenticator.dart';
import 'cart.dart'; // Importa la classe Cart per i prodotti dell'ordine

class Ordine {
  final int id;
  final DateTime dataCreazione;
  final double prezzoTotale;
  final List<ProdottoCarrello> prodotti;

  Ordine({
    required this.id,
    required this.dataCreazione,
    required this.prezzoTotale,
    required this.prodotti,
  });

  factory Ordine.fromJson(Map<String, dynamic> json) {
    var list = json['prodotti'] as List;
    List<ProdottoCarrello> prodottiList = list.map((i) => ProdottoCarrello.fromJson(i)).toList();

    return Ordine(
      id: json['id'],
      dataCreazione: DateTime.parse(json['dataCreazione']),
      prezzoTotale: json['prezzoTotale'].toDouble(),
      prodotti: prodottiList,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dataCreazione': dataCreazione.toIso8601String(),
    'prezzoTotale': prezzoTotale,
    'prodotti': prodotti.map((item) => item.toJson()).toList(),
  };
}

class OrdineService {
  final String baseUrl = 'http://localhost:8080/api/ordini';

  Future<Ordine> salvaOrdine(Ordine ordine) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(ordine.toJson()),
    );

    if (response.statusCode == 200) {
      return Ordine.fromJson(json.decode(response.body));
    } else {
      throw Exception('Impossibile salvare l\'ordine');
    }
  }

  Future<List<Ordine>> trovaTuttiGliOrdini() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Ordine.fromJson(item)).toList();
    } else {
      throw Exception('Impossibile ottenere gli ordini');
    }
  }

  Future<List<Ordine>> filtraPerData(DateTime inizio, DateTime fine) async {
    final response = await http.get(
      Uri.parse('$baseUrl/data?inizio=${inizio.toIso8601String()}&fine=${fine.toIso8601String()}'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Ordine.fromJson(item)).toList();
    } else {
      throw Exception('Impossibile filtrare gli ordini per data');
    }
  }

  Future<void> eliminaOrdine(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Impossibile eliminare l\'ordine');
    }
  }

  Future<List<Ordine>> trovaOrdinePerUtente(int utenteId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/utente/$utenteId'), // Modifica l'URL secondo necessità
        headers: {
          'Authorization': 'Bearer ${Authenticator().getToken()}'
        }
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Ordine.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Impossibile ottenere gli ordini per l\'utente');
    }
  }
}
