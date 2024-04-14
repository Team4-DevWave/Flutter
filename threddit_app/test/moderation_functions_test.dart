import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_functions.dart';

void main() {
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
    'access': false,
    'config': false,
    'flair': false,
    'chatConfig': false,
    'mail': false,
    'posts': false,
    'wiki': false,
    'chatOperator': false,
  };
  group("Set all permission to true/false", () {
    test("Set all permissions to true", () {
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
      setAllPermissions(true, modPermissions);
      expect(modPermissions, truePermissions);
    });
    test("Set all permission to false", () {
      Map<String, bool?> modPermissions = {
        'access': true,
        'config': true,
        'flair': true,
        'chatConfig': true,
        'mail': true,
        'posts': true,
        'wiki': true,
        'chatOperator': true,
      };
      setAllPermissions(false, modPermissions);

      expect(modPermissions, falsePermissions);
    });
  });
  group("Check permissions to enable/disable full permissions", () {
    test("Check permissions to enable full permissions", () {
      Map<String, bool?> modPermissions = {
        'access': true,
        'config': true,
        'flair': true,
        'chatConfig': true,
        'mail': true,
        'posts': true,
        'wiki': true,
        'chatOperator': true,
      };
      bool fullPermissions = checkPermissions(modPermissions);
      expect(fullPermissions, true);
    });
    test("Check permissions to disable full permissions", () {
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
      bool fullPermissions = checkPermissions(modPermissions);
      expect(fullPermissions, false);
    });
  });
  group("Ban validation function", () {
    test("empty user", () {
      expect(validateBan("", "Personal", "5"), 3);
    });
    test("ban duration = 0", () {
      expect(validateBan("test", "Personal", "0"), 2);
    });
    test("no rule selected", () {
      expect(validateBan("test", "Select a rule", "5"), 1);
    });
    test("all pass", () {
      expect(validateBan("test", "Personal", "5"), 0);
    });
  });
  group("Approve validation function", () {
    test("empty user", () {
      expect(validateApprove(""), 3);
    });
    test("all pass", () {
      expect(validateApprove("test"), 0);
    });
  });
}
