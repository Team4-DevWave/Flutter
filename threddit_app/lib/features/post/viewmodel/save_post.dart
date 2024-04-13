import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveUnsavePostProvider =
    StateNotifierProvider<SaveUnsavePost, bool>((ref) => SaveUnsavePost(ref));

class SaveUnsavePost extends StateNotifier<bool> {
  final Ref ref;
  SaveUnsavePost(this.ref) : super(false);

  // FutureEither<bool> saveUnsave() {

  // }
}
