import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContinueSignupNotifier extends StateNotifier<bool> {
  ContinueSignupNotifier() : super(true);

  void toggleBottomOnAndOff(GlobalKey<FormState> formKey) {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      state = true;
    } else {
      state = false;
    }
  }
}

final continueSignupProvider =
    StateNotifierProvider<ContinueSignupNotifier, bool>((ref) {
  return ContinueSignupNotifier();
});
