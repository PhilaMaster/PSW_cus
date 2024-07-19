// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:frontend/model/objects/prenotazioni/sala.dart';

import '../authenticator.dart';
import '../utente.dart';
import 'package:http/http.dart' as http;

class Prenotazione{
  final int id;
  final Utente utente;
  final Sala sala;
  final FasciaOraria fasciaOraria;
  final DateTime data;

  Prenotazione({
    required this.id,
    required this.fasciaOraria,
    required this.sala,
    required this.utente,
    required this.data
  });

  factory Prenotazione.fromJson(Map<String, dynamic> json) {
    return Prenotazione(
      id: json['id'],
      utente: Utente.fromJson(json['utente']),
      sala: Sala.fromJson(json['sala']),
      fasciaOraria: FasciaOrariaExtension.fromString(json['fasciaOraria']),
      data: DateTime.parse(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'utente': utente.toJson(),
      'sala': sala.toJson(),
      'fasciaOraria': fasciaOraria.toString().split(".")[1],
      // 'data': data.toIso8601String(),
      'data': data.toIso8601String().split(" ")[0],
    };
  }

  @override
  String toString() {
    return "Prenotazione $id, dell'utente $utente, nella sala $sala in data $data, nella fascia oraria $fasciaOraria";
  }
}

enum FasciaOraria {
  DIECI_DODICI,
  DODICI_QUATTORDICI,
  QUATTORDICI_SEDICI,
  SEDICI_DICIOTTO,
  DICIOTTO_VENTI,
  VENTI_VENTIDUE,
}

extension FasciaOrariaExtension on FasciaOraria {
  String get orario {
    switch (this) {
      case FasciaOraria.DIECI_DODICI:
        return '10:00-12:00';
      case FasciaOraria.DODICI_QUATTORDICI:
        return '12:00-14:00';
      case FasciaOraria.QUATTORDICI_SEDICI:
        return '14:00-16:00';
      case FasciaOraria.SEDICI_DICIOTTO:
        return '16:00-18:00';
      case FasciaOraria.DICIOTTO_VENTI:
        return '18:00-20:00';
      case FasciaOraria.VENTI_VENTIDUE:
        return '20:00-22:00';
      default:
        return 'Orario non valido';
    }
  }

  String get perJson {
    switch (this) {
      case FasciaOraria.DIECI_DODICI:
        return 'DIECI_DODICI';
      case FasciaOraria.DODICI_QUATTORDICI:
        return 'DODICI_QUATTORDICI';
      case FasciaOraria.QUATTORDICI_SEDICI:
        return 'QUATTORDICI_SEDICI';
      case FasciaOraria.SEDICI_DICIOTTO:
        return 'SEDICI_DICIOTTO';
      case FasciaOraria.DICIOTTO_VENTI:
        return 'DICIOTTO_VENTI';
      case FasciaOraria.VENTI_VENTIDUE:
        return 'VENTI_VENTIDUE';
      default:
        return 'Orario non valido';
    }
  }

  static FasciaOraria fromString(String orario) {
    switch (orario) {
      case 'DIECI_DODICI':
        return FasciaOraria.DIECI_DODICI;
      case 'DODICI_QUATTORDICI':
        return FasciaOraria.DODICI_QUATTORDICI;
      case 'QUATTORDICI_SEDICI':
        return FasciaOraria.QUATTORDICI_SEDICI;
      case 'SEDICI_DICIOTTO':
        return FasciaOraria.SEDICI_DICIOTTO;
      case 'DICIOTTO_VENTI':
        return FasciaOraria.DICIOTTO_VENTI;
      case 'VENTI_VENTIDUE':
        return FasciaOraria.VENTI_VENTIDUE;
      default:
        throw Exception('FasciaOraria non valida: $orario');
    }
  }
}

class PrenotazioneService {
  static const String baseUrl = 'http://localhost:8080/api/prenotazioni';

  static Future<List<Prenotazione>> getAllPrenotazioni() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((prenotazione) => Prenotazione.fromJson(prenotazione)).toList();
    } else {
      throw Exception('Impossibile caricare le prenotazioni');
    }
  }

  static Future<List<Prenotazione>> getPrenotazioniFutureUtente(int idUtente) async {
    final response = await http.get(Uri.parse('$baseUrl/utente/future/$idUtente'), headers: {'Authorization': 'Bearer ${Authenticator().getToken()}'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((prenotazione) => Prenotazione.fromJson(prenotazione)).toList();
    } else {
      throw Exception('Impossibile caricare prenotazioni future per l\'utente $idUtente');
    }
  }

  static Future<List<Prenotazione>> getPrenotazioniUtente(int idUtente) async {
    final response = await http.get(Uri.parse('$baseUrl/utente/$idUtente'), headers: {'Authorization': 'Bearer ${Authenticator().getToken()}'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((prenotazione) => Prenotazione.fromJson(prenotazione)).toList();
    } else {
      throw Exception('Impossibile caricare prenotazioni future per l\'utente $idUtente');
    }
  }

  static Future<String> createPrenotazione(Prenotazione prenotazione) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Authenticator().getToken()}'
      },
      body: jsonEncode(prenotazione.toJson()),
    );

    switch (response.statusCode) {
      case 201:
        return 'Prenotazione creata con successo';
      case 400:
        throw Exception(response.body);
      case 401:
        throw Exception('Utente non loggato');
      case 404:
        throw Exception(response.body);
      case 409:
        throw Exception('Prenotazione duplicata');
      case 412:
        throw Exception('Ingressi insufficienti');
      default:
        throw Exception('Impossibile creare la prenotazione');
    }
  }
}