import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/Moderation/view_model/schedule_post.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SchedulingBottomSheet extends ConsumerStatefulWidget {
  const SchedulingBottomSheet({super.key});

  @override
  ConsumerState<SchedulingBottomSheet> createState() =>
      _SchedulingBottomSheetState();
}

class _SchedulingBottomSheetState extends ConsumerState<SchedulingBottomSheet> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  Color textColor() {
    DateTime selectedDateTime =
        DateTime(_date.year, _date.month, _date.day, _time.hour);
    DateTime currentDateTime = DateTime.now();
    if (selectedDateTime.isAfter(currentDateTime)) {
      return AppColors.whiteColor;
    } else {
      return AppColors.whiteHideColor;
    }
  }

  Color backgroundColor() {
    DateTime selectedDateTime =
        DateTime(_date.year, _date.month, _date.day, _time.hour);
    DateTime currentDateTime = DateTime.now();
    if (selectedDateTime.isAfter(currentDateTime)) {
      return AppColors.redditOrangeColor;
    } else {
      return const Color.fromARGB(255, 30, 31, 31);
    }
  }

  void scheduling() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.navigate_before),
                      color: AppColors.whiteGlowColor,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Schedule Post",
                      style: TextStyle(
                          color: AppColors.whiteGlowColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                backgroundColor())),
                        onPressed: () {
                          ref
                              .read(schedulePostProvider.notifier)
                              .updateRealDate(_date);
                          ref
                              .read(schedulePostProvider.notifier)
                              .updateRealTime(_time);
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: textColor()),
                        ))
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () async {
                    await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100))
                        .then((value) {
                      setState(() {
                        _date = value!;
                      });
                      if (_date != DateTime.now()) {
                        ref
                            .read(schedulePostProvider.notifier)
                            .updateDate(_date.toString());
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        "Start on date",
                        style: AppTextStyles.boldTextStyle
                            .copyWith(fontSize: 16.spMin),
                      ),
                      const Spacer(),
                      Text(
                        "${_date.day}/${_date.month}/${_date.year}",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () async {
                    await showTimePicker(
                      context: context,
                      initialTime: _time,
                    ).then((value) {
                      if (_time != TimeOfDay.now()) {
                        ref
                            .read(schedulePostProvider.notifier)
                            .updateTime(_time.toString());
                      }
                      setState(() {
                        _time = value!;
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        "Start on time ",
                        style: AppTextStyles.boldTextStyle
                            .copyWith(fontSize: 16.spMin),
                      ),
                      const Spacer(),
                      Text(
                        "${_time.hour} : ${_time.minute}",
                        style: AppTextStyles.secondaryTextStyle,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      const Icon(
                        Icons.watch_later_outlined,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Post Settings",
            style: AppTextStyles.boldTextStyle,
          ),
          SizedBox(
            height: 15.h,
          ),
          InkWell(
            onTap: () {
              setState(() {
                scheduling();
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.whiteGlowColor,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "Schedule Post",
                  style:
                      AppTextStyles.boldTextStyle.copyWith(fontSize: 16.spMin),
                ),
                const Spacer(),
                const Icon(
                  Icons.navigate_next,
                  color: AppColors.whiteGlowColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
