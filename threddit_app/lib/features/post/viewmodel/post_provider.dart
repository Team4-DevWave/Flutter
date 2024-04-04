import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';

final postDataProvider = StateProvider<PostData?>((ref) => PostData(title: "", isNSFW: false, isSpoiler: false));