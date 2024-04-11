import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/interests_data.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_button.dart';
import 'package:threddit_clone/features/user_system/view/widgets/interest_button.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/features/user_system/view_model/auth.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class Interests extends ConsumerStatefulWidget {
  const Interests({super.key});

  @override
  ConsumerState<Interests> createState() => _InterestsState();
}

class _InterestsState extends ConsumerState<Interests> {
  bool _isLoading = false;
  final List<String> _selectedInterests = [];

  void _toggleInterest(String value) {
    setState(() {
      if (_selectedInterests.contains(value)) {
        _selectedInterests.remove(value);
      } else {
        _selectedInterests.add(value);
      }
    });
  }

  Future<void> onContinue() async {
    ref.watch(authProvider.notifier).saveUserInterests(_selectedInterests);
    final isGoogleAuthenticated = ref.watch(userProvider)!.isGoogle;

    final isSignedUp = isGoogleAuthenticated
        ? await ref.watch(authProvider.notifier).signUp()
        : await ref.watch(authProvider.notifier).signUpWithGoogle();

    isSignedUp.fold((failure) {
      showSnackBar(navigatorKey.currentContext!, failure.message);
    }, (signedUp) async {
      if (signedUp) {
        final isLoggedIn = isGoogleAuthenticated
            ? await ref.watch(authProvider.notifier).login()
            : await ref.watch(authProvider.notifier).loginWithGoogle();

        isLoggedIn.fold((loginFaliure) {
          showSnackBar(navigatorKey.currentContext!, loginFaliure.message);
        }, (loggedIn) {
          if (loggedIn) {
            showSnackBar(navigatorKey.currentContext!,
                'Logged you in as ${ref.watch(userProvider)!.username}');
            Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
                RouteClass.mainLayoutScreen, (Route<dynamic> route) => false);
          } else {
            showSnackBar(navigatorKey.currentContext!,
                'Something went wrong while trying to log you in. Please try to log in later!');
          }
        });
      } else {
        showSnackBar(navigatorKey.currentContext!,
            'Something went wrong while trying to sign you up. Please try to sign up later!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _isLoading = ref.watch(authProvider);
    return _isLoading
        ? const Loading()
        : Scaffold(
            appBar: RegisterAppBar(action: () => null, title: ''),
            body: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
              height: MediaQuery.of(context).size.height.h,
              width: MediaQuery.of(context).size.width.w,
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    'Interests',
                    style: AppTextStyles.primaryButtonGlowTextStyle.copyWith(
                      fontSize: 25.spMin,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Pick things you'd like to see in your home feed.",
                    style: AppTextStyles.primaryTextStyle.copyWith(
                      fontSize: 15.spMin,
                      color: AppColors.whiteHideColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: interestsList.length,
                      itemBuilder: (context, index) {
                        final interest = interestsList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Text(
                                interest.text,
                                style: AppTextStyles.primaryButtonGlowTextStyle
                                    .copyWith(
                                  fontSize: 17.spMin,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: interest.interestsFirstRow
                                        .map((interestName) {
                                      bool isSelected = _selectedInterests
                                          .contains(interestName);
                                      return Padding(
                                        padding: EdgeInsets.only(right: 1.w),
                                        child: InterestButton(
                                          answerText: interestName,
                                          isSelected: isSelected,
                                          onTap: () =>
                                              _toggleInterest(interestName),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: interest.interestsSecondRow
                                        .map((interestName) {
                                      bool isSelected = _selectedInterests
                                          .contains(interestName);
                                      return Padding(
                                        padding: EdgeInsets.only(right: 1.w),
                                        child: InterestButton(
                                          answerText: interestName,
                                          isSelected: isSelected,
                                          onTap: () =>
                                              _toggleInterest(interestName),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
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
                      isOn: _selectedInterests.isNotEmpty,
                      onPressed:
                          _selectedInterests.isNotEmpty ? onContinue : null,
                      identifier: 'Continue',
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
