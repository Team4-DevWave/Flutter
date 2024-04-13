import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/view/widgets/delete_post.dart';

class ModeratorBotttomSheet extends ConsumerStatefulWidget {
  const ModeratorBotttomSheet({
    super.key,
    required this.post,
    required this.toggleSPOILER,
    required this.toggleNsfw,
  });
  final Post post;
  final VoidCallback toggleSPOILER;
  final VoidCallback toggleNsfw;
  @override
  _ModeratorBotttomSheetState createState() => _ModeratorBotttomSheetState();
}

class _ModeratorBotttomSheetState extends ConsumerState<ModeratorBotttomSheet> {
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
            'Save',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.save),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            'Copy text',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.copy),
          onTap: () {},
        ),
        ListTile(
          title: Text(
            widget.post.spoiler ? 'UnMark Spoiler' : "Mark Spoiler",
            style: const TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.warning_amber_rounded),
          onTap: () {
            widget.toggleSPOILER();
          },
        ),
        ListTile(
          title: Text(
            widget.post.nsfw ? 'UnMark NSFW' : "Mark NSFW",
            style: const TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.eighteen_mp),
          onTap: () {
            widget.toggleNsfw();
          },
        ),
        ListTile(
          title: const Text(
            "Delete post",
            style: TextStyle(color: Colors.orange),
          ),
          leading: const Icon(
            Icons.delete_outline,
            color: Colors.orange,
          ),
          onTap: () {
            delete(context, ref, widget.post.id);
          },
        ),
        ListTile(
          title: const Text(
            "Crosspost to community",
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.share_outlined),
          onTap: () {},
        ),
      ],
    );
  }
}
