import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threddit_clone/features/user_profile/view/widgets/add_social_link.dart';
import 'package:threddit_clone/features/user_profile/view/widgets/onSave_button.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_profile/view/widgets/social_form.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/user_settings_provider.dart';
import 'package:threddit_clone/theme/button_styles.dart';
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
  List<List<String>>? socialLinks;
  bool? initIsActive; // the initial state of the isActive controller
  bool? initIsVisible; // the initial state of the isVisible controller
  bool? isActive;
  bool? isVisible;
  bool isAnythingChanged =
      false; //checker for changes in the screen to be used in the saved button
  final ImagePicker picker = ImagePicker();
  String? image; // holding the base64 string to be sent to the backend
  File?
      imageFile; //holds the image file path, used in converting the image to base64
  bool? isImage;
  bool? initIsImage;

  Future<void> _pickImage() async {
    // prefs = await SharedPreferences.getInstance();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    imageFile = File(pickedImage.path);
    Uint8List imageBytes = await imageFile!.readAsBytes();
    setState(() {
      image = base64Encode(imageBytes);
      isImage = true;
      isAnythingChanged = true;
    });
  }

  Future<void> _onDelete(List<String> link) async {
    socialLinks?.remove(link);
    ref.read(userProfileProvider.notifier).updateSocialLinks(socialLinks);
    final response =
        await ref.read(userProfileProvider.notifier).updateUserLinks();

    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (sucesss) {
      showSnackBar(
          navigatorKey.currentContext!, "Social links updated successfully");
      setState(() {});
    });
  }

  Future<void> _removeImage() async {
    setState(() {
      image = "";
      isImage = false;
      imageFile = null;
    });
    isAnythingChanged = true;
  }

  @override
  void didChangeDependencies() {
    final userProfile = ref.watch(userProfileProvider);
    final dis = ref.watch(userModelProvider)?.displayName;
    final pfp = ref.watch(userModelProvider)?.profilePicture;
    if (userProfile != null) {
      displayName = dis;
      _displayNameController = TextEditingController(text: displayName);
      about = userProfile.about;
      _aboutController = TextEditingController(text: about);
      socialLinks = userProfile.socialLinks;
      initIsActive = userProfile.activeCommunitiesVisibility;
      initIsVisible = userProfile.contentVisibility;
      isVisible = initIsVisible;
      isActive = initIsActive;
      if (pfp == "") {
        initIsImage = false;
        isImage = false;
        image = "";
      } else {
        initIsImage = true;
        isImage = true;
        image = pfp;
      }
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
  }

  void updateAbout(String abot) {
    ref.read(userProfileProvider.notifier).updateAbout(abot);
    setState(() {
      if (about != abot) {
        isAnythingChanged = true;
      } else {
        isAnythingChanged = false;
      }
    });
  }

  void updateActive(bool value) {
    ref.read(userProfileProvider.notifier).updateActiveCom(value);
    setState(() {
      if (value != initIsActive || isVisible != initIsVisible) {
        isAnythingChanged = true;
      } else {
        isAnythingChanged = false;
      }
      isActive = value;
    });
  }

  void updateVisible(bool value) {
    ref.read(userProfileProvider.notifier).updateContetnVis(value);
    setState(() {
      if (value != initIsVisible || isActive != initIsActive) {
        isAnythingChanged = true;
      } else {
        isAnythingChanged = false;
      }
      isVisible = value;
    });
  }

  bool isLink(String value) {
    // Regular expression for URL validation
    final urlRegex = RegExp(r'^(http|https):\/\/[^ "]+$', caseSensitive: false);

    // Check if the input string matches the URL format
    return urlRegex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(socialLinksFutureProvider);

    ImageProvider setProfilePic() {
      if (image!="") {
        if (isLink(image!)) {
          return NetworkImage(image!);
        } else {
          return FileImage(imageFile!);
        }
      } else {
        return const AssetImage('assets/images/Default_Avatar.png');
      }
    }

    Widget removeImage() {
      if (isImage!) {
        return InkWell(
          onTap: () {
            setState(() {
              isAnythingChanged = true;
            });
            _removeImage();
            Navigator.pop(context);
          },
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline_outlined,
                color: Colors.red,
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                "Remove profile picture",
                style: AppTextStyles.boldTextStyle
                    .copyWith(fontSize: 18.spMin, color: Colors.red),
              )
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    }

    void openPicOverlay() {
      showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.backgroundColor,
          builder: (ctx) {
            return Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Update profile image",
                    style: AppTextStyles.primaryButtonHideTextStyle,
                  ),
                  const Divider(),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: () {
                      _pickImage();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_photo_alternate_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          "Pick a profile image",
                          style: AppTextStyles.boldTextStyle
                              .copyWith(fontSize: 18.spMin),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  removeImage(),
                ],
              ),
            );
          });
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Edit Profile"),
          actions: [
            SaveButton(
                changed: isAnythingChanged,
                dis: _displayNameController.text,
                image: image!)
          ],
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
                        child: Stack(children: [
                          CircleAvatar(
                            radius: 50.r,
                            backgroundImage: setProfilePic(),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () => openPicOverlay(),
                              icon: isImage!
                                  ? const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                    )
                                  : const Icon(Icons.add, color: Colors.white),
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 37, 39, 44))),
                            ),
                          )
                        ]),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.r))),
                    labelText: "About you - optional",
                    filled: true,
                    fillColor: const Color.fromARGB(255, 38, 38, 38),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    alignLabelWithHint: true,
                    labelStyle: const TextStyle(
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
                    Wrap(
                      spacing: 7.0.w,
                      runSpacing: 5.0.h,
                      children: socialLinks!
                          .map((link) => IntrinsicWidth(
                                child: ElevatedButton(
                                  style: AppButtons.interestsButtons,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        link[1],
                                        style: AppTextStyles.primaryTextStyle
                                            .copyWith(fontSize: 16.spMin),
                                      ),
                                      IconButton(
                                        onPressed: () => _onDelete(link),
                                        icon: const Icon(
                                          Icons.cancel_outlined,
                                        ),
                                        iconSize: 19.spMin,
                                        color: AppColors.whiteColor,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      useSafeArea: true,
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15.0.r)),
                                      ),
                                      context: context,
                                      backgroundColor:
                                          AppColors.backgroundColor,
                                      builder: (ctx) {
                                        return SocialForm(
                                          typePressed: link[0]
                                                  .substring(0, 1)
                                                  .toUpperCase() +
                                              link[0].substring(1),
                                          initial: link,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 5.h),
                    socialLinks!.length < 5
                        ? IntrinsicWidth(
                            child: ElevatedButton(
                                onPressed: () {
                                  //open add link bottom sheet
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.0.r),
                                        ),
                                      ),
                                      useSafeArea: true,
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      context: context,
                                      backgroundColor:
                                          AppColors.backgroundColor,
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
                                      style: AppTextStyles
                                          .primaryButtonGlowTextStyle,
                                    )
                                  ],
                                )),
                          )
                        : const SizedBox(),
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
                                    .copyWith(fontSize: 18.spMin),
                              ),
                              Text(
                                "All posts to this profile will appear in r/all and your profile can be discovered in /users",
                                style: AppTextStyles.primaryButtonHideTextStyle
                                    .copyWith(fontSize: 12.spMin),
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
                                    .copyWith(fontSize: 18.spMin),
                              ),
                              Text(
                                "Decide whether to show the communities you are active in on your profile",
                                maxLines: 2,
                                style: AppTextStyles.primaryButtonHideTextStyle
                                    .copyWith(fontSize: 12.spMin),
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
