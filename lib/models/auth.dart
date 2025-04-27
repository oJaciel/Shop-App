import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  //URL do registro
  //https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDoDWtdwKf-nYBYY8FsDKwztfZzE2gMkPk

  //URL do login
  //https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDoDWtdwKf-nYBYY8FsDKwztfZzE2gMkPk

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyDoDWtdwKf-nYBYY8FsDKwztfZzE2gMkPk';

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ));

    final body = jsonDecode(response.body);

    print(body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
