import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/view/widgets/continue_button.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class UserName extends StatelessWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RegisterAppBar(action: () {}, title: 'Skip'),
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
                          SizedBox(height: 10.h),
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
                            "Reddit is annonymous, so your username is what yo'll go by here. Choose wisely-because once you get a name, you can't change it.",
                            style: AppTextStyles.primaryTextStyle.copyWith(
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 25.h),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixText: 'U/',
                              prefixStyle: AppTextStyles
                                  .primaryButtonGlowTextStyle
                                  .copyWith(fontSize: 28.spMin),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors
                                        .whiteGlowColor), // Color when focused
                              ),
                              // Add other decoration properties as needed
                            ),
                            cursorColor: AppColors.redditOrangeColor,
                            style: AppTextStyles.primaryButtonGlowTextStyle
                                .copyWith(fontSize: 28.spMin),
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
                  identifier: 'signup',
                  isOn: true, // isValid,
                  onPressed: () {}, //isValid ? onContinue : null,
                ),
              ),
            ],
          ),
        ));
  }
}
