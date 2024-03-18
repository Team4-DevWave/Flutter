import 'package:flutter/material.dart';

class DrawerTile{
  DrawerTile({required this.title, required this.icon});
  String title;
  Icon icon;
}

final communitiesTiles = <DrawerTile>[
  //fetch communities icon and name  from database 
  DrawerTile(title: "u/Announcements", icon: const Icon(Icons.announcement, size: 20)),
  DrawerTile(title: "u/Egypt", icon: const Icon(Icons.flag,size: 20)),
  DrawerTile(title: "u/Engineering", icon: const Icon(Icons.engineering,size: 20))
];

final follwoingTile = <DrawerTile> [
  //fetch following list from database
  DrawerTile(title: "u/Doha ElBeltagy", icon: const Icon(Icons.person, size: 20))
];

final recentlyVisitedTiles = <DrawerTile>[
  //fetch recentl visted list form database
];