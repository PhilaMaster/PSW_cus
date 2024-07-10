import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

//Prendere con la query i prodotti e metterli in una lista poi visualizzarli con il future builder e il listview.builder
  // se la barra di ricerca è vuota allora stampa tutti i prodotti. Vedere come salvare le immagini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
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
            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
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
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 120,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.white,
                    padding: EdgeInsets.all(15),
                  ),
                  child: const Text('Prezzo'),
                ),
              ),
              SizedBox(
                width: 120,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.white,
                    padding: EdgeInsets.all(15),
                  ),
                  child: const Text('Categoria'),
                ),
              ),
              SizedBox(
                width: 120, // Definisci la larghezza del pulsante
                height: 60, // Definisci l'altezza del pulsante
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.white,
                    padding: EdgeInsets.all(15),
                  ),
                  child: const Text('Sesso'),
                ),
              ),
            ],
          ),
          Row(

          ),
          // Add more content as needed
        ],
      ),
    );
  }
}
