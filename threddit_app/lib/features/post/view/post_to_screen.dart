import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_list.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class PostToScreen extends ConsumerStatefulWidget {
  const PostToScreen({super.key});
  @override
  ConsumerState<PostToScreen> createState() => _PostToScreenState();
}

class _PostToScreenState extends ConsumerState<PostToScreen> {
  late TextEditingController _communityText;

  @override
  void initState() {
    super.initState();
    _communityText = TextEditingController();
  }

  @override
  void dispose() {
    _communityText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        title: const Text(
          'Post to',
          style: TextStyle(
              color: AppColors.realWhiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SearchBar(
              hintText: "Search for a community",
              constraints: const BoxConstraints(minHeight: 40, maxHeight: 200),
              side: const MaterialStatePropertyAll(BorderSide(
                  style: BorderStyle.none, color: Colors.transparent)),
              backgroundColor: const MaterialStatePropertyAll(
                  Color.fromARGB(255, 30, 30, 30)),
              surfaceTintColor: const MaterialStatePropertyAll(
                  Color.fromARGB(255, 30, 30, 30)),
              leading: const Icon(
                Icons.search,
                color: AppColors.realWhiteColor,
              ),
              shadowColor: null,
              textStyle:
                  MaterialStatePropertyAll(AppTextStyles.primaryTextStyle),
              onChanged: (text) {
                //search for the new text
              },
            ),
            const CommunityList(),
          ],
        ),
      ),
    );
  }
}
