/// Class responsible for recieveing a simple mocking of a banned user.
/// Has the username and reason to be banned.
class BannedUser {
  final String username;
  final String reason;

  const BannedUser({
    required this.username,
    required this.reason

  });

  factory BannedUser.fromJson(Map<String, dynamic> json) => BannedUser(
        username: json['username'] as String,
        reason: json['reason'] as String,
      );
  
  String get getUsername{
      return username;
  }
  String get getReason{
      return reason;
  }
}
