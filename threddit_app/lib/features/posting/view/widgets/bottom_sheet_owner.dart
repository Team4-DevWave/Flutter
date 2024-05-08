import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/view/edit_post_screen.dart';
import 'package:threddit_clone/features/post/view/widgets/delete_post.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';

/// this bottom sheet is the options bottom sheet that is displayed when the user clicks on the three dots on a post and he is an owner of the post or a moderator
/// it gives him options like save the post, copy the text of the post, mark the post as spoiler, mark the post as NSFW, delete the post, crosspost the post to a community

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
  bool _isLoading = false;
  bool _isSaved = false;
  @override
  void initState() {
    _setVariables();
    super.initState();
  }

  void _setVariables() async {
    setState(() {
      _isLoading = true;
    });
    final response =
        await ref.read(savePostProvider.notifier).isSaved(widget.post.id);
    response.fold(
        (l) => showSnackBar(
            navigatorKey.currentContext!, "Could not retrieve saved state"),
        (success) {
      setState(() {
        _isSaved = success;
        _isLoading = false;
      });
    });
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
          title: Text(
            _isLoading ? 'Loading...' : (_isSaved ? 'Unsave' : 'Save'),
            style: const TextStyle(color: AppColors.whiteColor),
          ),
          leading: Icon(
            Icons.save,
            color: _isLoading
                ? AppColors.whiteHideColor
                : (_isSaved
                    ? AppColors.whiteColor
                    : AppColors.redditOrangeColor),
          ),
          onTap: () async {
            final saved = await ref
                .watch(savePostProvider.notifier)
                .savePostRequest(widget.post.id);
            saved.fold(
              (failure) =>
                  showSnackBar(navigatorKey.currentContext!, failure.message),
              (success) {
                setState(() {
                  _isSaved = !_isSaved; // Toggle the saved state
                });
                if (!_isSaved) {
                  // Check if un-saved
                  ref.read(updatesSaveProvider.notifier).state = widget.post.id;
                }
                Navigator.pop(context);
                showSnackBar(navigatorKey.currentContext!,
                    'Post ${_isSaved ? 'Saved' : 'Unsaved'} successfully');
              },
            );
          },
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
        if ((widget.post.image == "" || widget.post.image == null) &&
            (widget.post.video == "" || widget.post.video == null) &&
            (widget.post.linkURL == "" || widget.post.linkURL == null) &&
            (widget.post.type != "poll"))
          ListTile(
            title: const Text(
              "Edit post",
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onTap: () {
              editPost(context, ref, widget.post);
            },
          ),
        ListTile(
          title: const Text(
            "Crosspost to community",
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.share_outlined),
          onTap: () {
            share(context, ref, widget.post);
          },
        ),
      ],
    );
  }
}
