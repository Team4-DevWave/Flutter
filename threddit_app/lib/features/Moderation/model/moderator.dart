class Moderator {
  final String username;
  final bool fullPermissions;
  final Map<String, dynamic> permissions;
  Moderator({required this.username, required this.permissions, required this.fullPermissions});

  factory Moderator.fromJson(Map<String, dynamic> json) {
    return Moderator(
        username: json['username'], permissions: json['permissions'], fullPermissions: json['fullPermissions']);
  }
}
