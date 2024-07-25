// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'authenticator.dart';


class Utente{
  final int id;
  final String nome, cognome;
  final Sesso sesso;
  Utente({required this.id, required this.nome, required this.cognome, required this.sesso});


  factory Utente.fromJson(Map<String, dynamic> json) {
    return Utente(
      id: json['id'],
      nome: json['nome'],
      cognome: json['cognome'],
      sesso: SessoExtension.fromString(json['sesso'])
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'cognome':cognome,
    'sesso':sesso.toShortString()
  };

  @override
  String toString() {
    return "$nome $cognome, $sesso.";
  }
}

enum Sesso{MASCHIO,FEMMINA,ALTRO}

extension SessoExtension on Sesso {
  static Sesso fromString(String s) {
    switch (s) {
      case 'MASCHIO':
        return Sesso.MASCHIO;
      case 'FEMMINA':
        return Sesso.FEMMINA;
      case 'ALTRO':
        return Sesso.ALTRO;
      default:
        throw Exception('Sesso non valido: $s');
    }
  }

  String toShortString() {
    return toString().split('.').last;
  }
}

class UtenteService{
  static const String _baseUrl = 'http://localhost:8080/api/utenti';

  static Future<int> getIngressi() async{
    final response = await http.get(Uri.parse('$_baseUrl/ingressi'),headers: {'Authorization': 'Bearer ${Authenticator().getToken()}'});

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Utente non trovato');
    }else {
      throw Exception('Impossibile richiedere num ingressi rimanenti');
    }
  }

  static Future<Utente> getUtente() async{
    final response = await http.get(Uri.parse(_baseUrl),headers: {'Authorization': 'Bearer ${Authenticator().getToken()}'});

    if (response.statusCode == 200) {
      return Utente.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Utente non trovato');
    } else {
      print(response.body);
      throw Exception('Errore nel caricamento dell\'utente');
    }
  }
}