import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/Moderation/view/widgets/input_form.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/features/user_system/view/widgets/email_form.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

class ApproveScreen extends ConsumerStatefulWidget {
  const ApproveScreen({super.key});
  ConsumerState<ConsumerStatefulWidget> createState() => _ApproveScreenState();
}

/// Validator function
/// Checks for the necessary checks and if not true returns a number
/// 3 for name is empty
/// 0 if all checks pass
int validateApprove(String name) {
  if (name == "") {
    return 3;
  } else {
    return 0;
  }
}

class _ApproveScreenState extends ConsumerState<ApproveScreen> {
  final EmailForm usernameForm = EmailForm("username");
  final client = http.Client();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final String username = usernameForm.enteredEmail;
                int validationValue = validateApprove(username);
                print(validationValue);
                switch (validationValue) {
                  case 0:
                    print(username);
                    int statusCode = await ref
                        .watch(moderationApisProvider.notifier)
                        .approveUser(
                          client: client,
                          username: username,
                        );
                    print(statusCode);
                    setState(() {
                      ref
                          .watch(moderationApisProvider.notifier)
                          .getApprovedUsers(client: client);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: usernameForm,
            ),
            Container(
                margin: EdgeInsets.only(left: 20.w, bottom: 20.h),
                child: Text(
                  "This user will be able to submit ccontent to your community",
                  style: AppTextStyles.secondaryTextStyle,
                )),
          ],
        ),
      ),
    );
  }
}
