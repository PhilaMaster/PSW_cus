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
      'fasciaOraria': fasciaOraria.toString(),
      // 'data': data.toIso8601String(),
      'data': data.toIso8601String().split(" ")[0],//TODO testare se funziona. Prendo la prima parte, ovvero solo data senza ora
    };
  }

  @override
  String toString() {
    return "Prenotazione $id, dell'utente $utente, nella sala $sala in data $data, nella fascia oraria $fasciaOraria";
  }
}
// enum FasciaOraria{
//   DIECI_DODICI(orario:"10-12"),
//   DODICI_QUATTORDICI(orario:"12-14"),
//   QUATTORDICI_SEDICI(orario:"14-16"),
//   SEDICI_DICIOTTO(orario:"16-18"),
//   DICIOTTO_VENTI(orario:"18-20"),
//   VENTI_VENTIDUE(orario:"20-22");
//
//   final String orario;
//
//   const FasciaOraria({required this.orario})
//
//   @override
//   String toString() {
//     return orario;
//   }
// }
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
      Uri.parse('$baseUrl/prenotazioni'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(prenotazione.toJson()),
    );

    if (response.statusCode == 201) {
      return 'Prenotazione creata con successo';
    } else if (response.statusCode == 400) {
      return response.body;
    } else {
      throw Exception('Impossibile creare la prenotazione');
    }
  }
}