import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/favourite_model.dart';
import 'package:threddit_clone/features/home_page/view_model/favrourite_notifier.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FavouriteTiles extends ConsumerStatefulWidget {
  const FavouriteTiles({super.key, required this.title});
  final String title;
  @override
  ConsumerState<FavouriteTiles> createState() => _FavouriteTilesState();
}

class _FavouriteTilesState extends ConsumerState<FavouriteTiles> {
  bool isLoading = false;
  List<Favourite> favouriteData = [];

  void _setData() {
    favouriteData = ref.read(favouriteList);
  }

  Future<void> _removeFromFavourite(Favourite favItem) async {
    ref.read(favouriteProvider.notifier).updateItem(favItem);
    await ref.read(favouriteProvider.notifier).removeItem();
  }

  @override
  void initState() {
    _setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    favouriteData = ref.watch(favouriteList);
    return ExpansionTile(
        title: Text(
          widget.title,
          style: AppTextStyles.primaryTextStyle,
        ),
        children: [
          if (!isLoading)
            ...favouriteData.map(
              (favourite) => ListTile(
                onTap: () {
                  //go to the community/user's profile screen
                  if (favourite.type == PrefConstants.userType) {
                    Navigator.pushNamed(context, RouteClass.otherUsers,
                        arguments: {
                          'username': favourite.username,
                        }).then((value) => Navigator.pop(context));
                  } else {
                    Navigator.pushNamed(context, RouteClass.communityScreen,
                        arguments: {
                          'id': favourite.username,
                          'uid': ref.read(userModelProvider)?.id
                        }).then((value) => Navigator.pop(context));
                  }
                },
                leading: favourite.imageUrl == ""
                    ? CircleAvatar(
                        radius: 15.spMin,
                        backgroundImage: AssetImage(
                            favourite.type == PrefConstants.userType
                                ? Photos.profileDefault
                                : Photos.communityDefault))
                    : CircleAvatar(
                        radius: 15.spMin,
                        backgroundImage: NetworkImage(favourite.imageUrl)),
                title: Text(favourite.username,
                    maxLines: 1,
                    style: AppTextStyles.primaryTextStyle.copyWith(
                      fontSize: 17.spMin,
                    )),
                trailing: IconButton(
                  onPressed: () async {
                    await _removeFromFavourite(favourite);
                    setState(() {
                      _setData();
                    });
                  },
                  icon: Icon(
                    Icons.star_rounded,
                    color: AppColors.whiteGlowColor,
                    size: 24.spMin,
                  ),
                ),
              ),
            )
        ]);
  }
}
