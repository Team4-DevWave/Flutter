import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class ChooseCommunity extends ConsumerStatefulWidget {
  const ChooseCommunity({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseCommunityState();
}

class _ChooseCommunityState extends ConsumerState<ChooseCommunity> {
  List<List<String>> _communitiesData = [[]];
  bool _isLoading = false;
  String userPic = "";

  void onProfile() {
    ref.read(sharedPostProvider.notifier).setDestination("");
    ref
        .read(shareProfilePic.notifier)
        .update((state) => ref.read(userModelProvider)?.profilePicture ?? "");
    Navigator.pushReplacementNamed(context, RouteClass.crossPost);
  }

  void onCommunity(String community, String communityPic) {
    ref.read(sharedPostProvider.notifier).setDestination(community);
    ref.read(shareProfilePic.notifier).update((state) => communityPic);
    Navigator.pushReplacementNamed(context, RouteClass.crossPost);
  }

  void onExit() {
    ref.read(popCounter.notifier).update((state) => state = state - 1);
    Navigator.pop(context);
  }

  Future<void> _fetchCommunities() async {
    setState(() {
      _isLoading = true;
    });
    userPic = ref.read(userModelProvider)?.profilePicture ?? "";
    final response =
        await ref.read(userCommunitisProvider.notifier).getUserCommunities();
    response.fold(
      (failure) => showSnackBar(navigatorKey.currentContext!, failure.message),
      (list) => setState(() {
        _isLoading = false;
        _communitiesData = list;
      }),
    );
  }

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _fetchCommunities();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Loading()
        : PopScope(
            onPopInvoked: (_) => onExit,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: onExit,
                  icon: Icon(Icons.close,
                      size: 27.spMin, color: AppColors.whiteColor),
                ),
                backgroundColor: AppColors.backgroundColor,
                title: Text(
                  'Choose a community',
                  style: AppTextStyles.primaryTextStyle
                      .copyWith(fontSize: 24.spMin),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    const SettingsTitle(title: 'PROFILE'),
                    SizedBox(height: 5.h),
                    ListTile(
                      onTap: () {
                        onProfile();
                      },
                      leading: userPic == ""
                          ? CircleAvatar(
                              radius: 15.r,
                              backgroundImage:
                                  const AssetImage(Photos.profileDefault))
                          : CircleAvatar(
                              radius: 15.r,
                              backgroundImage: NetworkImage(userPic)),
                      title: Text("My profile",
                          style: AppTextStyles.primaryTextStyle.copyWith(
                            fontSize: 20.spMin,
                          )),
                      titleTextStyle: AppTextStyles.primaryTextStyle,
                    ),
                    SizedBox(height: 10.h),
                    const SettingsTitle(title: 'JOINED'),
                    SizedBox(height: 5.h),
                    ..._communitiesData.map(
                      (community) => ListTile(
                        onTap: () {
                          onCommunity(community[0], community[1]);
                        },
                        leading: community[1].isEmpty
                            ? CircleAvatar(
                                radius: 15.r,
                                backgroundImage:
                                    const AssetImage(Photos.communityDefault))
                            : CircleAvatar(
                                radius: 15.r,
                                backgroundImage: NetworkImage(community[1])),
                        title: Text(community[0],
                            style: AppTextStyles.primaryTextStyle.copyWith(
                              fontSize: 20.spMin,
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
