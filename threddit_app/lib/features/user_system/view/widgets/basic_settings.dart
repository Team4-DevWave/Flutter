import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:threddit_clone/features/user_system/view/screens/change_password_screen.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:threddit_clone/features/user_system/view/screens/update_email_screen.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart';
import 'package:http/http.dart' as http;

const List<String> genders = <String>['Man', 'Woman'];

/// The class responsible for the Basic Settings part of the Account Settings
/// which Includes:
///
/// Change Password screen
/// Update Email Screen
/// Change Gender Selector
/// Pick Country Selector
/// Also calls fetchUser to display the User Email under the Update Email Address
/// tile.
class BasicSettings extends StatefulWidget {
  const BasicSettings({super.key});

  @override
  State<BasicSettings> createState() => _BasicSettingsState();
}

class _BasicSettingsState extends State<BasicSettings> {
  final client = http.Client();
  String pickedGender = genders.first;
  Country selectedCountry = Country.worldWide;
  void _selectBasicSetting(BuildContext context, String settingName) {
    if (settingName == "email") {
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => const UpdateEmailScreen()));
    } else if (settingName == "password") {
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => const ChangePasswordScreen()));
    }
  }

  Future<UserMock> fetchUser() async {
    return getUserInfo(client);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsTitle(title: "BASIC SETTINGS"),
        FutureBuilder(
            future: fetchUser(),
            builder: (BuildContext ctx, AsyncSnapshot<UserMock> snapshot) {
              while (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Text("ERROR LOADING USER DATA");
              } else {
                final UserMock user = snapshot.data!;
                return ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Update email address"),
                  titleTextStyle: AppTextStyles.primaryTextStyle,
                  subtitle: Text(user.getEmail),
                  trailing: const Icon(Icons.navigate_next),
                  onTap: () {
                    _selectBasicSetting(context, "email");
                  },
                );
              }
            }),
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
          subtitle: Text(selectedCountry.displayName),
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
        FutureBuilder(
          future: fetchUser(),
          builder: (BuildContext ctx, AsyncSnapshot<UserMock> snapshot) {
            while (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Text("ERROR LOADING USER DATA");
            } else {
              final UserMock user = snapshot.data!;
              pickedGender = user.getGender;
              return ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Gender"),
                titleTextStyle: AppTextStyles.primaryTextStyle,
                trailing: DropdownButton(
                  icon: const Icon(Icons.arrow_downward),
                  onChanged: (String? value) {
                    setState(() {
                      pickedGender = value!;
                      changeGenderFunction(
                          client: client, gender: pickedGender);
                    });
                  },
                  value: pickedGender,
                  items: genders.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
