import 'package:flutter_riverpod/flutter_riverpod.dart';

class Validation {
  final Provider<String? Function(String?)> emailSignupValidatorProvider =
      Provider((ref) {
    String? validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);

      return (value == null || value.isEmpty || !regex.hasMatch(value))
          ? 'Not a valid email address'
          : null;
    }

    return validateEmail;
  });

  final Provider<String? Function(String?)> passwordSignupValidatorProvider =
      Provider(
    (ref) {
      return (value) => (value == null || value.isEmpty || value.length < 8)
          ? "Password must be at least 8 characters"
          : null;
    },
  );

  final Provider<String? Function(String?)> emailLoginValidatorProvider =
      Provider((ref) {
    String? validateEmail(String? value) {
      return (value == null || value.isEmpty) ? 'Value cannot be empty' : null;
    }

    return validateEmail;
  });

  final Provider<String? Function(String?)> passwordLoginValidatorProvider =
      Provider(
    (ref) {
      return (value) =>
          (value == null || value.isEmpty) ? "Value cannot be empty" : null;
    },
  );
}
