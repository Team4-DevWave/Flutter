import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:threddit_app/features/user_system/view/screens/login_screen.dart';
import 'package:threddit_app/features/user_system/view/screens/update_email_screen.dart';
import 'package:threddit_app/features/user_system/view/widgets/app_agreement.dart';
import 'package:threddit_app/features/user_system/view/widgets/basic_settings.dart';
import 'package:threddit_app/features/user_system/view/widgets/connected_accounts.dart';
import 'package:threddit_app/features/user_system/view/widgets/contact_settings.dart';
import 'package:threddit_app/features/user_system/view/widgets/register_buttons.dart';
import 'package:threddit_app/features/user_system/view/widgets/safety.dart';
import 'package:threddit_app/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/photos.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final genders = [
  'Woman',
  'Man',
];

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Account Settings")),
        body: ListView(children: [
          BasicSettings(),
          ConnectedAccounts(),
          ContactSettings(),
          Safety(),
        ]));
  }
}
