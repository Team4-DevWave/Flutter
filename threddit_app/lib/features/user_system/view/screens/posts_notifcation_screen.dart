import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/model/notification_settings_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view/widgets/enable_setting.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view/widgets/slider_container.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/theme/colors.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:threddit_clone/theme/text_styles.dart';
/// This is a template screen for either Posts with comments, posts with upvoets or reports comments and posts mod notifications.
/// it chooses the type it will be depending on the [String] title given and an [int] type.
/// 
/// 
/// This allows users to configure notification settings in a specific subreddit. 
/// Users can enable or disable notifications, customize advanced settings, the advanced settings allows the users to interact with the slider/not interact.
/// and set thresholds for notifications based on post activity.
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

  void checkTitle() {}
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
              bool isOn = false;
              switch (widget.title) {
                case "Posts with Comments":
                  settingsComments = isEnabled
                      .subredditsUserMods[widget.subredditName]!
                      .activity
                      .postsWithComments;
                  type = 0;
                  number = settingsComments.numberOfComments.toDouble();
                  isOn = settingsComments.advancedSetup;
                  break;
                case "Posts with Upvotes":
                  settingsActivity = isEnabled
                      .subredditsUserMods[widget.subredditName]!
                      .activity
                      .postsWithUpvotes;
                  type = 1;
                  number = settingsActivity.numberOfUpvotes.toDouble();
                  isOn = settingsActivity.advancedSetup;
                  break;
                case 'Posts':
                  settingsReport = isEnabled
                      .subredditsUserMods[widget.subredditName]!.reports.posts;
                  type = 2;
                  number = settingsReport.numberOfReports.toDouble();
                  isOn = settingsReport.advancedSetup;
                case 'Comments':
                  settingsReport = isEnabled
                      .subredditsUserMods[widget.subredditName]!
                      .reports
                      .comments;
                  type = 3;
                  number = settingsReport.numberOfReports.toDouble();
                  isOn = settingsReport.advancedSetup;
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
                        enable: type == 0
                            ? () => activitypostWithComments(
                                subredditName: widget.subredditName,
                                settingName: "")
                            : type == 1
                                ? () => activitypostWithUpvotes(
                                    subredditName: widget.subredditName,
                                    settingName: "")
                                : type == 2
                                    ? () => reportPostModNotification(
                                        subredditName: widget.subredditName,
                                        settingName: "")
                                    : () => reportCommentModNotification(
                                        subredditName: widget.subredditName,
                                        settingName: "")),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text("Advanced Setup"),
                      titleTextStyle: AppTextStyles.primaryTextStyle,
                      trailing: Switch(
                        activeColor: const Color.fromARGB(255, 1, 61, 110),
                        value: isOn,
                        onChanged: type == 0
                            ? (value) {
                                activitypostWithComments(
                                        subredditName: widget.subredditName,
                                        settingName: "advancedSetup")
                                    .then((value) => setState(() {}));
                              }
                            : type == 1
                                ? (value) {
                                    activitypostWithUpvotes(
                                            subredditName: widget.subredditName,
                                            settingName: "advancedSetup")
                                        .then((value) => setState(() {}));
                                  }
                                : type == 2
                                    ? (value) {
                                        reportPostModNotification(
                                                subredditName:
                                                    widget.subredditName,
                                                settingName: "advancedSetup")
                                            .then((value) => setState(() {}));
                                      }
                                    : (value) {
                                        reportCommentModNotification(
                                                subredditName:
                                                    widget.subredditName,
                                                settingName: "advancedSetup")
                                            .then((value) => setState(() {}));
                                      },
                      ),
                    ),
                    SliderContainer(number: number, isOn: isOn, type: type, subredditName: widget.subredditName),
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
