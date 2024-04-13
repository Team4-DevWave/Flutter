import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});
  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Edit Profile"),
          actions: [
            ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(AppColors.whiteHideColor)),
              child: Text(
                "Save",
                style: AppTextStyles.primaryButtonGlowTextStyle,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset('assets/images/background.png'),
                    const Positioned(
                      top: 125,
                      right: 155,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/images/Default_Avatar.png'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      labelText: "Display name - optional",
                      helperText:
                          "This will be displayed to viewers of your profile page and does not change your username",
                      helperMaxLines: 2,
                      helperStyle: AppTextStyles.secondaryTextStyle.copyWith(
                          fontSize: 12, color: AppColors.whiteHideColor),
                      fillColor: const Color.fromARGB(255, 38, 38, 38),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle:
                          const TextStyle(color: AppColors.whiteHideColor)),
                  maxLength: 30,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    labelText: "About you - optional",
                    filled: true,
                    fillColor: Color.fromARGB(255, 38, 38, 38),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      color: AppColors.whiteHideColor,
                    ),
                  ),
                  maxLength: 200,
                  maxLines: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Social Link (5 max)",
                      style: AppTextStyles.boldTextStyle,
                    ),
                    Text(
                  "People who visit your Reddit profile will see your social links",
                  style: AppTextStyles.primaryButtonHideTextStyle,
                    textAlign: TextAlign.start,

                ),
                const SizedBox(height: 20,),
                IntrinsicWidth(
                  child: ElevatedButton(
                      onPressed: () {
                        //open add link bottom sheet
                      },
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 38, 38, 38)),
                          shadowColor: null,
                          overlayColor: null,
                          surfaceTintColor: null,
                          foregroundColor: null),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            color: AppColors.whiteColor,
                          ),
                          Text(
                            "Add social link",
                            style: AppTextStyles.buttonTextStyle,
                          )
                        ],
                      )),
                )
                  ],
                ),
                
              ],
            ),
          ),
        ));
  }
}
