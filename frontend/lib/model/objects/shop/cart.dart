import 'dart:convert';
import 'package:http/http.dart' as http;
import '../authenticator.dart';
import 'ordine.dart';
import 'prodotto.dart';

class ProdottoCarrello {
  final Prodotto prodotto;
  final int quantita;

  ProdottoCarrello({
    required this.prodotto,
    required this.quantita,
  });

  factory ProdottoCarrello.fromJson(Map<String, dynamic> json) {
    return ProdottoCarrello(
      prodotto: Prodotto.fromJson(json['prodotto']),
      quantita: json['quantita'],
    );
  }

  Map<String, dynamic> toJson() => {
    'prodotto': prodotto.toJson(),
    'quantita': quantita,
  };
}

class Cart {
  final List<ProdottoCarrello> prodotti;

  Cart({required this.prodotti});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      prodotti: (json['prodotti'] as List)
          .map((item) => ProdottoCarrello.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'prodotti': prodotti.map((item) => item.toJson()).toList(),
  };
}

class CartService {
  final String baseUrl = 'http://localhost:8080/api/cart';

  Future<Cart> getCart(int utenteId) async {
    final response = await http.get(Uri.parse('$baseUrl/$utenteId'), headers:{'Authorization': 'Bearer ${Authenticator().getToken()}'});

    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Utente non autorizzato');
    } else {
      throw Exception('Impossibile ottenere il carrello');
    }
  }

  Future<void> addProdotto(int utenteId, ProdottoCarrello prodottoCarrello) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$utenteId/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(prodottoCarrello.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Errore nell\'aggiunta del prodotto al carrello');
    }
  }

  Future<void> removeProdotto(int utenteId, ProdottoCarrello prodottoCarrello) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$utenteId/remove'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(prodottoCarrello.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Errore nella rimozione del prodotto dal carrello');
    }
  }

  Future<Ordine> checkout(Cart c) async {
    final response = await http.post(
      Uri.parse('$baseUrl/checkout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Authenticator().getToken()}'
      },
    );

    if (response.statusCode == 200) {
      return Ordine.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Utente non autorizzato');
    } else if (response.statusCode == 400) {
      throw Exception('Errore nel checkout');
    } else {
      throw Exception('Impossibile effettuare il checkout');
    }
  }
}