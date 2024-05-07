import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/favourite_model.dart';
import 'package:threddit_clone/features/home_page/view_model/favrourite_notifier.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommunitiesTiles extends ConsumerStatefulWidget {
  const CommunitiesTiles({super.key, required this.title});
  final String title;
  @override
  ConsumerState<CommunitiesTiles> createState() => _CommunitiesTilesState();
}

class _CommunitiesTilesState extends ConsumerState<CommunitiesTiles> {
  List<List<String>>? _userCommunitiesData;
  bool isLoading = false;
  bool isStarLoading = false;
  List<Favourite> favouriteData = [];
  String pressedOn = "";

  void _setData() {
    favouriteData = ref.read(favouriteList);
  }

  Future<void> _onPress(List<String> community) async {
    setState(() {
      isStarLoading = true;
    });
    final Favourite favItem =
        Favourite(community[0], PrefConstants.subredditType, community[1]);
    ref.read(favouriteProvider.notifier).updateItem(favItem);

    if (favouriteData.any((item) => item.username == community[0])) {
      await ref.read(favouriteProvider.notifier).removeItem();
    } else {
      await ref.read(favouriteProvider.notifier).addItem();
    }

    setState(() {
      favouriteData = ref.read(favouriteList);
      isStarLoading = false;
    });
  }

  @override
  void initState() {
    _setData();
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    // Fetch user communities data
    setState(() {
      isLoading = true;
    });
    final response =
        await ref.read(userCommunitisProvider.notifier).getUserCommunities();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (list) {
      setState(() {
        _userCommunitiesData = list;
        isLoading = false;
      });
    });
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
            ..._userCommunitiesData!.map(
              (community) => ListTile(
                onTap: () {
                  //go to the community/user's profile screen
                  Navigator.pushNamed(context, RouteClass.communityScreen,
                      arguments: {
                        'id': community[0],
                        'uid': ref.read(userModelProvider)?.id
                      }).then((value) => Navigator.pop(context));
                },
                leading: community[1].isEmpty
                    ? CircleAvatar(
                        radius: 15.spMin,
                        backgroundImage:
                            const AssetImage(Photos.communityDefault))
                    : CircleAvatar(
                        radius: 15.spMin,
                        backgroundImage: NetworkImage(community[1])),
                title: Text(community[0],
                    maxLines: 1,
                    style: AppTextStyles.primaryTextStyle.copyWith(
                      fontSize: 17.spMin,
                    )),
                trailing: isStarLoading && pressedOn == community[0]
                    ? CircularProgressIndicator(
                        strokeWidth: 2.w,
                        color: AppColors.whiteColor,
                      )
                    : IconButton(
                        onPressed: () {
                          pressedOn = community[0];
                          _onPress(community);
                        },
                        icon: favouriteData
                                .any((item) => item.username == community[0])
                            ? const Icon(
                                Icons.star_rounded,
                                color: AppColors.whiteGlowColor,
                                size: 24,
                              )
                            : Icon(
                                Icons.star_border_rounded,
                                size: 24.spMin,
                              ),
                      ),
              ),
            )
        ]);
  }
}
