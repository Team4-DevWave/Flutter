class BannedUser {
  final String username;


  const BannedUser({
    required this.username,

  });

  factory BannedUser.fromJson(Map<String, dynamic> json) => BannedUser(
        username: json['username'] as String,
      );
  
  String get getUsername{
      return username;
  }
}
