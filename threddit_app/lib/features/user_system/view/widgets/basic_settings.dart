

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/screens/change_password_screen.dart';
import 'package:threddit_app/theme/text_styles.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_app/features/user_system/view/screens/update_email_screen.dart';

const List<String> genders = <String>['Man', 'Woman'];

class BasicSettings extends StatefulWidget {
  @override
  State<BasicSettings> createState() => _BasicSettingsState();
}

class _BasicSettingsState extends State<BasicSettings> {
  String pickedGender = genders.first;
  Country selectedCountry = Country.worldWide;
  void _selectBasicSetting(BuildContext context, String settingName) {
    if (settingName == "email") {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => UpdateEmailScreen()));
    } else if (settingName == "password") {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => ChangePasswordScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsTitle(title: "BASIC SETTINGS"),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Update email address"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          subtitle: const Text("xxxxxx@gmail.com"),
          trailing: const Icon(Icons.navigate_next),
          onTap: () {
            _selectBasicSetting(context, "email");
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Change password"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: const Icon(Icons.navigate_next),
          onTap: () {
            _selectBasicSetting(context, "password");
          },
        ),
        ListTile(
          leading: const Icon(Icons.location_pin),
          title: const Text("Country"),
          subtitle: Text(
              selectedCountry.displayName),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: const Icon(Icons.navigate_next),
          onTap: () {
            showCountryPicker(                
                context: context,
                onSelect: (Country country) {
                  setState(() {
                    selectedCountry = country;
                  });
                },
                countryListTheme: CountryListThemeData(
                    backgroundColor: AppColors.backgroundColor,
                    textStyle: AppTextStyles.primaryTextStyle));
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("Gender"),
          titleTextStyle: AppTextStyles.primaryTextStyle,
          trailing: DropdownButton(
            icon: const Icon(Icons.arrow_downward),
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
