import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_following.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/models/data.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FollowingTiles extends StatefulWidget {
  const FollowingTiles({super.key, required this.title});
  final String title;
  @override
  State<FollowingTiles> createState() => _FollowingTilesState();
}

class _FollowingTilesState extends State<FollowingTiles> {
  late Future<List<String>> _userFollowingData;
  List<String>? _favouritesList;
  Map<String, bool>? _isFavouriteMap;

  void _getFavourites() async {
    prefs = await SharedPreferences.getInstance();

      _favouritesList = prefs?.getStringList(PrefConstants.favourites) ?? [];
      print(_favouritesList);
  }

  void _removeFavourites(String toBeRemoved) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      // _favouritesList = prefs!.getStringList(PrefConstants.favourites) ?? [];
        _favouritesList?.removeWhere((element) => element == toBeRemoved);
        prefs!.setStringList(PrefConstants.favourites, _favouritesList!);
    }
  }

  void _onStarPressed(String selected) {
    setState(() {
      if (_isFavouriteMap?[selected] == true) {
        _isFavouriteMap![selected] = false;
        _removeFavourites(selected);
      } else {
        _isFavouriteMap![selected] = true;
        _setFavourites(selected);
      }
    });
    print(_favouritesList);
    print(_isFavouriteMap);
  }

  void _setFavourites(String favourite) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      setState(() {
        // _favouritesList = prefs!.getStringList(PrefConstants.favourites)!;
        _favouritesList?.add(favourite);
        prefs!.setStringList(PrefConstants.favourites, _favouritesList!);
      });
    }
  }

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _userFollowingData = UserFollowingAPI().getUserFollowing();
    _getFavourites();
    _isFavouriteMap = {};
    super.initState();
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

                        /// There should be an icon with the data of following but it will be
                        /// implemented when the community class is made
                        onTap: () {
                          ///go to the user's profile screen
                          
                          //temporarily using this to go to a post screen //Aya
                          Navigator.pushNamed(context, RouteClass.postScreen,
                              arguments: {
                                'currentpost': posts[0],
                                'uid': 'user2',
                              });

                        },
                        trailing: IconButton(
                          onPressed: () => _onStarPressed(dataList[index]),
                          icon: _isFavouriteMap?[dataList[index]] ?? false
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
