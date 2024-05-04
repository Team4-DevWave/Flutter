import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/Moderation/view_model/community_types.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommunityTypes extends ConsumerStatefulWidget {
  const CommunityTypes({super.key});

  @override
  ConsumerState<CommunityTypes> createState() => _CommunityTypesState();
}

class _CommunityTypesState extends ConsumerState<CommunityTypes> {
  double _currentValue = 0;
  bool _switchValue = false;
  List<String> values = ["Public", "Restricted", "Private"];
  List<String> description = [
    "Anyone can see and participate in this community.",
    "Anyone can see, join, or vote in this community, but you can control who posts and comments",
    "Only people you approve can see and participate in this community"
  ];
  bool isAnythingChanged = false;
  bool isLoading = true;
  int?initRestriction;
  bool?initIsAdult;

  void _getData()async {
    setState(() {
      isLoading = true;
    });
    final response = await ref.read(communityTypesProvider.notifier).getCommunityTypes();
    response.fold((l) => showSnackBar(navigatorKey.currentContext!, l.message), 
    (r) {
      setState(() {
        initRestriction = r.restriction;
        initIsAdult = r.isAdult;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Community Types",
          style: AppTextStyles.primaryTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () {
              //send data
            },
            child: Text(
              "Save",
              style: AppTextStyles.primaryButtonHideTextStyle,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Slider(
            value: _currentValue,
            divisions: 2,
            max: 2,
            activeColor: _currentValue == 0.0
                ? Colors.green
                : _currentValue == 1.0
                    ? Colors.yellow
                    : Colors.red,
            onChanged: (double val) {
              setState(() {
                  _currentValue = val;
                if (_currentValue != initRestriction) {
                  isAnythingChanged = true;
                }
                else
                {
                  isAnythingChanged = false;
                }
              });
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  values[_currentValue.toInt()],
                  style: TextStyle(
                      color: _currentValue == 0.0
                          ? Colors.green
                          : _currentValue == 1.0
                              ? Colors.yellow
                              : Colors.red,
                      fontSize: 25.spMin,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  description[_currentValue.toInt()],
                  style: AppTextStyles.primaryButtonHideTextStyle,
                ),
                SizedBox(height: 10.h),
                const Divider()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "18+ community",
                  style: AppTextStyles.boldTextStyle,
                ),
                Switch(
                    value: _switchValue,
                    activeColor: AppColors.blueColor,
                    onChanged: (bool val) {
                      setState(() {
                        _switchValue = val;
                        if (_switchValue != initIsAdult) {
                          isAnythingChanged = true;
                        }
                        else{
                          isAnythingChanged = false;
                        }
                      });
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
