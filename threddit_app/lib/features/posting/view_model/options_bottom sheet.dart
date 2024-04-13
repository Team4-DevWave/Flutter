import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/features/reporting/view/report_bottom_sheet.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/colors.dart';

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
            Navigator.pop(context);
            share(context, ref, widget.post);
          },
        ),
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
        )
      ],
    );
  }
}
