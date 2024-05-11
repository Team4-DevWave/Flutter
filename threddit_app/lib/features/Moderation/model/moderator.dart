/// Class responsible for recieveing a simple mocking of a moderator.
/// Has the user name and the permissions of the moderator. 
/// Also a [bool] that checks if the moderator has full permissions or not.
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
