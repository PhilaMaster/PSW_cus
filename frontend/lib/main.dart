

import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CUS COSENZA"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Home"),
            Tab(text: "Shop"),
            Tab(text: "Prenotazioni"),
            Tab(text: "Contatti"),
            Tab(text: "Logout"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Home
          Container(
            child: const Center(
              child: Text("Home Tab"),
            ),
          ),
          // Tab 2: Shop
          Container(
            child: const Center(
              child: Text("Shop Tab"),
            ),
          ),
          // Tab 3: Prenotazioni
          Container(
            child: const Center(
              child: Text("Prenotazioni Tab"),
            ),
          ),
          // Tab 4: Contatti
          Container(
            child: const Center(
              child: Text("Contatti Tab"),
            ),
          ),
          // Tab 5: Logout
          Container(
            child: const Center(
              child: Text("Logout Tab"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.green,
      brightness: Brightness.dark,
    ),
    home: const RootPage(),
  ));
}
