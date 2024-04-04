import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_button.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/features/user_system/view_model/auth.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class UserName extends ConsumerStatefulWidget {
  const UserName({super.key});

  @override
  ConsumerState<UserName> createState() => _UserNameState();
}

class _UserNameState extends ConsumerState<UserName> {
  TextEditingController userNameController = TextEditingController();
  String? validationMessage;
  bool isUsedUserName = false;
  bool isValid = false;
  bool isLoading = false;

  void updateFormValidity(String? value) {
    setState(() {
      isValid = (value == null || value.isEmpty) ? false : true;
    });
  }

  Future<void> onContinue() async {
    isLoading = true;
    final isUsed = await ref
        .read(authProvider.notifier)
        .checkAvailability(userNameController.text);
    isLoading = false;
    if (isUsed) {
      userNameFormKey.currentState!.validate();
    } else {
      userNameFormKey.currentState!.validate();
      ref.read(authProvider.notifier).saveUserName(userNameController.text);
      Navigator.pushNamed(
          navigatorKey.currentContext!, RouteClass.interestsScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    isLoading = ref.watch(authProvider);

    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: RegisterAppBar(action: () => null, title: ''),
            body: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
              height: MediaQuery.of(context).size.height.h,
              width: MediaQuery.of(context).size.width.w,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                'Create your profile',
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                  fontSize: 18.spMin,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'Choose a username',
                                style: AppTextStyles.primaryButtonGlowTextStyle
                                    .copyWith(
                                  fontSize: 30.spMin,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15.h),
                              Text(
                                "Reddit is annonymous, so your username is what you'll go by here. Choose wisely-because once you get a name, you can't change it.",
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                  fontSize: 16.spMin,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 20.h),
                              Form(
                                key: userNameFormKey,
                                child: TextFormField(
                                  onChanged: (value) {
                                    return updateFormValidity(value);
                                  },
                                  controller: userNameController,
                                  decoration: InputDecoration(
                                    prefix: Text(
                                      "U/",
                                      style: AppTextStyles
                                          .primaryButtonGlowTextStyle
                                          .copyWith(fontSize: 28.spMin),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.whiteGlowColor,
                                      ),
                                    ),
                                  ),
                                  cursorColor: AppColors.redditOrangeColor,
                                  style: AppTextStyles
                                      .primaryButtonGlowTextStyle
                                      .copyWith(
                                    fontSize: 28.spMin,
                                  ),
                                  validator: (value) {
                                    isUsedUserName =
                                        ref.watch(isUserNameUsedProvider);
                                    if (isUsedUserName) {
                                      return "Sorry, this username is taken. Try another.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Text(
                                'This will be your name forever, so make sure it feels like you.',
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                  fontSize: 16.spMin,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.h),
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        const BoxDecoration(color: AppColors.backgroundColor),
                    child: ContinueButton(
                      identifier: 'username',
                      isOn: isValid,
                      onPressed: isValid ? onContinue : null,
                    ),
                  ),
                ],
              ),
            ));
  }
}
