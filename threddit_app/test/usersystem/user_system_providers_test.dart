import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';

void main() {
  group("update form validity", () {
    late ProviderContainer container;
    container = ProviderContainer();
    test("enteredValue", () {
      container.read(enteredValue.notifier).update((state) => "yes i am here");
      expect(container.read(enteredValue), "yes i am here");
    });
    test("enteredValue account", () {
      container
          .read(enteredAccoutValue.notifier)
          .update((state) => "yes i am here");
      expect(container.read(enteredAccoutValue), "yes i am here");
    });
    test("forget type", () {
      container.read(forgotType.notifier).update((state) => "username");
      expect(container.read(forgotType), "username");
    });
    test("forget type", () {
      container.read(forgotType.notifier).update((state) => "password");
      expect(container.read(forgotType), "password");
    });

    test("isUserNameUsedProvider yess", () {
      container.read(isUserNameUsedProvider.notifier).update((state) => true);
      expect(container.read(isUserNameUsedProvider), true);
    });
    test("isUserNameUsedProvider noo", () {
      container.read(isUserNameUsedProvider.notifier).update((state) => false);
      expect(container.read(isUserNameUsedProvider), false);
    });
    test("signup sucess", () {
      container.read(signUpSuccess.notifier).update((state) => true);
      expect(container.read(signUpSuccess), true);
    });
    test("signup fail", () {
      container.read(signUpSuccess.notifier).update((state) => false);
      expect(container.read(signUpSuccess), false);
    });
  });
}
