import 'package:flutter_riverpod/flutter_riverpod.dart';

///This class is used in the regtration process to validate all the user inputs and
///show the user the appropriate message for better user experiance.
///
///This class has different validation function and each has its own validation logic
///and its returned message to be displayed to the user.
class Validation {
  ///In this function it take a [String] as an input and check if it is
  ///a valid email format.
  ///
  ///The validation is done using [RegExp] and check that the value is not empty or null.
  ///
  ///On success: null is returned.
  ///
  ///On Failure: a [String] message is returned and used as a validation error message to the user.
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

      return (value == null ||
              value.isEmpty ||
              !regex.hasMatch(value) ||
              value.trim().isEmpty)
          ? 'Not a valid email address'
          : null;
    }

    return validateEmail;
  });

  ///In this function it take a [String] as an input and check if it is
  ///a valid password.
  ///
  ///The validation is checking if the entered value is more than 8 characters
  ///
  ///On success: null is returned.
  ///
  ///On Failure: a [String] message is returned and used as a validation error message to the user.
  final Provider<String? Function(String?)> passwordSignupValidatorProvider =
      Provider(
    (ref) {
      return (value) => (value == null ||
              value.isEmpty ||
              value.trim().isEmpty ||
              value.length < 8)
          ? "Password must be at least 8 characters"
          : null;
    },
  );

  ///In this function it take a [String] as an input and check if it is
  ///a valid email or username.
  ///
  ///The validation is done by checking that the entered value is not empty
  ///
  ///On success: null is returned.
  ///
  ///On Failure: a [String] message is returned and used as a validation error message to the user.
  final Provider<String? Function(String?)> emailLoginValidatorProvider =
      Provider((ref) {
    String? validateEmail(String? value) {
      return (value == null || value.isEmpty || value.trim().isEmpty)
          ? 'Value cannot be empty'
          : null;
    }

    return validateEmail;
  });

  ///In this function it take a [String] as an input and check if it is
  ///a valid password.
  ///
  ///The validation is done by checking that the entered value is not empty
  ///
  ///On success: null is returned.
  ///
  ///On Failure: a [String] message is returned and used as a validation error message to the user.
  final Provider<String? Function(String?)> passwordLoginValidatorProvider =
      Provider(
    (ref) {
      return (value) => (value == null || value.isEmpty || value.trim().isEmpty)
          ? "Value cannot be empty"
          : null;
    },
  );
}
