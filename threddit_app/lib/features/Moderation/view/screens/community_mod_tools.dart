import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommunityModTools extends StatefulWidget {
  const CommunityModTools({super.key});
  @override
  State<CommunityModTools> createState() => _CommunityModToolsState();
}

void navigateTo(BuildContext context, String page) {
  if (page == "banned") {
    Navigator.pushNamed(context, RouteClass.bannedUsersScreen);
  } else if (page == "approved") {
    Navigator.pushNamed(context, RouteClass.approvedUsersScreen);
  } else if (page == "moderators") {
    Navigator.pushNamed(context, RouteClass.moderatorsScreen);
  }
}

class _CommunityModToolsState extends State<CommunityModTools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true, title: const Text('Mod Tools')),
        //body: Text('This is the mod tools screen', style: TextStyle(color: Colors.white),),
        body: ListView(
          children: [
            const SettingsTitle(title: "GENERAL"),
            ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Description"),
                titleTextStyle: AppTextStyles.primaryTextStyle,
                trailing: const Icon(Icons.navigate_next),
                onTap: () => ()),
            ListTile(
                leading: const FaIcon(FontAwesomeIcons.lock),
                title: const Text("Description"),
                titleTextStyle: AppTextStyles.primaryTextStyle,
                trailing: const Icon(Icons.navigate_next),
                onTap: () =>
                    (Navigator.pushNamed(context, RouteClass.description))),
            ListTile(
                leading: const Icon(
                  CupertinoIcons.doc_plaintext,
                  color: AppColors.whiteHideColor,
                ),
                title: const Text("Post types"),
                titleTextStyle: AppTextStyles.primaryTextStyle,
                trailing: const Icon(Icons.navigate_next),
                onTap: () =>
                    Navigator.pushNamed(context, RouteClass.postTypes)),
            SizedBox(height: 10.h),
            const SettingsTitle(title: "USER MANAGEMENT"),
            ListTile(
                leading: const FaIcon(FontAwesomeIcons.shield),
                title: const Text("Moderators"),
                titleTextStyle: AppTextStyles.primaryTextStyle,
                trailing: const Icon(Icons.navigate_next),
                onTap: () => navigateTo(context, "moderators")),
            ListTile(
                leading: const FaIcon(FontAwesomeIcons.check),
                title: const Text("Approved users"),
                titleTextStyle: AppTextStyles.primaryTextStyle,
                trailing: const Icon(Icons.navigate_next),
                onTap: () => navigateTo(context, "approved")),
            ListTile(
                leading: const FaIcon(FontAwesomeIcons.hammer),
                title: const Text("Banned users"),
                titleTextStyle: AppTextStyles.primaryTextStyle,
                trailing: const Icon(Icons.navigate_next),
                onTap: () => navigateTo(context, "banned")),
          ],
        ));
  }
}
