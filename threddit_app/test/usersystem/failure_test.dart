import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';

enum PostTypeOption { any, linkOnly, textOnly }

void main() {
  test('test failure', () {
    Failure fail = Failure("error_message");

    expect(fail.message, "error_message");
  });
}
