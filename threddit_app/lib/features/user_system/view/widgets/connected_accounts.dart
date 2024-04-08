import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';

/// Class responibile for the connected accounts part of the account settings:
/// Has connect google button
/// Should call the oAuth later.
class ConnectedAccounts extends ConsumerStatefulWidget {
  const ConnectedAccounts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectedAcccountsState();
}

class _ConnectedAcccountsState extends ConsumerState<ConnectedAccounts> {
  bool checkGoogle() {
    return ref.watch(userProvider)!.isGoogle;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SettingsTitle(title: "CONNECTED ACCOUNTS"),
      ListTile(
          leading: const ImageIcon(AssetImage("assets/images/google.png")),
          title: const Text("Google"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: checkGoogle()
              ? TextButton(
                  onPressed: () => ref
                      .watch(authControllerProvider.notifier)
                      .googleLogout(),
                  child: const Text(
                    "Disconnect",
                    style:  TextStyle(color: Colors.blue),
                  ))
              : TextButton(
                  onPressed: () => ref
                      .watch(authControllerProvider.notifier)
                      .connectWithGoogle(context),
                  child: const Text(
                    "Connect",
                    style: TextStyle(color: Colors.blue),
                  ))),
    ]);
  }
}
