import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_profile/view/widgets/add_social_link.dart';
import 'package:threddit_clone/features/user_profile/view/widgets/onSave_button.dart';
import 'package:threddit_clone/features/user_system/view_model/user_settings_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});
  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  String? displayName;
  String? about;
  List<String>? socialLinks;
  bool? initIsActive;
  bool? initIsVisible;
  bool? isActive;
  bool? isVisible;
  bool isAnythingChanged = false;

  @override
  void didChangeDependencies() {
    final userProfile = ref.watch(userProfileProvider);
    if (userProfile != null) {
      displayName = userProfile.displayName;
      about = userProfile.about;
      socialLinks = userProfile.socialLinks;
      initIsActive = userProfile.activeCommunitiesVisibility;
      initIsVisible = userProfile.contentVisibility;
      isVisible = initIsVisible;
      isActive = initIsActive;
    }
    super.didChangeDependencies();
  }

  void updateDisplay(String name) {
    setState(() {
      if (displayName != name) {
        isAnythingChanged = true;
      } else {
        isAnythingChanged = false;
      }
    });
    final userProfile = ref.watch(userProfileProvider.notifier);
    userProfile.updateDiplayName(name);
  }

  void updateAbout(String abot) {
    final userProfile = ref.watch(userProfileProvider.notifier);
    userProfile.updateAbout(abot);
    setState(() {
      if (about != abot) {
        isAnythingChanged = true;
      } else {
        isAnythingChanged = false;
      }
    });
  }

  void updateSocialLinks(List<String> links) {
    final userProfile = ref.watch(userProfileProvider.notifier);
    userProfile.updateSocialLinks(links);
    setState(() {
      if (socialLinks != links) {
        isAnythingChanged = true;
      } else {
        isAnythingChanged = false;
      }
    });
  }

  void updateActive(bool value) {
    setState(() {
      if (value != initIsActive || isVisible != initIsVisible) {
        isAnythingChanged = true;
      } else {
        isAnythingChanged = false;
      }
      isActive = value;
      ref.read(userProfileProvider.notifier).updateActiveCom(value);
    });
  }

  void updateVisible(bool value) {
    setState(() {
      if (value != initIsVisible || isActive != initIsActive) {
        isAnythingChanged = true;
      } else {
        isAnythingChanged = false;
      }
      isVisible = value;
      ref.read(userProfileProvider.notifier).updateContetnVis(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Edit Profile"),
          actions: [SaveButton(changed: isAnythingChanged)],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(
                  height: 150.h,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: const [
                              Color.fromARGB(255, 0, 99, 145),
                              Color.fromARGB(255, 2, 55, 99),
                              Color.fromARGB(221, 14, 13, 13),
                            ],
                            stops: [0.0.sp, 0.25.sp, 1.0.sp],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60.h,
                        right: 120.w,
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundImage: const AssetImage(
                              'assets/images/Default_Avatar.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  style: AppTextStyles.primaryTextStyle,
                  controller: _displayNameController,
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
                  onChanged: (value) {
                    updateDisplay(value);
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  style: AppTextStyles.primaryTextStyle,
                  controller: _aboutController,
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
                  maxLines: 4,
                  onChanged: (value) {
                    updateAbout(value);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Social Link (5 max)",
                      style:
                          AppTextStyles.primaryTextStyle.copyWith(fontSize: 18),
                    ),
                    Text(
                      "People who visit your Reddit profile will see your social links",
                      style: AppTextStyles.primaryButtonHideTextStyle,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    IntrinsicWidth(
                      child: ElevatedButton(
                          onPressed: () {
                            //open add link bottom sheet
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: AppColors.backgroundColor,
                                builder: (ctx) {
                                  return const AddSocialLink();
                                });
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
                                style: AppTextStyles.primaryButtonGlowTextStyle,
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 250.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Content Visibility",
                                style: AppTextStyles.boldTextStyle
                                    .copyWith(fontSize: 18),
                              ),
                              Text(
                                "All posts to this profile will appear in r/all and your profile can be discovered in /users",
                                style: AppTextStyles.primaryButtonHideTextStyle
                                    .copyWith(fontSize: 12),
                                maxLines: 2,
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: isVisible!,
                          onChanged: (value) {
                            updateVisible(value);
                          },
                          activeColor: AppColors.redditOrangeColor,
                          dragStartBehavior: DragStartBehavior.start,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 250.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Show active communities",
                                style: AppTextStyles.boldTextStyle
                                    .copyWith(fontSize: 18),
                              ),
                              Text(
                                "Decide whether to show the communities you are active in on your profile",
                                maxLines: 2,
                                style: AppTextStyles.primaryButtonHideTextStyle
                                    .copyWith(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: isActive!,
                          onChanged: (value) {
                            updateActive(value);
                          },
                          activeColor: AppColors.redditOrangeColor,
                          dragStartBehavior: DragStartBehavior.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
