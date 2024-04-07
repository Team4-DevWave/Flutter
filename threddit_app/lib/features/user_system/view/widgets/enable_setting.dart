import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// Class responsible for making the enable setting for the notifcations
/// Which takes as parameters:
///
/// An option name, and a setting Icon.
class EnableSetting extends StatefulWidget {
  final String optionName;
  final IconData? settingIcon;
  const EnableSetting(this.optionName, this.settingIcon, {super.key});
  @override
  State<EnableSetting> createState() => _EnableSettingState();
}

class _EnableSettingState extends State<EnableSetting> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.settingIcon),
      title: Text(widget.optionName),
      titleTextStyle: AppTextStyles.primaryTextStyle,
      trailing: Switch(
          activeColor: const Color.fromARGB(255, 1, 61, 110),
          value: isEnabled,
          onChanged: (bool? value) {
            setState(() {
              isEnabled = value!;
            });
          }),
    );
  }
}
