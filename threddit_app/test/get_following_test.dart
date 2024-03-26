import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_app/features/home_page/view_model/get_user_following.dart';

class MockUserFollowingAPI extends Mock implements UserFollowingAPI {
  @override
  Future<List<String>> getUserFollowing() {
    return Future.value(["u/SamEsmail",
        "u/Eliot",
        "u/Darlene"].toList());
  }
}

void main() {
  ///create an instance of the mock class
  late MockUserFollowingAPI mockUserFollowing = MockUserFollowingAPI();

  test('get communities from API', () async {
    expect(await mockUserFollowing.getUserFollowing(), ["u/SamEsmail",
        "u/Eliot",
        "u/Darlene"].toList());
  });
}
