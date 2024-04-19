import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/favourites_provider.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommunitiesTiles extends ConsumerStatefulWidget {
  const CommunitiesTiles({super.key, required this.title});
  final String title;
  @override
  ConsumerState<CommunitiesTiles> createState() => _CommunitiesTilesState();
}

class _CommunitiesTilesState extends ConsumerState<CommunitiesTiles> {
  List<List<String>>? _userCommunitiesData;
  List<String>? _favouritesList;
  Map<String, bool>? _isFavouriteSub;
  bool isLoading = false;

  @override
  void initState() {
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
        _updateIsFavouriteSub();
        isLoading = false;
      });
    });
  }

  Future<void> _getFavourites() async {
    prefs = await SharedPreferences.getInstance();
    _favouritesList = prefs?.getStringList(PrefConstants.favourites) ?? [];
    ref
        .read(favouriteListProvider.notifier)
        .update((state) => _favouritesList!);
  }

  Future<void> _updateIsFavouriteSub() async {
    if (_favouritesList != null) {
      _isFavouriteSub = {};
      for (final value in _userCommunitiesData!) {
        _isFavouriteSub![value[0]] = _favouritesList!.contains(value[0]);
      }
    }
  }

  void _removeFavourites(String toBeRemoved) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      _favouritesList?.removeWhere((element) => element == toBeRemoved);
      prefs!.setStringList(PrefConstants.favourites, _favouritesList!);
      ref
          .read(favouriteListProvider.notifier)
          .update((state) => _favouritesList!);
    }
  }

  void _setFavourites(String favourite) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      _favouritesList?.add(favourite);
      prefs!.setStringList(PrefConstants.favourites, _favouritesList!);
      ref
          .read(favouriteListProvider.notifier)
          .update((state) => _favouritesList!);
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
    return ExpansionTile(
        title: Text(
          widget.title,
          style: AppTextStyles.primaryTextStyle,
        ),
        children: [
          if (!isLoading)
            ..._userCommunitiesData!.map((community) => ListTile(
                  onTap: () {
                    ///go to the community/user's profile screen
                    Navigator.pushNamed(context, RouteClass.communityScreen,
                        arguments: {
                          'id': community[0],
                          'uid': ref.read(userModelProvider)?.id
                        });
                  },
                  leading: CircleAvatar(
                    radius: 10,
                    backgroundImage: NetworkImage(community[1]),
                  ),
                  title: Text(community[0],
                      style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 17.spMin,
                      )),
                  trailing: IconButton(
                    onPressed: () => _onStarPressed(community[0]),
                    icon: _isFavouriteSub?[community[0]] == false
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
                ))
        ]);
  }
}
