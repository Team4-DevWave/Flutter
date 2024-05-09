import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_button.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/features/user_system/view_model/auth.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

bool updateFormValidity(String? value) {
  return (value == null || value.isEmpty || value.trim().isEmpty)
      ? false
      : true;
}

///This screen is designed and implemented to take and validate the user username
///in the registration process.
///
///It renders only one text field and a continue button that is enabled only
///when there is input in the text field
///
///When the continue button is pressed the value in the username text field is validated by
///checking if this username is free to be used, if so the username is saved to
///the user model provider and interest screen is pushed
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

  Future<void> onContinue() async {
    isLoading = true;
    final isUsed = await ref
        .read(authProvider.notifier)
        .checkUsernameAvailability(userNameController.text);
    isLoading = false;

    isUsed.fold((failure) {
      showSnackBar(navigatorKey.currentContext!, failure.message);
    }, (isUsernameUsed) {
      if (isUsernameUsed) {
        userNameFormKey.currentState!.validate();
      } else {
        userNameFormKey.currentState!.validate();
        ref.read(authProvider.notifier).saveUserName(userNameController.text);
        Navigator.pushNamed(
            navigatorKey.currentContext!, RouteClass.interestsScreen);
      }
    });
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
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
                                    setState(() {
                                      isValid = updateFormValidity(value);
                                    });
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
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors
                                            .whiteHideColor, // Use the same color as default
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
                      isOn: isValid,
                      onPressed: isValid ? onContinue : null,
                      identifier: 'Continue',
                    ),
                  ),
                ],
              ),
            ));
  }
}
