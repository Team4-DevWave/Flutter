import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/view/widgets/email_form.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

class BlockUserScreen extends ConsumerStatefulWidget {
  const BlockUserScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BlockUserScreenState();
}

class _BlockUserScreenState extends ConsumerState<BlockUserScreen> {
  String? token;
  final EmailForm usernameForm = EmailForm("username");
  final client = http.Client();

  Future getUserToken() async {
    String? result = await getToken();
    setState(() {
      token = result!;
    });
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final String username = usernameForm.enteredEmail;

                await blockUser(
                  context: context,
                         userToBlock: username)
                    .then((value) {
                  if (value == 200) {
                    
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please type a user name")),
                    );
                  }
                });
              },
              icon: const Icon(Icons.add))
        ],
        title: const Text(
          "Block a user",
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
                  "This user will be blocked from your account",
                  style: AppTextStyles.secondaryTextStyle,
                )),
          ],
        ),
      ),
    );
  }
}
