import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

final saveUnsavePostProvider =
    StateNotifierProvider<SaveUnsavePost, bool>((ref) => SaveUnsavePost(ref));

class SaveUnsavePost extends StateNotifier<bool> {
  final Ref ref;
  SaveUnsavePost(this.ref) : super(false);

  // FutureEither<bool> saveUnsave() {

  // }
}
