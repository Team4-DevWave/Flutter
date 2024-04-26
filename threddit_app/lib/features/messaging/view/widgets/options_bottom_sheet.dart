import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// this bottom sheet is the options bottom sheet that is displayed when the user clicks on the three dots on a post and he is an owner of the post or a moderator
/// it gives him options like save the post, copy the text of the post, mark the post as spoiler, mark the post as NSFW, delete the post, crosspost the post to a community

class InboxOptionsBotttomSheet extends ConsumerStatefulWidget {
  const InboxOptionsBotttomSheet({
    super.key,
  });
  @override
  _InboxOptionsBotttomSheetState createState() => _InboxOptionsBotttomSheetState();
}

class _InboxOptionsBotttomSheetState extends ConsumerState<InboxOptionsBotttomSheet> {
  bool _isLoading = false;
  @override
  void initState() {
    _setVariables();
    super.initState();
  }

  void _setVariables() async {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                
        ListTile(
          title: const Text(
            "New message",
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.edit),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            "Mark all inbox tabs as read",
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.mark_chat_read_outlined),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            "Edit notifications settings",
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.settings),
          onTap: () {},
        ),
      ],
    );
  }
}
