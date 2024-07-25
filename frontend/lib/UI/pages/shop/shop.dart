import 'package:flutter/material.dart';
import '../../../model/objects/shop/cart.dart';
import '../../../model/objects/shop/prodotto.dart';
import '../../../model/objects/authenticator.dart';
import '../../../model/objects/utente.dart';
import '../../widgets/app_bar.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  String? _selectedCategory;
  late Future<List<Prodotto>> _allProdottiFuture;
  List<Prodotto> _displayedProdotti = [];
  Map<int, int> _quantities = {};
  late Utente user;

  @override
  void initState() {
    super.initState();
    _allProdottiFuture = ProdottoService().getAllProdotti();
    _loadProdotti();
    if (isLoggedIn) {
      user = utenteLoggato!;
    }
  }

  Future<void> _loadProdotti() async {
    final allProdotti = await _allProdottiFuture;
    setState(() {
      _displayedProdotti = allProdotti;
    });
  }

  void _search(String query) {
    setState(() {
      _searchTerm = query;
      _filterProdotti();
    });
  }

  void _filterProdotti() {
    _allProdottiFuture.then((allProdotti) {
      setState(() {
        _displayedProdotti = allProdotti
            .where((prodotto) =>
        prodotto.nome.toLowerCase().contains(_searchTerm.toLowerCase()) &&
            (_selectedCategory == null || prodotto.categoria == _selectedCategory))
            .toList();
      });
    });
  }

  void _onCategoryChanged(String? newCategory) {
    setState(() {
      _selectedCategory = newCategory;
      _filterProdotti();
    });
  }

  void _resetCategory() {
    setState(() {
      _selectedCategory = null;
      _filterProdotti();
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      _quantities[index] = (_quantities[index] ?? 0) + 1;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      _quantities[index] = (_quantities[index] ?? 0) - 1;
      if ((_quantities[index] ?? 0) <= 0) {
        _quantities.remove(index);
      }
    });
  }

  Future<void> _addToCart(Prodotto prodotto, int quantity) async {
    try {
      final prodottoCarrelloDTO = ProdottoCarrelloDTO(
        idProdotto: prodotto.id, // Assuming Prodotto has an 'id' field
        quantita: quantity,
      );
      await CartService().addProdotto(prodottoCarrelloDTO);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prodotto aggiunto al carrello')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(onBackFromSuccessivePage: null),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          const Center(
            child: Text(
              'SHOP',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dropdown per categoria
                DropdownButton<String>(
                  value: _selectedCategory,
                  hint: const Text('Categoria'),
                  items: <String>['Accessori', 'Abbigliamento', 'Attrezzature', 'Integratori']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: _onCategoryChanged,
                ),
                const SizedBox(width: 20.0),
                // Barra di ricerca
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _search,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Cerca...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                if (_selectedCategory != null)
                  TextButton(
                    onPressed: _resetCategory,
                    child: const Text('Tutti'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          FutureBuilder<List<Prodotto>>(
            future: _allProdottiFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Nessun prodotto trovato');
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: _displayedProdotti.length,
                    itemBuilder: (context, index) {
                      final prodotto = _displayedProdotti[index];
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
                                    Text(prodotto.categoria),
                                    Text(prodotto.descrizione),
                                    Text('\$${prodotto.prezzo.toString()}'),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () => _decreaseQuantity(index),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: Text(
                                          '${_quantities[index] ?? 0}',
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => _increaseQuantity(index),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      if(!isLoggedIn){
                                        Navigator.pushNamed(context, "/login");
                                        return;
                                      }
                                      if (_quantities[index] != null && _quantities[index]! > 0) {
                                        _addToCart(prodotto, _quantities[index]!);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      iconColor: Colors.black,
                                    ),
                                    child: const Text('Aggiungi al carrello'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
