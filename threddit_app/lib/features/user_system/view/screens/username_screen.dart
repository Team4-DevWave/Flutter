import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/view/widgets/register_appbar.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class UserName extends StatelessWidget {
  const UserName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RegisterAppBar(action: () {}, title: 'Skip'),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
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
                            'UsernameScreen...',
                            style: AppTextStyles.primaryTextStyle.copyWith(
                              fontSize: 28.spMin,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 25.h),
                          SizedBox(height: 15.h),
                          SizedBox(height: 13.h),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
