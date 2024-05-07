class Favourite {
  final String username;
  final String type;
  final String imageUrl;

  Favourite(this.username, this.type, this.imageUrl);

  Map<String, dynamic> toMap() {
    return {
      'name': username,
      'type': type,
    };
  }

  factory Favourite.fromMap(Map<String, dynamic> map) {
    return Favourite(
      map['name'],
      map['type'],
      map['Picture'],
    );
  }
}
