import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
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

  void onProfile(String username) {
    ref.watch(sharedPostProvider.notifier).setDestination("");
    Navigator.pushReplacementNamed(context, RouteClass.crossPost);
  }

  void onCommunity(String community) {
    ref.watch(sharedPostProvider.notifier).setDestination(community);
    Navigator.pushReplacementNamed(context, RouteClass.crossPost);
  }

  void onExit() {
    ref.watch(popCounter.notifier).update((state) => state = state - 1);
    Navigator.pop(context);
  }

  Future<void> _fetchCommunities() async {
    setState(() {
      _isLoading = true;
    });
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
                      size: 27.sp, color: AppColors.whiteColor),
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
                        onProfile('She3bo');
                      },
                      leading: Icon(Icons.account_circle,
                          size: 38.sp, color: AppColors.whiteColor),
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
                          onCommunity(community[0]);
                        },
                        leading: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(community[0]),
                        ),
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
