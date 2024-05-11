import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/view_model/validation_providers.dart';

void main() {
  group("authentication", () {
    test('Email validation test', () {
      final container = ProviderContainer();

      final validator =
          container.read(Validation().emailSignupValidatorProvider);

      expect(validator('mario@gmail.com'), null);

      expect(validator('anyrandomtext'), 'Not a valid email address');
    });

    test('Password validation test', () {
      final container = ProviderContainer();

      final validator =
          container.read(Validation().passwordSignupValidatorProvider);

      expect(validator('testpassword'), null);

      expect(validator('12345'), 'Password must be at least 8 characters');
    });
    test('emailLogin validation test', () {
      final container = ProviderContainer();

      final validator =
          container.read(Validation().emailLoginValidatorProvider);

      expect(validator('login'), null);

      expect(validator(''), 'Value cannot be empty');
    });
    test('emailLogin validation test', () {
      final container = ProviderContainer();

      final validator =
          container.read(Validation().emailLoginValidatorProvider);

      expect(validator('login'), null);

      expect(validator(''), 'Value cannot be empty');
    });
    test('emailLogin validation test', () {
      final container = ProviderContainer();

      final validator =
          container.read(Validation().passwordLoginValidatorProvider);

      expect(validator('12345678'), null);

      expect(validator(''), 'Value cannot be empty');
    });
  });
}
