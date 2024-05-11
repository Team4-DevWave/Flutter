import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_profile/models/other_user_data.dart';
import 'package:threddit_clone/features/user_profile/view/other_users.dart';

void main(){

   group('checkExistance function test', () {
    test('returns true when username exists in followedUsers', () {
      final followedUsers = [
        {'username': 'user1'},
        {'username': 'user2'},
        {'username': 'user3'},
      ];
      final user = UserModelNotMe(username: 'user2');
      final result = checkExistance('user2', followedUsers, user);
      expect(result, true);
    });

    test('returns false when username does not exist in followedUsers', () {
      final followedUsers = [
        {'username': 'user1'},
        {'username': 'user2'},
        {'username': 'user3'},
      ];
      final user = UserModelNotMe(username: 'user4'); 
      final result = checkExistance('user4', followedUsers, user);
      expect(result, false);
    });

    test('returns false when followedUsers is null', () {
      final user = UserModelNotMe(username: 'user1');
      final result = checkExistance('user1', null, user); 
      expect(result, false);
    });

    test('returns false when user is null', () {
      final followedUsers = [
        {'username': 'user1'},
        {'username': 'user2'},
        {'username': 'user3'},
      ];
      final result = checkExistance('user2', followedUsers, null);
      expect(result, false);
    });
  });
}