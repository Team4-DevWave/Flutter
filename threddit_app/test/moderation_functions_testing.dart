import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_functions.dart';

void main() {
  Map<String, bool?> modPermissions = {
    'access': false,
    'config': false,
    'flair': false,
    'chatConfig': false,
    'mail': false,
    'posts': false,
    'wiki': false,
    'chatOperator': false,
  };
  Map<String, bool?> truePermissions = {
    'access': true,
    'config': true,
    'flair': true,
    'chatConfig': true,
    'mail': true,
    'posts': true,
    'wiki': true,
    'chatOperator': true,
  };
  Map<String, bool?> falsePermissions = {
    'access': true,
    'config': true,
    'flair': true,
    'chatConfig': true,
    'mail': true,
    'posts': true,
    'wiki': true,
    'chatOperator': true,
  };
  group("Set all permission to true/false", () {
    test("Set all permissions to true", () {
      setAllPermissions(true, modPermissions);
      expect(modPermissions, truePermissions);
    });
    test("Set all permission to false", (){
      setAllPermissions(false, truePermissions);
      expect(truePermissions, falsePermissions);
    });
  });
}
