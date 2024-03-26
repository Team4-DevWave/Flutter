import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_app/features/home_page/view_model/get_user_communities.dart';

class MockUserCommunitiesAPI extends Mock implements UserCommunitiesAPI {
  @override
  Future<List<String>> getUserCommunities() {
    return Future.value(["r/Egypt", "r/Cairo", "r/Alex"].toList());
  }
}

void main() {
  ///create an instance of the mock class
  late MockUserCommunitiesAPI mockUserCommunities = MockUserCommunitiesAPI();

  test('get communities from API', () async {
    expect(await mockUserCommunities.getUserCommunities(), ['r/Egypt', 'r/Cairo', 'r/Alex'].toList());
  });
}
