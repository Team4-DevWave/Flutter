import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/model/notification_settings_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view/widgets/enable_setting.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/theme/colors.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

/// Notification screen has the options renders the options that the user
/// can use to turn on/off the notifcations he wants/doesn't want.
class PostsNotifcationScreen extends ConsumerStatefulWidget {
  final String title;
  final String subredditName;
  const PostsNotifcationScreen(
      {super.key, required this.title, required this.subredditName});

  @override
  ConsumerState<PostsNotifcationScreen> createState() =>
      _PostsNotifcationScreenState();
}

class _PostsNotifcationScreenState
    extends ConsumerState<PostsNotifcationScreen> {
  final client = http.Client();
  String? token;
  Future<NotificationsSettingsModel> isNotificationEnabled() async {
    setState(() {
      ref
          .watch(settingsFetchProvider.notifier)
          .getNotificationSetting(client: client);
    });
    return ref
        .watch(settingsFetchProvider.notifier)
        .getNotificationSetting(client: client);
  }

  @override
  void initState() {
    super.initState();
  }

  void toggleNotificationSettings(bool isEnabled) async {
    notificationOn(client: client, isEnabled: isEnabled, token: token!);
    setState(() {
      ref
          .watch(settingsFetchProvider.notifier)
          .getNotificationSetting(client: client);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<NotificationsSettingsModel>(
          future: isNotificationEnabled(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              final isEnabled = snapshot.data!;
              PostWithUpvotesActivity? settingsActivity;
              PostWithCommentsActivity? settingsComments;
              Report? settingsReport;
              int type = -1;
              double number = 0;
              switch (widget.title) {
                case "Posts with Comments":
                  settingsComments = isEnabled
                      .subredditsUserMods[widget.subredditName]!
                      .activity
                      .postsWithComments;
                  type = 0;
                  number = settingsComments.numberOfComments.toDouble();
                  break;
                case "Posts with Upvotes":
                  settingsActivity = isEnabled
                      .subredditsUserMods[widget.subredditName]!
                      .activity
                      .postsWithUpvotes;
                  type = 1;
                  number = settingsActivity.numberOfUpvotes.toDouble();
                  break;
                case 'Posts':
                  settingsReport = isEnabled
                      .subredditsUserMods[widget.subredditName]!.reports.posts;
                  type = 2;
                  number = settingsReport.numberOfReports.toDouble();
                case 'Comments':
                  settingsReport = isEnabled
                      .subredditsUserMods[widget.subredditName]!
                      .reports
                      .comments;
                  type = 2;
                  number = settingsReport.numberOfReports.toDouble();
                  break;
                default:
                  break;
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    EnableSetting(
                      isEnabled: type == 1
                          ? settingsActivity!.allowNotification
                          : type == 0
                              ? settingsComments!.allowNotification
                              : settingsReport!.allowNotification,
                      optionName: "Allow notifications",
                      settingIcon: Icons.notifications,
                      enable: () {},
                    ),
                    EnableSetting(
                      isEnabled: type == 1
                          ? settingsActivity!.advancedSetup
                          : type == 0
                              ? settingsComments!.advancedSetup
                              : settingsReport!.advancedSetup,
                      optionName: "Advanced Setup",
                      settingIcon: Icons.notifications,
                      enable: () {},
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.all(10.w),
                      alignment: Alignment.bottomCenter,
                      child: SfSlider(
                        min: 1,
                        max: type == 1 || type == 0 ? 5000 : 10,
                        showDividers: true,
                        showLabels: true,
                        value: number,
                        onChanged: type == 1
                            ? (settingsActivity!.advancedSetup
                                ? (value) {}
                                : null)
                            : type == 0
                                ? (settingsComments!.advancedSetup
                                    ? (value) {}
                                    : null)
                                : (settingsReport!.advancedSetup
                                    ? (value) {}
                                    : null),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
