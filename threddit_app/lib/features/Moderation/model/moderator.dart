class Moderator {
  final String username;
  final Map<String, dynamic> permissions;
  Moderator({required this.username, required this.permissions});

  factory Moderator.fromJson(Map<String, dynamic> json) {
    return Moderator(
        username: json['username'], permissions: json['permissions']);
  }
}
