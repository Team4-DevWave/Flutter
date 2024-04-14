import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_functions.dart';
import 'package:threddit_clone/features/user_system/view/widgets/email_form.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;
/// Class responsible for approving a user as a user in a locked subreddit. 
/// Takes the username of the user of the user you want to approve and
/// checks that the username isn't empty. Then adds him to the approved
/// users list.
class ApproveScreen extends ConsumerStatefulWidget {
  const ApproveScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ApproveScreenState();
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
                switch (validationValue) {
                  case 0:
                    int statusCode = await ref
                        .watch(moderationApisProvider.notifier)
                        .approveUser(
                          client: client,
                          username: username,
                        );
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
              icon: const Icon(Icons.add))
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
