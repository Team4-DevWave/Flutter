import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/features/post/model/post_data.dart';

class MainCommunityScreen extends ConsumerStatefulWidget {
  const MainCommunityScreen({super.key});
  @override
  ConsumerState<MainCommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<MainCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: () {
              share(context, ref, posts[0]);
            },
            child: Text('Share')));
  }
}
