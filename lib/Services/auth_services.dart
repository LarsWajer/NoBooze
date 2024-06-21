import 'dart:convert';

import 'globals.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static Future<http.Response> register(
      String name, String email, String password) async {
    Map data = {
      "user_name": name,
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> login(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    setResponseBody(response.body);
    return response;
  }

  static String responseBody = '';

  static setResponseBody(String body) {
    responseBody = body;
  }

  static Map getUserInformation() {
    Map<String, dynamic> response = json.decode(responseBody);
    print('user');
    Map<String, dynamic> user = response['user'];
    print(user);
    print(user[0]);
    return user;
  }
}
