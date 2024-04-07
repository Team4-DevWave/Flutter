
/// Temperoray user class to test the user setttings functionalities.
class UserMock {
  final String id;
  final String username;
  final String email;
  final String gender;
  UserMock(
      {required this.id,
      required this.email,
      required this.username,
      required this.gender});
  factory UserMock.fromJson(Map<String, dynamic> json) {
    return UserMock(
      id: json['user_id'],
      username: json['username'],
      email: json['email'],
      gender: json['gender'],
    );
  }
  String get getUsername {
    return username;
  }

  String get getEmail {
    return email;
  }

  String get getGender {
    return gender;
  }

  void printUserInfo() {
    print('User id is $id, Username is $username, User email is $email');
  }
}
