import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/features/user_system/view/widgets/settings_title.dart';
import 'package:http/http.dart' as http;

const List<String> genders = <String>['man', 'woman'];

/// The class responsible for the Basic Settings part of the Account Settings
/// which Includes:
///
/// Change Password screen
/// Update Email Screen
/// Change Gender Selector
/// Pick Country Selector
/// Also calls fetchUser to display the User Email under the Update Email Address
/// tile.
class BasicSettings extends ConsumerStatefulWidget {
  const BasicSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BasicSettingsState();
}

class _BasicSettingsState extends ConsumerState<BasicSettings> {
  final client = http.Client();
  String? token;
  String pickedGender = genders.first;
  Country selectedCountry = Country.worldWide;
  void _selectBasicSetting(BuildContext context, String settingName) {
    if (settingName == "email") {
      Navigator.pushNamed(context, RouteClass.updateEmailScreen)
          .then((value) => setState(() {
                ref
                    .watch(settingsFetchProvider.notifier)
                    .getUserInfo(client: client, token: token!);
              }));
    } else if (settingName == "password") {
      Navigator.pushNamed(context, RouteClass.changePasswordScreen);
    }
  }

  Future<UserModelMe> fetchUser() async {
    setState(() {
      ref
          .watch(settingsFetchProvider.notifier)
          .getMe(client: client, token: token!);
    });
    return ref
        .watch(settingsFetchProvider.notifier)
        .getMe(client: client, token: token!);
  }

  Future getUserToken() async {
    String? result = await getToken();
    setState(() {
      token = result!;
    });
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsTitle(title: "BASIC SETTINGS"),
        FutureBuilder(
            future: fetchUser(),
            builder: (BuildContext ctx, AsyncSnapshot<UserModelMe> snapshot) {
              while (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text("ERROR LOADING USER DATA");
              } else {
                final UserModelMe user = snapshot.data!;
                
                return ListView(shrinkWrap: true, children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text("Update email address"),
                    titleTextStyle: AppTextStyles.primaryTextStyle,
                    subtitle: Text(user.email!),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      _selectBasicSetting(context, "email");
                    },
                  ),
                ]);
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
        FutureBuilder(
          future: fetchUser(),
          builder: (BuildContext ctx, AsyncSnapshot<UserModelMe> snapshot) {
            while (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Text("ERROR LOADING USER DATA");
            } else {
              final UserModelMe user = snapshot.data!;
              pickedGender = user.gender!;
              selectedCountry = Country.parse(user.country!);
              return ListView(shrinkWrap: true, children: [
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
                            changeCountry(client: client, country: country.displayName, token: token!);
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
                    dropdownColor: AppColors.backgroundColor,
                    style: AppTextStyles.primaryTextStyle,
                    icon: const Icon(Icons.arrow_downward),
                    onChanged: (String? value) {
                      setState(() {
                        pickedGender = value!;
                      });
                    },
                    value: pickedGender,
                    items:
                        genders.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )
              ]);
            }
          },
        ),
      ],
    );
  }
}
