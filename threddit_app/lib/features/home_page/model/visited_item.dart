class VisitedItem {
  final String username;
  final String type;
  final String imageUrl;

  VisitedItem(this.username, this.type, this.imageUrl);

  // Convert VisitedItem to Map for storing in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'type': type,
      'imageUrl': imageUrl,
    };
  }

  // Create VisitedItem from Map retrieved from SharedPreferences
  factory VisitedItem.fromMap(Map<String, dynamic> map) {
    return VisitedItem(
      map['username'],
      map['type'],
      map['imageUrl'],
    );
  }
}
