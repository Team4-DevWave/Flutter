import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/favourites_provider.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommunitiesTiles extends ConsumerStatefulWidget {
  const CommunitiesTiles({super.key, required this.title});
  final String title;
  @override
  ConsumerState<CommunitiesTiles> createState() => _CommunitiesTilesState();
}

class _CommunitiesTilesState extends ConsumerState<CommunitiesTiles> {
  Future<List<String>> ?_userCommunitiesData;
  List<String>? _favouritesList;
  Map<String, bool>? _isFavouriteSub;

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    // Fetch user communities data
  _userCommunitiesData = UserCommunitiesAPI().getUserCommunities();
  await _userCommunitiesData; // Wait for userFollowingData to be fetched
  _isFavouriteSub = {};
  _userCommunitiesData?.then((value) {
    for (String user in value) {
      _isFavouriteSub![user] = _favouritesList!.contains(user);
    }
    setState(() {}); // Trigger a rebuild after initializing data
  });
  }

  Future<void> _getFavourites() async {
    prefs = await SharedPreferences.getInstance();
    _favouritesList = prefs?.getStringList(PrefConstants.favourites) ?? [];
    print("alo from get sub");
    print(ref
        .read(favouriteListProvider.notifier)
        .update((state) => _favouritesList!));
  }

  // Future<void> _fetchUserCommunitiesData() async {
  //   _userCommunitiesData = UserCommunitiesAPI().getUserCommunities();
  //   // Wait for the user communities data to be fetched
  //   await _userCommunitiesData;
  // }

  Future<void> _updateIsFavouriteSub() async {
    if (_favouritesList != null) {
      _isFavouriteSub = {};
      _userCommunitiesData?.then((value) {
        for (String user in value) {
          _isFavouriteSub![user] = _favouritesList!.contains(user);
        }
      });
      setState(() {});
    }
  }

  void _removeFavourites(String toBeRemoved) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      _favouritesList?.removeWhere((element) => element == toBeRemoved);
      prefs!.setStringList(PrefConstants.favourites, _favouritesList!);
      print("alo from remove sub");
      print(ref
          .read(favouriteListProvider.notifier)
          .update((state) => _favouritesList!));
    }
  }

  void _setFavourites(String favourite) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      _favouritesList?.add(favourite);
      prefs!.setStringList(PrefConstants.favourites, _favouritesList!);
      print("alo from set sub");
      print(ref
          .read(favouriteListProvider.notifier)
          .update((state) => _favouritesList!));
    }
  }

  void _onStarPressed(String selected) {
    setState(() {
      if (_isFavouriteSub?[selected] == true) {
        _isFavouriteSub![selected] = false;
        _removeFavourites(selected);
        _updateIsFavouriteSub();
      } else {
        _isFavouriteSub![selected] = true;
        _setFavourites(selected);
        _updateIsFavouriteSub();
      }
    });
  }

  @override
  void didChangeDependencies() {
    // Fetch favorites list
    _getFavourites();
    //_favouritesList = ref.read(favouriteListProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _userCommunitiesData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<String> dataList = snapshot.data ?? [];
            return ExpansionTile(
              title: Text(
                widget.title,
                style: AppTextStyles.primaryTextStyle,
              ),
              children: [
                ListView.builder(
                  itemCount: dataList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: AppColors.whiteColor,
                      child: ListTile(
                        title: Text(dataList[index],
                            style: AppTextStyles.secondaryTextStyle
                                .copyWith(fontSize: 14)),

                        /// There should be an icon with the data of community but it will be
                        /// implemented when the community class is made
                        onTap: () {
                          ///go to the community/user's profile screen
                         
                        },
                        trailing: IconButton(
                          onPressed: () => _onStarPressed(dataList[index]),
                          icon: _isFavouriteSub?[dataList[index]] == false
                              ? const Icon(
                                  Icons.star_border_rounded,
                                  size: 24,
                                )
                              : const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.whiteGlowColor,
                                  size: 24,
                                ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          }
        });
  }
}
