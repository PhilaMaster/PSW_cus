import 'dart:convert';

import 'package:http/http.dart' as http;

class Sala{
  final int id,capienza;
  final String nome,indirizzo;

  Sala({required this.id, required this.nome, required this.capienza, required this.indirizzo});

  factory Sala.fromJson(Map<String, dynamic> json) {
    return Sala(
      id: json['id'],
      nome: json['nome'],
      indirizzo: json['indirizzo'],
      capienza: json['capienza']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'indirizzo': indirizzo,
    'capienza': capienza
  };

  @override
  String toString() {
    return "Sala: $nome, in $indirizzo con capienza $capienza";
  }
}

class SalaService{
  static const String baseUrl = 'http://localhost:8080/api/sale';

  static Future<List<Sala>> getAllSale() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((sala) => Sala.fromJson(sala)).toList();
    } else {
      throw Exception('Impossibile caricare le sale');
    }
  }

  static Future<Sala> getSalaById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Sala.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404){
      throw Exception('Sala non trovata');
    } else{
      throw Exception('Impossibile ottenere la sala');
    }
  }

  static Future<Sala> createSala(Sala sala) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(sala.toJson()),
    );

    if (response.statusCode == 201) {
      return Sala.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400){
      throw Exception('Sala già esistente');
    } else {
      throw Exception('Impossibile creare la sala');
    }
  }

  static Future<void> updateSala(int id, Sala s) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(s.toJson()),
    );

    if (response.statusCode == 404) {
      throw Exception('Impossibile trovare la sala');
    } else if (response.statusCode!=200) {
      throw Exception('Errore generico');
    }
  }

  static Future<void> deleteSala(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 404) {
      throw Exception('Impossibile trovare la sala');
    } else if (response.statusCode!=200) {
      throw Exception('Errore generico');
    }
  }
}