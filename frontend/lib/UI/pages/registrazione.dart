// lib/pages/registration_page.dart

import 'package:flutter/material.dart';
import 'package:frontend/model/objects/utente.dart';
import '../../model/objects/reg.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  //Gender? _selectedGender;
  bool _isLoading = false;
  String _errorMessage = '';
  Sesso _sesso = Sesso.MASCHIO;

  List<DropdownMenuItem<Sesso>> get _genderDropdownItems {
    return Sesso.values.map((s) {
      return DropdownMenuItem(
        value: s,
        child: Text(s.toShortString()),
      );
    }).toList();
  }




  /*
  String _genderToString(Gender gender) {
    switch (gender) {
      case Gender.MASCHIO:
        return 'Maschio';
      case Gender.FEMMINA:
        return 'Femmina';
      case Gender.ALTRO:
        return 'Altro';
    }
  }

  Gender _stringToGender(String gender) {
    switch (gender) {
      case 'Maschio':
        return Gender.MASCHIO;
      case 'Femmina':
        return Gender.FEMMINA;
      case 'Altro':
        return Gender.ALTRO;
      default:
        throw ArgumentError('Unknown gender value: $gender');
    }
  }

   */

  void _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;
    Sesso sesso = _sesso;
    //Gender? gender = _selectedGender;



    final userDto = UserRegistrationDto(
      firstName: firstName,
      lastName: lastName,
      email: email,
      sesso: sesso,
      username: username,
      password: password,
    );

    try {
      UserService userService = UserService();
      bool success = await userService.createUser(userDto);

      if (success) {
        Navigator.pop(context); // Torna alla pagina precedente, se necessario
      } else {
        setState(() {
          _errorMessage = 'Registrazione fallita. Riprova.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Errore nella registrazione: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrazione'),
      ),
      body: Center(
        child: SizedBox(
          width: 900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Cognome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<Sesso>(
                value: _sesso,
                items: _genderDropdownItems,
                onChanged: (value) {
                  setState(() {
                    _sesso = value??Sesso.MASCHIO;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Sesso',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Seleziona il sesso'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
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
                onPressed: _register,
                child: const Text('Registrati'),
              ),
              const SizedBox(height: 16.0),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
