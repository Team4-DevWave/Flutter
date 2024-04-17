import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/reporting/view/report_bottom_sheet.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';

/// this bottom sheet is the options bottom sheet that is displayed when the user clicks on the three dots on a post and he is not an owner of the post or a moderator 
/// therefor he can only save the post, share the post, report the post, block the user or hide the post

class OptionsBotttomSheet extends ConsumerStatefulWidget {
  const OptionsBotttomSheet({
    super.key,
    required this.post,
    required this.toggleSPOILER,
    required this.toggleNsfw,
    required this.uid,
  });
  final Post post;
  final VoidCallback toggleSPOILER;
  final VoidCallback toggleNsfw;
  final String uid;
  @override
  _OptionsBotttomSheetState createState() => _OptionsBotttomSheetState();
}

class _OptionsBotttomSheetState extends ConsumerState<OptionsBotttomSheet> {
  bool _isLoading = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _setVariables();
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
          title: const Text(
            'Subscribe to post',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.notifications),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            'Share',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.share),
          onTap: () {
            share(context, ref, widget.post);
          },
        ),
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
                showSnackBar(navigatorKey.currentContext!,
                    'Post ${_isSaved ? 'Saved' : ''} successfully');
              },
            );
          },
        ),
        //const SizedBox(),
        ListTile(
          title: const Text(
            'Copy text',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.copy),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            'Report',
            style: TextStyle(color: Colors.orange),
          ),
          leading: const Icon(
            Icons.flag_outlined,
            color: Colors.orange,
          ),
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              backgroundColor: AppColors.backgroundColor,
              builder: (context) {
                return ReportBottomSheet(
                  userID: widget.uid,
                  reportedID: widget.post.id,
                  type: "post",
                );
              },
            );
          },
        ),
        ListTile(
          title: const Text(
            'Block account',
            style: TextStyle(color: Colors.orange),
          ),
          leading: const Icon(
            Icons.block,
            color: Colors.orange,
          ),
          onTap: () {
            blockUser(
              userToBlock: widget.post.userID!.username,
              context: context,
            );
          },
        ),
        ListTile(
          title: const Text(
            'Hide',
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.hide_source),
          onTap: () {},
        ),
      ],
    );
  }
}
