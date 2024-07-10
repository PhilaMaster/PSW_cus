import 'dart:convert';

import 'package:http/http.dart' as http;

class Prodotto {
  final String nome;
  final double prezzo;
  final String categoria;
  final String descrizione;
  final String sesso;

  Prodotto({
    required this.nome,
    required this.prezzo,
    required this.categoria,
    required this.descrizione,
    required this.sesso,
  });

  factory Prodotto.fromJson(Map<String, dynamic> json) {
    return Prodotto(
      nome: json['nome'],
      prezzo: json['prezzo'],
      categoria: json['categoria'],
      descrizione: json['descrizione'],
      sesso: json['sesso'],
    );
  }

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'prezzo': prezzo,
    'categoria': categoria,
    'descrizione': descrizione,
    'sesso': sesso,
  };

  @override
  String toString() {
    return "Prodotto(nome: $nome, prezzo: $prezzo, categoria: $categoria, descrizione: $descrizione)";
  }
}

class ProdottoService {
  final String baseUrl = 'http://localhost:8080/api/prodotti';

  Future<List<Prodotto>> getAllProdotti() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((prodotto) => Prodotto.fromJson(prodotto)).toList();
    } else {
      throw Exception('Impossibile caricare i prodotti');
    }
  }

  Future<Prodotto> getProdottoById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Prodotto.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Prodotto non trovato');
    } else {
      throw Exception('Impossibile ottenere il prodotto');
    }
  }

  Future<List<Prodotto>> getProdottiByNome(String nome) async {
    final response = await http.get(Uri.parse('$baseUrl/nome/$nome'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((prodotto) => Prodotto.fromJson(prodotto)).toList();
    } else {
      throw Exception('Impossibile ottenere i prodotti');
    }
  }

  Future<List<Prodotto>> getProdottiByPrezzoRange(double min, double max) async {
    final response = await http.get(Uri.parse('$baseUrl/priceSearch?min=$min&max=$max'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((prodotto) => Prodotto.fromJson(prodotto)).toList();
    } else {
      throw Exception('Impossibile ottenere i prodotti');
    }
  }

  Future<List<Prodotto>> getProdottiByNomeAndPrezzoAndCategoriaAndSesso({
    required String nome,
    double? prezzo,
    String? categoria,
    String? sesso,
  }) async {
    String url = '$baseUrl/search';
    Map<String, dynamic> queryParams = {
      'nome': nome,
    };

    if (prezzo != null) {
      queryParams['prezzo'] = prezzo.toString();
    }
    if (categoria != null) {
      queryParams['categoria'] = categoria;
    }
    if (sesso != null) {
      queryParams['sesso'] = sesso;
    }

    String queryString = Uri(queryParameters: queryParams).query;
    url += '?' + queryString;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((prodotto) => Prodotto.fromJson(prodotto)).toList();
    } else {
      throw Exception('Impossibile ottenere i prodotti');
    }
  }

  Future<Prodotto> createProdotto(Prodotto prodotto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(prodotto.toJson()),
    );

    if (response.statusCode == 201) {
      return Prodotto.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception('Prodotto già esistente');
    } else {
      throw Exception('Impossibile creare il prodotto');
    }
  }

  Future<void> updateProdotto(int id, Prodotto prodotto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(prodotto.toJson()),
    );

    if (response.statusCode == 404) {
      throw Exception('Impossibile trovare il prodotto');
    } else if (response.statusCode != 200) {
      throw Exception('Errore generico');
    }
  }

  Future<void> deleteProdotto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 404) {
      throw Exception('Impossibile trovare il prodotto');
    } else if (response.statusCode != 200) {
      throw Exception('Errore generico');
    }
  }
}
