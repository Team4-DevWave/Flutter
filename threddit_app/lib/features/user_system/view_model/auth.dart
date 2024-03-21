// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Auth with ChangeNotifier {
//   String? _token;
//   DateTime? _expiryDate;
//   String? _userId;

//   Future<void> signup(String email, String password) async {
//     Uri url = Uri.parse(
//         'https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=AIzaSyCjG0k8MbVS_BJj2-0n8MXMgdits9pzqY0');

//     final response = await http.post(
//       url,
//       body: json.encode(
//         {
//           'email': email,
//           'password': password,
//           'returnSecureToken': true,
//         },
//       ),
//     );
//     print(json.decode(response.body));
//   }
// }
