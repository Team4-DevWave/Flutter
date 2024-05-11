import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/view_model/continue_signup_controller.dart';

void main() {
  group("update form validity", () {
    test("update to false", () {
      late ProviderContainer container;
      container = ProviderContainer();

      container.read(continueSignupProvider.notifier).updateFormValidity(false);
      expect(container.read(continueSignupProvider), false);
    });

    test("update to true", () {
      late ProviderContainer container;
      container = ProviderContainer();

      container.read(continueSignupProvider.notifier).updateFormValidity(true);
      expect(container.read(continueSignupProvider), true);
    });
  });
}
