/// A Riverpod provider for counting notifications.
///
/// This file defines a `StateProvider` that holds an integer value. This value can be used
/// to count the number of notifications in an application.

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A `StateProvider` that holds an integer value.
///
/// This provider is typically used to count the number of notifications in an application.
/// The initial value of the counter is 0.
final counterProvider = StateProvider<int>((ref) => 0);
