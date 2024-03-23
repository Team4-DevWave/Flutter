class UserMock{
  final String id;
  final String username;
  final String email;
  UserMock({required this.id, required this.email, required this.username});
  factory UserMock.fromJson(Map<String, dynamic> json) {
    return UserMock(
      id: json['user_id'] as String? ?? "",
      username: json['username'] as String? ?? "",
      email: json['email'] as String? ?? "",
    );
  }
  String get getUsername{
    return username;
  }
  String get getEmail{
    return email;
  }
  void printUserInfo(){
    print('User id is ${id}, Username is ${username}, User email is ${email}');
  }
}

