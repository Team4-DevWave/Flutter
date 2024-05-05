/// This file contains the providers used in the application.

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A Riverpod provider for managing the state of `mtoken`.
///
/// This provider is a `StateProvider` that holds the state of `mtoken`.
/// `mtoken` is a string that represents the Firebase Cloud Messaging token.
final mtokenProvider = StateProvider<String>((ref) => '');
