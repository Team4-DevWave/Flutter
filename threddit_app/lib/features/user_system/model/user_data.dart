import 'dart:convert';
import 'package:flutter/foundation.dart';

class UserModel {
  final String username;
  final String email;
  final String password;
  final String passwordConfirm;
  final String country;
  final String gender;
  final String token;
  final bool isGoogle;
  final List<String> interests;
  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.country,
    required this.gender,
    required this.token,
    required this.isGoogle,
    required this.interests,
  });

  UserModel copyWith({
    String? username,
    String? email,
    String? password,
    String? passwordConfirm,
    String? country,
    String? gender,
    String? token,
    bool? isGoogle,
    List<String>? interests,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      token: token ?? this.token,
      isGoogle: isGoogle ?? this.isGoogle,
      interests: interests ?? this.interests,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'country': country,
      'gender': gender,
      'token': token,
      'isGoogle': isGoogle,
      'interests': interests,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        username: map['username'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
        passwordConfirm: map['passwordConfirm'] as String,
        country: map['country'] as String,
        gender: map['gender'] as String,
        token: map['token'] as String,
        isGoogle: map['isGoogle'] as bool,
        interests: List<String>.from(
          (map['interests'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(username: $username, email: $email, password: $password, passwordConfirm: $passwordConfirm, country: $country, gender: $gender, token: $token, isGoogle: $isGoogle, interests: $interests)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.email == email &&
        other.password == password &&
        other.passwordConfirm == passwordConfirm &&
        other.country == country &&
        other.gender == gender &&
        other.token == token &&
        other.isGoogle == isGoogle &&
        listEquals(other.interests, interests);
  }

  @override
  int get hashCode {
    return username.hashCode ^
        email.hashCode ^
        password.hashCode ^
        passwordConfirm.hashCode ^
        country.hashCode ^
        gender.hashCode ^
        token.hashCode ^
        isGoogle.hashCode ^
        interests.hashCode;
  }
}
