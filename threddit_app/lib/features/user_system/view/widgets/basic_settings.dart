import 'package:flutter/material.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/theme/colors.dart';
const List<String> genders = <String>['Man', 'Woman'];

class BasicSettings extends StatefulWidget {
  @override
  State<BasicSettings> createState() => _BasicSettingsState();
}

class _BasicSettingsState extends State<BasicSettings> {
  String pickedGender = genders.first;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Update email address"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          subtitle: Text("xxxxxx@gmail.com"),
          trailing: Icon(Icons.navigate_next),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Change password"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: Icon(Icons.navigate_next),
        ),
        ListTile(
          leading: Icon(Icons.location_pin),
          title: Text("Country"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: Icon(Icons.navigate_next),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Gender"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: DropdownButton(
            icon: Icon(Icons.arrow_downward),
            onChanged: (String? value) {
              setState(() {
                pickedGender = value!;
              });
            },
            value: pickedGender,
            items: genders.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
