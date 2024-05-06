import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/community/view%20model/community_provider.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/models/subreddit.dart';

// ignore: must_be_immutable
class CommunityOptionsBotttomSheet extends ConsumerStatefulWidget {
  CommunityOptionsBotttomSheet({
    required this.uid,
    required this.community,
    super.key,
  });
  Subreddit community;
  final String uid;
  @override
  _CommunityOptionsBotttomSheetState createState() =>
      _CommunityOptionsBotttomSheetState();
}

class _CommunityOptionsBotttomSheetState
    extends ConsumerState<CommunityOptionsBotttomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String username = ref.read(userModelProvider)!.username!;
    final newUser = UserModel(id: widget.uid, username: username);
    bool getUserState(Subreddit community) {
      if (community.moderators.contains(newUser)) {
        Navigator.pushNamed(context, RouteClass.communityModTools,
            arguments: <String, dynamic>{'communityName': community.name});
        return true;
      } else {
        if (community.members.contains(newUser)) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Leave Community'),
                        onTap: () {
                          ref.watch(
                              unjoinCommunityProvider(widget.community.name));
                          community.members.remove(newUser);
                          setState(() {});
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, RouteClass.communityScreen, arguments: {
                            'id': widget.community.name,
                            'uid': widget.uid
                          });
                        }),
                  ],
                );
              });
          return true;
        } else {
          ref.watch(joinCommunityProvider(widget.community.name));

          community.members.add(newUser);
          setState(() {});

          return true;
        }
      }
    }

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
            'Learn more about this community',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.info_outline),
          onTap: () {
            Navigator.pushNamed(context, RouteClass.communityInfo, arguments: {
              'community': widget.community,
              'uid': widget.uid,
            });
          },
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
        if (widget.community.moderators.contains(widget.uid))
          ListTile(
            title: const Text(
              'Manage community notifications',
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(Icons.notification_important_outlined),
            onTap: () {},
          ),
        if (widget.community.moderators.contains(widget.uid))
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
          onTap: () {
            getUserState(widget.community);
          },
        ),
      ],
    );
  }
}
