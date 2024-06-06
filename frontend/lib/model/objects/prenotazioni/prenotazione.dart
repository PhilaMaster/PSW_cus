import 'package:frontend/model/objects/prenotazioni/sala.dart';

import '../utente.dart';


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
      'data': data.toIso8601String(),
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
        return '10-12';
      case FasciaOraria.DODICI_QUATTORDICI:
        return '12-14';
      case FasciaOraria.QUATTORDICI_SEDICI:
        return '14-16';
      case FasciaOraria.SEDICI_DICIOTTO:
        return '16-18';
      case FasciaOraria.DICIOTTO_VENTI:
        return '18-20';
      case FasciaOraria.VENTI_VENTIDUE:
        return '20-22';
      default:
        return '';
    }
  }

  static FasciaOraria fromString(String orario) {
    switch (orario) {
      case '10-12':
        return FasciaOraria.DIECI_DODICI;
      case '12-14':
        return FasciaOraria.DODICI_QUATTORDICI;
      case '14-16':
        return FasciaOraria.QUATTORDICI_SEDICI;
      case '16-18':
        return FasciaOraria.SEDICI_DICIOTTO;
      case '18-20':
        return FasciaOraria.DICIOTTO_VENTI;
      case '20-22':
        return FasciaOraria.VENTI_VENTIDUE;
      default:
        throw Exception('FasciaOraria non valida: $orario');
    }
  }
}