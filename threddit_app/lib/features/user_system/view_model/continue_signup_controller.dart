import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContinueSignupNotifier extends StateNotifier<bool> {
  ContinueSignupNotifier() : super(false);

  void updateFormValidity(bool isValid) {
    state = isValid;
  }
}

final continueSignupProvider =
    StateNotifierProvider<ContinueSignupNotifier, bool>((ref) {
  return ContinueSignupNotifier();
});
