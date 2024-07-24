import 'dart:async';
import 'dart:convert';


import 'package:frontend/model/objects/LogInResult.dart';
import 'package:frontend/model/objects/utente.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'autentication_data.dart';
import 'package:http/http.dart' as http;


Utente? utenteLoggato;
bool isLoggedIn = false;

class Authenticator{
  static final Authenticator _sharedInstance = Authenticator._internal();

  Authenticator._internal();

  factory Authenticator(){
    return _sharedInstance;
  }
  AuthenticationData? _authenticationData;

  String? getToken(){
    return _authenticationData?.accessToken;
  }

  Future<LogInResult> login(String username, String password) async {
    const url = 'http://localhost:8081/realms/cus/protocol/openid-connect/token';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': 'admin-cli',
          'client_secret': 'UubJ2PW7y2i2F7qHJ0wD3sKaVfUl0W5y',
          'grant_type': 'password',
          'username': username,
          'password': password,
        },
      );


      final Map<String, dynamic> body = json.decode(response.body);
      _authenticationData = AuthenticationData.fromJson(body);
      if (_authenticationData!.hasError()) {
        if (_authenticationData!.error == 'Invalid user credentials') {
          return LogInResult.error_wrong_credentials;
        } else if (_authenticationData!.error == 'Account is not fully set up') {
          return LogInResult.error_not_fully_setupped;
        } else {
          return LogInResult.error_unknown;
        }
      }

      Timer.periodic(Duration(seconds: (_authenticationData!.expiresIn! - 50)), (Timer t) {
        _refreshToken();
      });

      isLoggedIn = true;
      // String token = _authenticationData!.accessToken!;
      // Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      utenteLoggato = await UtenteService.getUtente();


      return LogInResult.logged;


    } catch (e) {
      print(e);
      return LogInResult.error_unknown;
    }
  }

  Future<bool> _refreshToken() async {
    const url = 'http://localhost:8081/realms/cus/protocol/openid-connect/token';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': 'admin-cli',
          'client_secret': 'UubJ2PW7y2i2F7qHJ0wD3sKaVfUl0W5y',
          'grant_type': 'refresh_token',
          'refresh_token': _authenticationData!.refreshToken
        },
      );
      if (response.statusCode != 200) {
        return false;
      }

      final Map<String, dynamic> body = json.decode(response.body);
      _authenticationData = AuthenticationData.fromJson(body);
      if ( _authenticationData!.hasError() ) {
        return false;
      }
      return true;
    }
    catch (e) {
      return false;
    }
  }


  Future<bool> logOut() async {
    const url = 'http://localhost:8081/realms/cus/protocol/openid-connect/logout';
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': 'admin-cli',
          'client_secret': 'UubJ2PW7y2i2F7qHJ0wD3sKaVfUl0W5y',
          'refresh_token': _authenticationData!.refreshToken
        },
      );

      if (response.statusCode != 200) {
        return false;
      }

      isLoggedIn = false;
      _authenticationData!.accessToken = null;
      return true;
    }
    catch (e) {
      return false;
    }
  }
}