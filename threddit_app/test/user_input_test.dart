import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/view_model/email_signup_controller.dart';

void main() {
  test('Email validation test', () {
    final container = ProviderContainer();

    final validator = container.read(Validation().emailSignupValidatorProvider);

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
}
