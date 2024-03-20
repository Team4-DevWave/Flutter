import 'package:flutter/material.dart';

class UserData {
  UserData({required this.avatar, required this.username, required this.posts});

  final String username;
  final Image avatar;
  final  List<Widget> posts;
  
}

final userData = <UserData>  [
  UserData(
    avatar: Image.asset('assets/images/user1.jpg'),
    username: "John Doe",
    posts: []
  )
];