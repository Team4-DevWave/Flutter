/// Simple mocking for an approved user.
/// Represents an approved user with their username.

class ApprovedUser {
  final String username;

  const ApprovedUser({
    required this.username,

  });

  factory ApprovedUser.fromJson(Map<String, dynamic> json) => ApprovedUser(
        username: json['username'] as String,
      );
  
  String get getUsername{
      return username;
  }

}
