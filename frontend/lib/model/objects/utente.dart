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
    'sesso':sesso.toString()//TODO dovrebbe andare poichè le ho scritte in maiuscolo ma è comunque da testare
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
}