import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/community/view/search_community.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/model/trends.dart';
import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
import 'package:threddit_clone/features/searching/view_model/searching_function.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  int mode = 0;
  String? userId;
  SearchModel search = SearchModel(
      posts: [], comments: [], subreddits: [], medias: [], users: []);
  @override
  void initState() {
    super.initState();
    getUserId();
    searchController.addListener(onChange);
  }

  Future<void> getUserID() async {
    userId = await getUserId();
    print(userId);
  }

  void fetchSearch(String query) async {
    final response =
        await ref.watch(searchingApisProvider.notifier).search(query, 1);
    print("THE NUMBER OF SUBREDDITS IS:     ");
    print(response.posts.length);
    setState(() {
      search = response;
    });
  }

  void onChange() {
    print("the text is ${searchController.text}");
    if (searchController.text.isNotEmpty) {
      setState(() {
        fetchSearch(searchController.text);

        mode = 1;
      });
    } else if (searchController.text.isEmpty) {
      setState(() {
        mode = 0;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final futureData = ref.watch(trendingFutureProvider);
    final history = ref.watch(histroyFutureProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                searchController.clear();
              },
              icon: const Icon(Icons.clear))
        ],
        title: TextFormField(
          style: AppTextStyles.primaryTextStyle,
          controller: searchController,
          onFieldSubmitted: (value) {
            saveSearchHistory(value);
            final arguements = {
              'search': search,
              'text': value,
            };
            Navigator.pushNamed(context, RouteClass.searchResultsScreen,
                arguments: arguements);
          },
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
          child: mode == 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Communities",
                      style:
                          AppTextStyles.boldTextStyle.copyWith(fontSize: 15.sp),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: ClipOval(
                            child: search.subreddits[index].srLooks.icon != ''
                                ? Image.network(
                                    search.subreddits[index].srLooks.icon,

                                    fit: BoxFit.cover,
                                    width: 30
                                        .w, // You can adjust width and height to your needs
                                    height: 30.h,
                                  )
                                : SizedBox(
                                    width: 30,
                                    height: 30.h,
                                    child: Image.asset(
                                      'assets/images/Reddit_Icon_FullColor.png',
                                    ),
                                  ),
                          ),
                          title: Text(
                            "r/${search.subreddits[index].name}",
                            style: AppTextStyles.boldTextStyle
                                .copyWith(fontSize: 15.sp),
                          ),
                          onTap: () {
                            print(userId);
                            print(search.subreddits[index].name);
                            Navigator.pushNamed(
                                context, RouteClass.communityScreen,
                                arguments: {
                                  'id': search.subreddits[index].name,
                                  'uid': " "
                                });
                          },
                        );
                      },
                      itemCount: search.subreddits.length,
                    ),
                  ],
                )
              : SingleChildScrollView(
                child: Column(
                    children: [
                      history.when(
                          data: (data) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    final arguements = {
                                      'search': search,
                                      'text': data[index],
                                    };
                                    Navigator.pushNamed(
                                        context, RouteClass.searchResultsScreen,
                                        arguments: arguements);
                                  },
                                  title: Text(
                                    "${data[index]}",
                                    style: AppTextStyles.primaryTextStyle,
                                  ),
                                );
                              },
                              itemCount: data.length,
                            );
                          },
                          error: ((error, stackTrace) => Center(
                              child: Text("Error is ${error.toString()}"))),
                          loading: () => Center(
                                child: Lottie.asset(
                                  'assets/animation/loading.json',
                                  repeat: true,
                                ),
                              )),
                      futureData.when(
                          data: (data) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    final arguements = {
                                      'search': search,
                                      'text': data[index].title,
                                    };
                                    Navigator.pushNamed(
                                        context, RouteClass.searchResultsScreen,
                                        arguments: arguements);
                                  },
                                  title: Text(
                                    "${data[index].title}",
                                    style: AppTextStyles.primaryTextStyle,
                                  ),
                                  subtitle: Text(
                                    "${data[index].subtitle}",
                                    style: AppTextStyles.primaryTextStyle,
                                  ),
                                );
                              },
                              itemCount: data.length,
                            );
                          },
                          error: ((error, stackTrace) => Center(
                              child: Text("Error is ${error.toString()}", style: AppTextStyles.primaryTextStyle,))),
                          loading: () => Center(
                                child: Lottie.asset(
                                  'assets/animation/loading.json',
                                  repeat: true,
                                ),
                              )),
                    ],
                  ),
              )),
    );
  }
}
