import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/models/subreddit.dart';


class CommunityOptionsBotttomSheet extends ConsumerStatefulWidget {
  const CommunityOptionsBotttomSheet({
    required this.uid,
    required this.community,
    super.key,
  });
  final Subreddit community;
  final String uid;
  @override
  _CommunityOptionsBotttomSheetState createState() => _CommunityOptionsBotttomSheetState();
}

class _CommunityOptionsBotttomSheetState extends ConsumerState<CommunityOptionsBotttomSheet> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: const Text(
              'More actions...',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
            }),
        ListTile(
          title: const Text(
            'Add the Custom Feed',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.library_books_rounded),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            'Learn more about this community',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.info_outline),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            'Set community alerts',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.notification_important_outlined),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            'Message Moderators',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.mail_outline),
          onTap: () {},
        ),
        if(widget.community.moderators.contains(widget.uid))
        ListTile(
          title: const Text(
            'Manage community notifications',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.notification_important_outlined),
          onTap: () {},
        ),
        if(widget.community.moderators.contains(widget.uid))
        ListTile(
          title: const Text(
            'Manage mod notifications',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.shield_sharp),
          onTap: () {},
        ),
        
        ListTile(
          title: Text(
            'Mute r/${widget.community.name}',
            style: const TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.media_bluetooth_off_sharp),
          onTap: () {},
        ),
        
        ListTile(
          title: const Text(
            'Leave',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.do_not_disturb_on_sharp),
          onTap: () {},
        ),
        
        
      ],
    );
  }
}
