import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/Moderation/view/widgets/input_form.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

enum BanType { permenant, custom }

class BanScreen extends ConsumerStatefulWidget {
  const BanScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BanScreenState();
}

/// Validator function
/// Checks for the necessary checks and if not true returns a number
/// 1 for rule not chose
/// 2 for ban length == 0(custom ban and the length = 0)
/// 3 for name is empty
/// 0 if all checks pass
int validateBan(String name, String rule, String length) {
  if (rule == "Select a rule") {
    return 1;
  } else if (length == "0") {
    return 2;
  } else if (name == "") {
    return 3;
  } else {
    return 0;
  }
}

class _BanScreenState extends ConsumerState<BanScreen> {
  final InputForm usernameForm = InputForm("username");
  final InputForm banLengthForm = InputForm("Ban length (days)");
  final InputForm messageForm = InputForm("Message to user");
  final InputForm modForm = InputForm("Mod note");
  final client = http.Client();
  BanType banView = BanType.permenant;
  String ruleBroken = "Select a rule";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final String username = usernameForm.input;
                final String banLength = banLengthForm.input;
                final String message = messageForm.input;
                final String modNote = modForm.input;
                int validationValue = validateBan(username, ruleBroken, banLength);
                switch (validationValue) {
                  case 0:
                    int statusCode = await ref
                        .watch(moderationApisProvider.notifier)
                        .banUser(
                            client: client,
                            username: username,
                            reason: ruleBroken,
                            length: banLength,
                            message: message,
                            modnote: modNote);
                    setState(() {
                      ref
                          .watch(moderationApisProvider.notifier)
                          .getBannedUsers(client: client);
                    });
                    Navigator.pop(context);
                  case 1:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please choose a reason")),
                    );
                  case 2:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Please make sure length is not equal zero")),
                    );

                  case 3:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please type a user name")),
                    );
                }
              },
              icon: const Icon(Icons.add))
        ],
        title: const Text(
          "Add a banned user",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10.h),
              child: Text("Username", style: AppTextStyles.boldTextStyle),
            ),
            usernameForm,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.h),
              child: Text("Rule broken", style: AppTextStyles.boldTextStyle),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: Text(ruleBroken),
              titleTextStyle: AppTextStyles.primaryTextStyle,
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: AppColors.backgroundColor,
                  context: context,
                  builder: (context) => Wrap(
                    children: [
                      RadioListTile<String>(
                        title: Text(
                          "Spam",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                        value: "Spam",
                        groupValue: ruleBroken,
                        onChanged: (value) => setState(() {
                          ruleBroken = value!;
                          Navigator.pop(context);
                        }),
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "Personal and confidential information",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                        value: "Personal and confidential information",
                        groupValue: ruleBroken,
                        onChanged: (value) => setState(() {
                          ruleBroken = value!;
                          Navigator.pop(context);
                        }),
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "Threatening, harrasing, or inciting violence",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                        value: "Threatening, harrasing, or inciting violence",
                        groupValue: ruleBroken,
                        onChanged: (value) => setState(() {
                          ruleBroken = value!;
                          Navigator.pop(context);
                        }),
                      ),
                    ],
                  ),
                );
              },
              trailing: const Icon(Icons.arrow_downward),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.h),
              child: Text("Ban length", style: AppTextStyles.boldTextStyle),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SegmentedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color.fromARGB(255, 139, 139, 139);
                      }
                      return const Color.fromARGB(255, 0, 0, 0);
                    },
                  ),
                ),
                segments: [
                  ButtonSegment(
                    value: BanType.permenant,
                    label: Text("Permenant",
                        style: AppTextStyles.secondaryTextStyle),
                  ),
                  ButtonSegment(
                      value: BanType.custom,
                      label: Text("Custom",
                          style: AppTextStyles.secondaryTextStyle)),
                ],
                selected: <BanType>{banView},
                onSelectionChanged: (Set<BanType> newSelection) {
                  setState(() {
                    banView = newSelection.first;
                  });
                },
              ),
            ),
            Builder(builder: (context) {
              if (banView == BanType.custom) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    banLengthForm,
                    Container(
                        margin: EdgeInsets.only(left: 20.w, bottom: 20.h),
                        child: Text(
                          "Required",
                          style: AppTextStyles.secondaryTextStyle,
                        ))
                  ],
                );
              }
              return const SizedBox();
            }),
            messageForm,
            modForm,
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.h),
                child: Text(
                  "Only seen by mods",
                  style: AppTextStyles.secondaryTextStyle,
                )),
          ],
        ),
      ),
    );
  }
}
