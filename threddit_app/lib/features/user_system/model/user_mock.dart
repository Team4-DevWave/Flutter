/// Temperoray user class to test the user setttings functionalities.
class UserMock {
  final String id;
  final String username;
  final String email;
  final String gender;
  final bool isBlocked;
  UserMock({
    required this.id,
    required this.email,
    required this.username,
    required this.gender,
    required this.isBlocked,
  });
  factory UserMock.fromJson(Map<String, dynamic> json) {
    return UserMock(
      id: json['user_id'],
      username: json['username'],
      email: json['email'],
      gender: json['gender'],
      isBlocked: json['blocked'],
    );
  }
  UserMock copyWith({
    String? username,
    bool? isBlocked,
    String? email,
    String? id,
    String? gender,
  }) {
    return UserMock(
      username: username ?? this.username,
      isBlocked: isBlocked ?? this.isBlocked,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      id: id ?? this.id,
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

  bool get getBlocked {
    return isBlocked;
  }

  void printUserInfo() {
    print('User id is $id, Username is $username, User email is $email');
  }
}
