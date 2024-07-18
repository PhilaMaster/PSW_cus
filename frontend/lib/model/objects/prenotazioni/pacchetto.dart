import 'dart:convert';

import 'package:http/http.dart' as http;

class Pacchetto{
  final int ingressi;
  final double prezzoUnitario;

  Pacchetto({required this.ingressi, required this.prezzoUnitario});

  factory Pacchetto.fromJson(Map<String, dynamic> json) {
    return Pacchetto(
      ingressi: json['ingressi'],
      prezzoUnitario: json['prezzoUnitario'],
    );
  }

  Map<String, dynamic> toJson() => {
    'ingressi': ingressi,
    'prezzoUnitario': prezzoUnitario,
  };

  @override
  String toString() {
    return "Pacchetto, ingressi: $ingressi, prezzo: ${prezzoUnitario*ingressi}";
  }
}

class PacchettoService {
  static const String baseUrl = 'http://localhost:8080/api/pacchetti';

  static Future<List<Pacchetto>> getAllPacchetti() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((pacchetto) => Pacchetto.fromJson(pacchetto)).toList();
    } else {
      throw Exception('Impossibile caricare i pacchetti');
    }
  }

  static Future<Pacchetto> getPacchettoByIngressi(int ingressi) async {
    final response = await http.get(Uri.parse('$baseUrl/$ingressi'));

    if (response.statusCode == 200) {
      return Pacchetto.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404){
      throw Exception('Pacchetto non trovato');
    } else{
      throw Exception('Impossibile ottenere il pacchetto');
    }
  }

  static Future<List<Pacchetto>> getPacchettiByPriceRange(double min, double max) async {
    final response = await http.get(Uri.parse('$baseUrl/priceSearch?min=$min&max=$max'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((pacchetto) => Pacchetto.fromJson(pacchetto)).toList();
    } else{
      throw Exception('Impossibile ottenere i pacchetti');
    }
  }

  static Future<Pacchetto> createPacchetto(Pacchetto pacchetto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(pacchetto.toJson()),
    );

    if (response.statusCode == 201) {
      return Pacchetto.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400){
      throw Exception('Pacchetto già esistente');
    } else {
      throw Exception('Impossibile creare il pacchetto');
    }
  }

  static Future<void> updatePacchetto(int ingressi, Pacchetto p) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$ingressi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(p.toJson()),
    );

    if (response.statusCode == 404) {
      throw Exception('Impossibile trovare il pacchetto');
    } else if (response.statusCode!=200) {
      throw Exception('Errore generico');
    }
  }

  static Future<void> deletePacchetto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 404) {
      throw Exception('Impossibile trovare il pacchetto');
    } else if (response.statusCode!=200) {
      throw Exception('Errore generico');
    }
  }

  // Future<double> applyDiscount(int id, double discountPercentage) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/$id/discount'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: json.encode({'discountPercentage': discountPercentage}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Impossibile applicare lo sconto');
  //   }
  // }
}