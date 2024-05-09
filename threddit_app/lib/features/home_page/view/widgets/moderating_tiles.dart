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
/// A [StatefulWidget] that displays a list of communities where the user is a moderator. 
///
/// This widget uses the [ConsumerStatefulWidget] to access state management provided
/// by [Riverpod]. It fetches the list of communities from the [userCommunitisProvider]
/// and displays them in an [ExpansionTile]. 
///
/// Each community is represented by a [ListTile] with its icon, name, and a star 
/// icon to indicate if the user has favorited the community. 
class ModeratingTiles extends ConsumerStatefulWidget {
  /// Creates a [ModeratingTiles] widget.
  ///
  /// The [title] argument is required and specifies the title displayed in the 
  /// [ExpansionTile].
  const ModeratingTiles({super.key, required this.title});

  /// The title of the [ExpansionTile].
  final String title;

  @override
  ConsumerState<ModeratingTiles> createState() => _ModeratingTilesState();
}

/// The state class for [ModeratingTiles]. 
/// 
/// This class manages the data and UI state of the widget, including: 
/// - Fetching and storing the list of communities where the user is a moderator.
/// - Handling user interactions with the favorite star icon. 
/// - Building the UI based on the state. 
class _ModeratingTilesState extends ConsumerState<ModeratingTiles> {
  /// The list of communities where the user is a moderator. 
  /// 
  /// Each sub-list within this list contains the community name and icon. 
  List<List<String>>? _moderatingData;

  /// Indicates whether the community data is being loaded.
  bool isLoading = false;

  /// Indicates whether the favorite star icon is being updated. 
  bool isStarLoading = false;

  /// The list of the user's favorite communities.
  List<Favourite> favouriteData = []; 

  /// The name of the community the user is currently interacting with. 
  String pressedOn = ""; 

  /// Initializes the state by fetching the user's moderating communities and 
  /// setting the favorite data.
  @override
  void initState() {
    _setData();
    _initializeData();
    super.initState();
  }

  /// Sets the initial favorite data from the [favouriteList] provider. 
  void _setData() {
    favouriteData = ref.read(favouriteList);
  }

  /// Handles the press event on the favorite star icon. 
  /// 
  /// This method updates the [isStarLoading] state, creates a [Favourite] item 
  /// for the community, and either adds or removes the item from the user's 
  /// favorites depending on its current state. 
  ///
  /// [moderating] is a list containing the name and icon of the community. 
  Future<void> _onPress(List<String> moderating) async {
    setState(() {
      isStarLoading = true;
    });

    final Favourite favItem = 
        Favourite(moderating[0], PrefConstants.subredditType, moderating[1]);

    ref.read(favouriteProvider.notifier).updateItem(favItem); 

    if (favouriteData.any((item) => item.username == moderating[0])) {
      await ref.read(favouriteProvider.notifier).removeItem();
    } else {
      await ref.read(favouriteProvider.notifier).addItem(); 
    }

    setState(() {
      favouriteData = ref.read(favouriteList);
      isStarLoading = false;
    });
  }

  /// Fetches the user's moderating communities from the API. 
  /// 
  /// This method updates the [isLoading] state and sets the [_moderatingData] 
  /// upon successful retrieval of the communities. If an error occurs, it
  /// displays a snackbar with the error message. 
  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
    });

    final response = await ref.read(userCommunitisProvider.notifier).getUserModerating();

    response.fold(
      (failure) => showSnackBar(navigatorKey.currentContext!, failure.message), 
      (list) {
        setState(() {
          _moderatingData = list; 
          isLoading = false;
        });
      }); 
  }

  /// Builds the UI of the widget. 
  ///
  /// This method displays an [ExpansionTile] with the title specified in [widget.title]. 
  /// The children of the [ExpansionTile] are the list of communities where the user 
  /// is a moderator, displayed as [ListTile] widgets. 
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
          ..._moderatingData!.map(
            (mod) => ListTile(
              onTap: () {
                // Navigate to the community screen.
                Navigator.pop(context); 
                Navigator.pushNamed(
                  context, 
                  RouteClass.communityScreen, 
                  arguments: {
                    'id': mod[0], 
                    'uid': ref.read(userModelProvider)?.id
                  }); 
              },
              leading: mod[1].isEmpty 
                  ? CircleAvatar(
                      radius: 15.spMin, 
                      backgroundImage: const AssetImage(Photos.communityDefault))
                  : CircleAvatar(
                      radius: 15.spMin,
                      backgroundImage: NetworkImage(mod[1])),
              title: Text(
                mod[0], 
                maxLines: 1, 
                style: AppTextStyles.primaryTextStyle.copyWith(
                  fontSize: 17.spMin,
                )), 
              trailing: isStarLoading && pressedOn == mod[0]
                  ? CircularProgressIndicator(
                      strokeWidth: 2.w, 
                      color: AppColors.whiteColor,
                    )
                  : IconButton(
                      onPressed: () {
                        pressedOn = mod[0];
                        _onPress(mod);
                      }, 
                      icon: favouriteData.any((item) => item.username == mod[0])
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
      ],
    );
  }
}