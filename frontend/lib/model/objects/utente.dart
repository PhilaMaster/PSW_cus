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
      sesso: json['sesso']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'cognome':cognome,
    'sesso':sesso
  };

  @override
  String toString() {
    return "$nome $cognome, $sesso.";
  }
}

enum Sesso{maschio,femmina,altro}//TODO controllare se le maiuscole vanno bene, magari usare approccio simile a quello in prenotazione con fasciaoraria se non va