import 'package:flutter/material.dart';
import 'package:frontend/model/objects/authenticator.dart';
import 'package:frontend/model/objects/shop/cart.dart';
import 'package:frontend/model/objects/shop/ordine.dart';
import '../../../model/objects/utente.dart';
import '../../widgets/app_bar.dart';

class Carrello extends StatefulWidget {
  const Carrello({super.key});

  @override
  _CarrelloState createState() => _CarrelloState();
}

class _CarrelloState extends State<Carrello> {
  late Utente user;
  late Future<Cart> _cartFuture;
  final CartService _cartService = CartService();
  String? _checkoutError;

  @override
  void initState() {
    super.initState();
    if (isLoggedIn) {
      user = utenteLoggato!;
      _cartFuture = _cartService.getCart(user.id);
    }
  }

  Future<void> _checkout() async {
    try {
      final ordine = await _cartService.checkout(user.id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfermaOrdinePage(ordine: ordine)),
      );
    } catch (e) {
      setState(() {
        _checkoutError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(onBackFromSuccessivePage: null,),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Cart>(
              future: _cartFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Errore: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.prodotti.isEmpty) {
                  return const Center(child: Text('Il carrello è vuoto.'));
                } else {
                  final cart = snapshot.data!;
                  return ListView.builder(
                    itemCount: cart.prodotti.length,
                    itemBuilder: (context, index) {
                      final prodottoCarrello = cart.prodotti[index];
                      final prodotto = prodottoCarrello.prodotto;
                      return Card(
                        margin: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(prodotto.immagine, width: 220, height: 220),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prodotto.nome,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Quantità: ${prodottoCarrello.quantita}'),
                                    Text('Prezzo: \$${prodotto.prezzo.toString()}'),
                                    Text('Totale: \$${(prodotto.prezzo * prodottoCarrello.quantita).toString()}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          if (_checkoutError != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _checkoutError!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Sfondo bianco
                iconColor: Colors.black, // Testo nero
              ),
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfermaOrdinePage extends StatelessWidget {
  final Ordine ordine;

  const ConfermaOrdinePage({super.key, required this.ordine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(onBackFromSuccessivePage: null,),
      body: Center(
        child: Text('Ordine confermato! ID ordine: ${ordine.id}'),
      ),
    );
  }
}
