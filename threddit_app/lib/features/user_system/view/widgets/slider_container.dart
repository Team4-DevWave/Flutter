import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';

class SliderContainer extends StatefulWidget {
  double number;
  final bool isOn;
  final int type;
  final String subredditName;

  SliderContainer({
    Key? key,
    required this.number,
    required this.isOn,
    required this.type,
    required this.subredditName,
  }) : super(key: key);

  @override
  State<SliderContainer> createState() => _SliderContainerState();
}

class _SliderContainerState extends State<SliderContainer> {
  void _handleSliderEndChange(double value) {
    switch (widget.type) {
      case 1:
        activityUpvotesSlider(
          subredditName: widget.subredditName,
          value: value,
        ).then((_) => setState(() {}));
        break;
      case 0:
        activityCommentSlider(
          subredditName: widget.subredditName,
          value: value,
        ).then((_) => setState(() {}));
        break;
      case 2:
        reportPostsSlider(
          subredditName: widget.subredditName,
          value: value,
        ).then((_) => setState(() {}));
        break;
      default:
        reportCommentsSlider(
          subredditName: widget.subredditName,
          value: value,
        ).then((_) => setState(() {}));
    }
  }

  void _handleSliderChange(double value) {
    switch (widget.type) {
      case 1:
        setState(() {
          widget.number = value;
        });
        break;
      case 0:
        setState(() {
          widget.number = value;
        });
        break;
      case 2:
       setState(() {
          widget.number = value;
        });
        break;
      default:
        setState(() {
          widget.number = value;
        });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(10.w),
      alignment: Alignment.bottomCenter,
      child: SfSlider(
        stepSize: 1,
        enableTooltip: true,
        min: 1,
        max: widget.type == 1 || widget.type == 0 ? 5000 : 10,
        showDividers: true,
        showLabels: true,
        value: widget.number,
        onChanged: widget.isOn
            ? (value) {
                _handleSliderChange(value);
              }
            : null,
        onChangeEnd: widget.isOn
            ? (value) {
                _handleSliderEndChange(value);
              }
            : null,
      ),
    );
  }

  
}
