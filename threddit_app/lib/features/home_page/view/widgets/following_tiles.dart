import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/home_page/view_model/favourites_provider.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_following.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FollowingTiles extends ConsumerStatefulWidget {
  const FollowingTiles({super.key, required this.title});
  final String title;
  @override
  ConsumerState<FollowingTiles> createState() => _FollowingTilesState();
}

class _FollowingTilesState extends ConsumerState<FollowingTiles> {
  Future<List<String>>? _userFollowingData;
  List<String>? _favouritesList;
  Map<String, bool>? _isFavouriteFollowing;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getFavourites();
    _userFollowingData = UserFollowingAPI().getUserFollowing();
    await _userFollowingData;
    _isFavouriteFollowing = {};
    _userFollowingData?.then((value) {
      for (String user in value) {
        _isFavouriteFollowing![user] = _favouritesList!.contains(user);
      }
      setState(() {});
    });
  }

  Future<void> _getFavourites() async {
    prefs = await SharedPreferences.getInstance();
    _favouritesList = prefs?.getStringList(PrefConstants.favourites) ?? [];
    (ref
        .read(favouriteListProvider.notifier)
        .update((state) => _favouritesList!));
  }

  Future<void> _updateIsFavouriteSub() async {
    if (_favouritesList != null) {
      _isFavouriteFollowing = {};
      _userFollowingData?.then((value) {
        for (String user in value) {
          _isFavouriteFollowing![user] = _favouritesList!.contains(user);
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
      (ref
          .read(favouriteListProvider.notifier)
          .update((state) => _favouritesList!));
    }
  }

  void _setFavourites(String favourite) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      _favouritesList?.add(favourite);
      prefs!.setStringList(PrefConstants.favourites, _favouritesList!);
      (ref
          .read(favouriteListProvider.notifier)
          .update((state) => _favouritesList!));
    }
  }

  void _onStarPressed(String selected) {
    setState(() {
      if (_isFavouriteFollowing?[selected] == true) {
        _isFavouriteFollowing![selected] = false;
        _removeFavourites(selected);
        _updateIsFavouriteSub();
      } else {
        _isFavouriteFollowing![selected] = true;
        _setFavourites(selected);
        _updateIsFavouriteSub();
      }
    });
  }

  @override
  void didChangeDependencies() {
    _favouritesList = ref.watch(favouriteListProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _userFollowingData,
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
                        onTap: () {
                        
                        },
                        trailing: IconButton(
                          onPressed: () => _onStarPressed(dataList[index]),
                          icon: _isFavouriteFollowing?[dataList[index]] == false
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
