import 'package:flutter/material.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_list.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class PostToScreen extends StatefulWidget {
  const PostToScreen({super.key});
  @override
  State<PostToScreen> createState() => _PostToScreenState();
}

class _PostToScreenState extends State<PostToScreen> {
  late TextEditingController _communityText;
  late Future<List<String>> searchResults;

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _communityText = TextEditingController();
    searchResults = Future.value([]);
    super.initState();
  }

  @override
  void dispose() {  
    _communityText.dispose();
    super.dispose();
  }

  void _onQueryChanged (String query){
    setState(() {
     searchResults = UserCommunitiesAPI().searchResults(query);
    });
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
                _onQueryChanged(text);
              },
            ),
           CommunityList(searchRes : searchResults),
          ],
        ),
      ),
    );
  }
}
