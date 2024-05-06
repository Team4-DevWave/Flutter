import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/gender_model.dart';
import 'package:threddit_clone/features/user_system/view/widgets/answer_button.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/features/user_system/view_model/auth.dart';
import 'package:threddit_clone/theme/button_styles.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class AboutYou extends ConsumerStatefulWidget {
  const AboutYou({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutYouState();
}

class _AboutYouState extends ConsumerState {
  bool _isLoading = false;
  final Map<String, ButtonStyle> _buttonStyles = {};

  @override
  void initState() {
    super.initState();
    for (var type in types) {
      _buttonStyles[type] = AppButtons.registerButtons;
    }
  }

  void onTap(String type) {
    setState(
      () {
        _buttonStyles[type] = AppButtons.selectedButtons;
      },
    );
    ref.watch(authProvider.notifier).saveGender(type);

    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.pushNamed(context, RouteClass.userNameScreen)
          .then((_) => setState(() {
                for (var type in types) {
                  _buttonStyles[type] = AppButtons.registerButtons;
                }
              }));
    });
  }

  void onSkip() {
    ref.watch(authProvider.notifier).saveGender(types[2]);
    Navigator.pushNamed(context, RouteClass.userNameScreen);
  }

  @override
  Widget build(BuildContext context) {
    _isLoading = ref.watch(authProvider);
    return _isLoading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: RegisterAppBar(action: onSkip, title: 'Skip'),
            body: Center(
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        'About you',
                        style: AppTextStyles.primaryTextStyle.copyWith(
                          fontSize: 28.spMin,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        """Tell us about yourself to improve your recommendations and ads""",
                        style: AppTextStyles.primaryTextStyle.copyWith(
                          fontSize: 20.spMin,
                          color: AppColors.whiteHideColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'How do you identify?',
                        style: AppTextStyles.primaryTextStyle.copyWith(
                          fontSize: 20.spMin,
                          color: AppColors.whiteHideColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 13.h),
                      ...types.map((type) {
                        return Column(
                          children: [
                            AnswerButton(
                                answerText: type,
                                style: _buttonStyles[type],
                                onTap: () => onTap(type)),
                            SizedBox(height: 5.h),
                          ],
                        );
                      }),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
