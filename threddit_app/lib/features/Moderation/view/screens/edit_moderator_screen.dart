import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/features/user_system/view/widgets/email_form.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

bool? fullPermissions = false;
Map<String, bool?> modPermissions = {
  'access': false,
  'config': false,
  'flair': false,
  'chatConfig': false,
  'mail': false,
  'posts': false,
  'wiki': false,
  'chatOperator': false,
};

class EditModeratorScreen extends ConsumerStatefulWidget {
  final String moderator;
  const EditModeratorScreen({super.key, required this.moderator});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditModeratorScreenState();
}

class _EditModeratorScreenState extends ConsumerState<EditModeratorScreen> {
  final EmailForm usernameForm = EmailForm("username");
  final client = http.Client();
  void setAllPermissions(bool? value) {
    setState(() {
      modPermissions.forEach((key, _) {
        modPermissions[key] = value;
      });
    });
  }

  void checkPermissions() {
    if (modPermissions.values.every((value) => value == true)) {
      setState(() {
        fullPermissions = true;
      });
    } else {
      setState(() {
        fullPermissions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final String username = usernameForm.enteredEmail;

                int statusCode =
                    await ref.watch(moderationApisProvider.notifier).editMod(
                          client: client,
                          username: username,
                          permissions: modPermissions,
                          fullPermissions: fullPermissions,
                        );
                setState(() {
                  ref
                      .watch(moderationApisProvider.notifier)
                      .getMods(client: client);
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.update))
        ],
        title: const Text(
          "Edit permissions",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 5.w),
              child: Text("Username", style: AppTextStyles.primaryTextStyle),
            ),
            ListTile(
              title: Text(
                "u/${widget.moderator}",
                style: AppTextStyles.primaryTextStyle,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.w, top: 10.h),
              child: Text("Permissions", style: AppTextStyles.primaryTextStyle),
            ),
            CheckboxListTile(
                title: Text(
                  "Full permissions",
                  style: AppTextStyles.secondaryTextStyle,
                ),
                value: fullPermissions,
                onChanged: (value) {
                  setState(() {
                    fullPermissions = value;
                  });
                  setAllPermissions(value);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CheckboxListTile(
                      title: Text(
                        "Access",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      value: modPermissions['access'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          modPermissions['access'] = value;
                        });
                        checkPermissions();
                      }),
                ),
                Expanded(
                  child: CheckboxListTile(
                      title: Text(
                        "Mail",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      value: modPermissions['mail'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          modPermissions['mail'] = value;
                        });
                        checkPermissions();
                      }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CheckboxListTile(
                      title: Text(
                        "Config",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      value: modPermissions['config'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          modPermissions['config'] = value;
                        });
                        checkPermissions();
                      }),
                ),
                Expanded(
                  child: CheckboxListTile(
                      title: Text(
                        "Posts",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      value: modPermissions['posts'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          modPermissions['posts'] = value;
                        });
                        checkPermissions();
                      }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CheckboxListTile(
                      title: Text(
                        "Flair",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      value: modPermissions['flair'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          modPermissions['flair'] = value;
                        });
                        checkPermissions();
                      }),
                ),
                Expanded(
                  child: CheckboxListTile(
                      title: Text(
                        "Wiki",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      value: modPermissions['wiki'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          modPermissions['wiki'] = value;
                        });
                        checkPermissions();
                      }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CheckboxListTile(
                      title: Text(
                        "Chat config",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      value: modPermissions['chatConfig'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          modPermissions['chatConfig'] = value;
                        });
                        checkPermissions();
                      }),
                ),
                Expanded(
                  child: CheckboxListTile(
                      title: Text(
                        "Chat operator",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      value: modPermissions['chatOperator'] ?? false,
                      onChanged: (value) {
                        setState(() {
                          modPermissions['chatOperator'] = value;
                        });
                        checkPermissions();
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
