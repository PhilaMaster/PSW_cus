import 'package:frontend/model/objects/authenticator.dart';

import '../utente.dart';
import 'pacchetto.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Abbonamento{
  final int id;
  final int rimanenti;
  final Pacchetto pacchetto;
  final Utente utente;
  final DateTime dataAcquisto;
  Abbonamento({required this.id, required this.rimanenti, required this.pacchetto, required this.utente, required this.dataAcquisto});

  factory Abbonamento.fromJson(Map<String, dynamic> json) {
    return Abbonamento(
      id: json['id'],
      rimanenti: json['rimanenti'],
      pacchetto: Pacchetto.fromJson(json['pacchetto']),
      utente: Utente.fromJson(json['utente']),
      dataAcquisto: DateTime.parse(json['dataAcquisto']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'rimanenti': rimanenti,
    'pacchetto':pacchetto.toJson(),
    'utente':utente.toJson(),
    'dataAcquisto': dataAcquisto.toIso8601String().split(" ")[0],//TODO testare se funziona. Prendo la prima parte, ovvero solo data senza ora. Nello split va la T?
  };

  @override
  String toString() {
    return "Abbonamento [$id], ingressi rimanenti: $rimanenti"
        "di $utente, "
        "pacchetto $pacchetto";
  }
}


class AbbonamentoService {
  static const String _baseUrl = "http://localhost:8080/api/abbonamenti";


  static Future<List<Abbonamento>> getAllAbbonamenti() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((abbonamento) => Abbonamento.fromJson(abbonamento)).toList();
    } else {
      throw Exception('Impossibile caricare gli abbonamenti');
    }
  }

  static Future<Abbonamento> getAbbonamentoById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode == 200) {
      return Abbonamento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Impossibile caricare l\'abbonamento');
    }
  }

  static Future<Abbonamento> createAbbonamento(Abbonamento abbonamento) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${Authenticator().getToken()}'},
      body: json.encode(abbonamento.toJson()),
    );
    if (response.statusCode == 201) {
      return Abbonamento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Impossibile creare l\'abbonamento ${response.body}');
    }
  }

  static Future<void> deleteAbbonamento(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Impossibile eliminare l\'abbonamento');
    }
  }

  static Future<List<Abbonamento>> getAbbonamentiByUtente() async {
    final response = await http.get(Uri.parse('$_baseUrl/utente/'), headers: {'Authorization': 'Bearer ${Authenticator().getToken()}'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((abbonamento) => Abbonamento.fromJson(abbonamento)).toList();
    }else if (response.statusCode == 401){
      throw Exception('Utente non loggato!');
    }else if (response.statusCode == 404){
      throw Exception('404 - Non trovato');
    }
    else {
      throw Exception('Impossibile caricare gli abbonamenti per l\'utente)');
    }
  }

  static Future<List<Abbonamento>> getAbbonamentiByUtenteWithPositiveRimanenti() async {
    final response = await http.get(Uri.parse('$_baseUrl/utente/coningressi'), headers: {'Authorization': 'Bearer ${Authenticator().getToken()}'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((abbonamento) => Abbonamento.fromJson(abbonamento)).toList();
    }else if (response.statusCode == 401){
      throw Exception('Utente non loggato!');
    }else if (response.statusCode == 404){
      throw Exception('Non trovato');
    } else {
      throw Exception('Impossibile caricare gli abbonamenti con ingressi per l\'utente');
    }
  }
}
