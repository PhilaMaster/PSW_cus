import 'package:flutter/material.dart';

import '../../model/objects/LogInResult.dart';
import '../../model/objects/authenticator.dart';
import '../widgets/app_bar.dart';



class LoginSus extends StatefulWidget {
  const LoginSus({super.key});

  @override
  LoginSusState createState() => LoginSusState();
}

class LoginSusState extends State<LoginSus> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    Authenticator authenticator = Authenticator();
    LogInResult result = await authenticator.login(username, password);

    setState(() {
      _isLoading = false;
      if (result == LogInResult.logged) {
        isLoggedIn = true;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
      } else if (result == LogInResult.error_wrong_credentials) {
        _errorMessage = 'Credenziali errate. Riprova.';
      } else if (result == LogInResult.error_not_fully_setupped) {
        _errorMessage = 'Account non completamente configurato.';
      } else {
        _errorMessage = 'Errore sconosciuto. Riprova.';
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}