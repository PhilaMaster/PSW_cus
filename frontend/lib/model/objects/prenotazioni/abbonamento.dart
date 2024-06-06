import '../utente.dart';
import 'pacchetto.dart';

class Abbonamento{
  final int id;
  final int rimanenti;
  final Pacchetto pacchetto;
  final Utente utente;
  Abbonamento({required this.id, required this.rimanenti, required this.pacchetto, required this.utente});

  factory Abbonamento.fromJson(Map<String, dynamic> json) {
    return Abbonamento(
      id: json['id'],
      rimanenti: json['rimanenti'],
      pacchetto: Pacchetto.fromJson(json['pacchetto']),
      utente: Utente.fromJson(json['utente']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'rimanenti': rimanenti,
    'pacchetto':pacchetto.toJson(),
    'utente':utente.toJson(),
  };

  @override
  String toString() {
    return "Abbonamento [$id], ingressi rimanenti: $rimanenti"
        "di $utente, "
        "pacchetto $pacchetto";
  }
}
