import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/searching/model/search_comment_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

class SearchCommunityScreenPage extends ConsumerStatefulWidget {
  const SearchCommunityScreenPage({super.key, required this.community});
  final String community;

  @override
  _SearchCommunityScreenPageState createState() =>
      _SearchCommunityScreenPageState();
}

class _SearchCommunityScreenPageState
    extends ConsumerState<SearchCommunityScreenPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isFocused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFocused) {
      _isFocused = true;
      // Focus the search field when the screen is loaded
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  void initState() {
    super.initState();
    //didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _searchCommunity(String searchItem) async {
      try {
        final url = Uri.parse(
            'https://www.threadit.tech/api/v1/r/${widget.community}/search?q=$searchItem');
        String? token = await getToken();
        final headers = {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        };
        final response = await http.get(
          url,
          headers: headers,
        );
        if (response.statusCode == 200) {
          print(response.body);
          final List<dynamic> posts =
              jsonDecode(response.body)['data']['posts'];

          final foundPosts = posts.map((post) => Post.fromJson(post)).toList();
          print("this is the posts length ${foundPosts.length}");
          final List<dynamic> comments =
              jsonDecode(response.body)['data']['comments'];
          final foundComments = comments
              .map((comment) => SearchCommentModel.fromJson(comment))
              .toList();
          Navigator.pushNamed(context, RouteClass.communitySearchResults,
              arguments: {
                'communityName': widget.community,
                'searchedItem': _searchController.text,
                'posts': foundPosts,
                'comments': foundComments
              });
        } else {
          print('Error searching community: ${response.statusCode}');
        }
      } catch (e) {
        print('Error searching community: $e');
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 8.w),
              child: Row(
                children: [
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: Colors.white, secondary: Colors.white)),
                      child: TextField(
                        onSubmitted: (text) async {
                          await _searchCommunity(_searchController.text);
                        },
                        style: const TextStyle(color: Colors.white),
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(168, 34, 34, 34),
                          filled: true,
                          hintText: 'Search...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel_outlined),
                            onPressed: () {
                              _searchController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style:
                          TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              color: const Color.fromARGB(168, 34, 34, 34),
              child: ListTile(
                title: Text('Best of r/${widget.community}',
                    style: const TextStyle(fontSize: 15, color: Colors.white)),
                leading: const Icon(Icons.rocket),
                onTap: () {
                  // Handle item tap
                },
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color.fromARGB(168, 34, 34, 34),
              child: ListTile(
                title: Text('New in r/${widget.community}',
                    style: const TextStyle(fontSize: 15, color: Colors.white)),
                leading: const Icon(Icons.new_releases_outlined),
                onTap: () {
                  // Handle item tap
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
