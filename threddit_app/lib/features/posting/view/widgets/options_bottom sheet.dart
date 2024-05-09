import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/reporting/view/report_bottom_sheet.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:http/http.dart' as http;
/// this bottom sheet is the options bottom sheet that is displayed when the user clicks on the three dots on a post and he is not an owner of the post or a moderator
/// therefor he can only save the post, share the post, report the post, block the user or hide the post

Future<bool> checkUserBlockState(String userId) async
{
  String? token = await getToken();
    final url = Uri.parse('https://www.threadit.tech/api/v1/users/me/current');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final user = UserModelMe.fromJson(responseData);
        for(int i=0;i<user.blockedUsers!.length;i++)
        {
          if(user.blockedUsers![i].id==userId)
          {
            return true;
          }
        }
        return false;
      } else {
        throw Exception(
            'Failed to fetch post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching post: $e');
      throw Exception('Failed to fetch post');
    }
}

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
  bool _isblocked=false;
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
        final isBlocked=await checkUserBlockState(widget.post.userID!.id);
    response.fold(
        (l) => showSnackBar(
            navigatorKey.currentContext!, "Could not retrieve saved state"),
        (success) {
      setState(() {
        _isSaved = success;
        _isLoading = false;
        _isblocked=isBlocked;
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
          title:_isblocked?const Text(
            'Unblock account',
            style: TextStyle(color: Colors.orange),
          ): const Text(
            'Block account',
            style: TextStyle(color: Colors.orange),
          ),
          leading: const Icon(
            Icons.block,
            color: Colors.orange,
          ),
          onTap: () {
            _isblocked?unblockUser(client: http.Client(), userToUnBlock: widget.post.userID!.username, context: context):
            blockUser(
              userToBlock: widget.post.userID!.username,
              context: context,
            );
            _isblocked=!_isblocked;
            setState(() {
              
            });
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
