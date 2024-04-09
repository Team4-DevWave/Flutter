import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// Class responsible for making the enable setting for the notifcations
/// Which takes as parameters:
///
/// An option name, and a setting Icon.
// ignore: must_be_immutable
class EnableSetting extends StatefulWidget {
  final String optionName;
  final IconData? settingIcon;
  final VoidCallback enable;
  bool isEnabled;
  EnableSetting(
      {required this.isEnabled,
      required this.optionName,
      required this.settingIcon,
      required this.enable,
      super.key});
  @override
  State<EnableSetting> createState() => _EnableSettingState();
}

class _EnableSettingState extends State<EnableSetting> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.settingIcon),
      title: Text(widget.optionName),
      titleTextStyle: AppTextStyles.primaryTextStyle,
      trailing: Switch(
          activeColor: const Color.fromARGB(255, 1, 61, 110),
          value: widget.isEnabled,
          onChanged: (bool? value) {
            setState(() {
              widget.isEnabled = value!;
              widget.enable();
            });
          }),
    );
  }
}
