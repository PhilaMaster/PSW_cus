
import 'dart:convert';
import 'package:frontend/model/objects/utente.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = 'http://localhost:8080/users'; // Verifica l'URL

  Future<bool> createUser(UserRegistrationDto userDto) async {
    final url = Uri.parse('$_baseUrl/registrazione'); // Verifica il percorso

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',

        },
        body: json.encode(userDto.toJson()),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to register user: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }
}

//enum Gender { MASCHIO, FEMMINA, ALTRO }

class UserRegistrationDto {
  final String firstName;
  final String lastName;
  final String email;
  final Sesso sesso; // Usa l'enum per il sesso
  final String username;
  final String password;

  UserRegistrationDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.sesso,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      //'sesso': _genderToString(sesso),
      'sesso':sesso.toShortString(),
      'username': username,
      'password': password,
    };
  }

  factory UserRegistrationDto.fromJson(Map<String, dynamic> json) {
    return UserRegistrationDto(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      //sesso: _stringToGender(json['sesso'] as String),
      sesso: SessoExtension.fromString(json['sesso']),
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }

  /*
  static String _genderToString(Gender gender) {
    switch (gender) {
      case Gender.MASCHIO:
        return 'male';
      case Gender.FEMMINA:
        return 'female';
      case Gender.ALTRO:
        return 'other';
    }
  }

  static Gender _stringToGender(String gender) {
    switch (gender) {
      case 'male':
        return Gender.MASCHIO;
      case 'female':
        return Gender.FEMMINA;
      case 'other':
        return Gender.ALTRO;
      default:
        throw ArgumentError('Unknown gender value: $gender');
    }
  }*/
}
