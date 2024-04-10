import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommunityModTools extends StatefulWidget {
  const CommunityModTools({super.key});
  @override
  State<CommunityModTools> createState() => _CommunityModToolsState();
}

void navigateTo(BuildContext context, String page) {
  if (page == "banned") {
    Navigator.pushNamed(context, RouteClass.bannedUsersScreen);
  }
  else if (page == "approved") {
    Navigator.pushNamed(context, RouteClass.approvedUsersScreen);
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
            const SettingsTitle(title: "USER MANAGEMENT"),
            ListTile(
                leading: const FaIcon(FontAwesomeIcons.hammer),
                title: const Text("Banned users"),
                titleTextStyle: AppTextStyles.primaryTextStyle,
                trailing: const Icon(Icons.navigate_next),
                onTap: () => navigateTo(context, "banned")),
            ListTile(
                leading: const FaIcon(FontAwesomeIcons.check),
                title: const Text("Approved users"),
                titleTextStyle: AppTextStyles.primaryTextStyle,
                trailing: const Icon(Icons.navigate_next),
                onTap: () => navigateTo(context, "approved"))
          ],
        ));
  }
}
