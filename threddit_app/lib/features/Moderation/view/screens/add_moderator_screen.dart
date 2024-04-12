import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class AddModeratorScreen extends ConsumerStatefulWidget {
  const AddModeratorScreen({super.key});
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddModeratorScreenState();
}

/// Validator function
/// Checks for the necessary checks and if not true returns a number
/// 3 for name is empty
/// 0 if all checks pass
int validateAddModerator(String name) {
  if (name == "") {
    return 3;
  } else {
    return 0;
  }
}

class _AddModeratorScreenState extends ConsumerState<AddModeratorScreen> {
  final EmailForm usernameForm = EmailForm("username");
  final client = http.Client();
  void setAllPermissions(bool? value) {
    setState(() {
      modPermissions.forEach((key, _) {
        modPermissions[key] = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final String username = usernameForm.enteredEmail;
                int validationValue = validateAddModerator(username);
                print(validationValue);
                switch (validationValue) {
                  case 0:
                    print(username);
                    int statusCode = await ref
                        .watch(moderationApisProvider.notifier)
                        .modUser(
                          client: client,
                          username: username,
                          permissions: modPermissions,
                        );
                    print(statusCode);
                    setState(() {
                      ref
                          .watch(moderationApisProvider.notifier)
                          .getMods(client: client);
                    });
                    Navigator.pop(context);

                  case 3:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please type a user name")),
                    );
                }
              },
              icon: Icon(Icons.add))
        ],
        title: const Text(
          "Add an approved user",
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
            usernameForm,
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
