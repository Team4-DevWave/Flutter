import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_feed_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_user_unit.dart';
import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SearchUserWidget extends ConsumerStatefulWidget {
  final String searchText;
  const SearchUserWidget({super.key, required this.searchText});

  @override
  ConsumerState<SearchUserWidget> createState() => _SearchUserWidgetState();
}

class _SearchUserWidgetState extends ConsumerState<SearchUserWidget> {
  final _scrollController = ScrollController();
  final _users = <UserModelMe>[];
  int _currentPage = 1;
  bool _fetching = true;
  bool _fetchingFinish = true;
  String? userId;
  final List<String> tabs = ['Best', 'Hot', 'New', 'Top'];

  @override
  void initState() {
    super.initState();
    getUserID();
    _getUserData();

    _fetchUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getUserID() async {
    userId = await getUserId();
  }

  Future _fetchUsers() async {

    String searchValue = ref.read(selectedSortProvider);
    final response =
        await searchTest(widget.searchText, _currentPage, sorting: searchValue);

    final SearchModel results = response;
    print(results.users.length);

    if (results.users.isNotEmpty) {
      setState(() {
        _users.addAll(results.users);
        _currentPage++;
        _fetching = true;
        if (_users.length < 10) {
          _fetchingFinish = false;
        }
      });
    } else {
      setState(() {
        _fetching = false;
        _fetchingFinish = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchUsers();
    }
  }

  final List<String> _followingList = [];
  bool isLoading = false;
  UserModelMe? user;

  void _getUserData() async {
    user = await ref.read(settingsFetchProvider.notifier).getMe();
    setState(() {
      isLoading = true;
    });
    if (user != null && user!.followedUsers != null) {
      for (var followedUser in user!.followedUsers!) {
        String username = followedUser['username'];
        _followingList.add(username);
      }
    }
    isLoading = false;
    super.didChangeDependencies();
  }

  bool searchFollowed(String username) {
    for (int i = 0; i < _followingList.length; i++) {
      if (_followingList[i] == username) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedSortProvider, (previous, next) {
      setState(() {
        _users.clear();
        _currentPage = 1;
        _fetching = true;
        _fetchingFinish = true;
      });
      _fetchUsers();
    });
    if (_users.isEmpty) {
      if (_fetching || isLoading) {
        return Center(
          child: Lottie.asset(
            'assets/animation/loading2.json',
            repeat: true,
          ),
        );
      } else {
        return Center(
          child: Text(
            'No feed available.',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownMenu<String>(
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
            ),
            textStyle: AppTextStyles.primaryTextStyle,
            dropdownMenuEntries:
                tabs.map<DropdownMenuEntry<String>>((String string) {
              return DropdownMenuEntry(value: string, label: string);
            }).toList(),
            width: 150.w,
            initialSelection: ref.read(selectedSortProvider),
            onSelected: (String? value) {
              ref.read(selectedSortProvider.notifier).state = value!;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Changed to tab $value'),
                duration: Durations.short1,
              ));
            },
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _users.length + 1,
              itemBuilder: (context, index) {
                if (index < _users.length) {
                  if (searchFollowed(_users[index].username!)) {
                    return SearchUserUnit(
                      user: _users[index],
                      isFollowed: true,
                    );
                  } else {
                    return SearchUserUnit(
                      user: _users[index],
                      isFollowed: false,
                    );
                  }
                } else {
                  return _fetchingFinish
                      ? SizedBox(
                          height: 75.h,
                          width: 75.w,
                          child: Lottie.asset(
                            'assets/animation/loading2.json',
                            repeat: true,
                          ),
                        )
                      : SizedBox(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'No more users available.',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ));
                }
              },
            ),
          ),
        ],
      );
    }
  }
}
