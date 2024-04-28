import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/community/view/search_community.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SearchScreen extends ConsumerStatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  SearchModel search =
      SearchModel(posts: [], comments: [], subreddits: [], medias: []);
  @override
  void initState() {
    super.initState();
    searchController.addListener(onChange);
  }

  void fetchSearch(String query) async {
    search = await ref.watch(searchingApisProvider.notifier).search(query);
  }

  void onChange() async {
    print("the text is ${searchController.text}");
    setState(() {
      fetchSearch(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
        child: Column(
          children: [
            TextFormField(
              style: AppTextStyles.primaryTextStyle,
              controller: searchController,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      search.posts[index].title,
                      style: AppTextStyles.primaryTextStyle,
                    ),
                  );
                },
                itemCount: search.posts.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
