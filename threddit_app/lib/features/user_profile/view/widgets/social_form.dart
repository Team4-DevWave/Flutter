// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/user_settings_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SocialForm extends ConsumerStatefulWidget {
  const SocialForm(
      {super.key, required this.typePressed, required this.initial});
  final String typePressed;
  final List<String> initial;

  @override
  ConsumerState<SocialForm> createState() => _SocialForm();
}

class _SocialForm extends ConsumerState<SocialForm> {
  TextEditingController displayName = TextEditingController(text: "");
  TextEditingController socialLink = TextEditingController(text: "");
  List<List<String>>? socialLinksData;
  String _initialUsername = '';
  String _initialLink = '';
  bool _isEdit = false;
  int _index = -1;

  bool _validate = false;
  bool _isValid = false;
  bool _isUrlExist = false;

  String _hintText() {
    switch (widget.typePressed) {
      case "Instagram" || "instagram":
        return 'username';
      case "Twitter" || "twitter":
        return 'username';
      case "Reddit" || "reddit":
        return 'r/Community, u/Username';
      default:
        if (widget.initial.length == 3) {
          _isUrlExist = true;
          return "Display text";
        } else {
          return "username";
        }
    }
  }

  void _checkValidity() {
    setState(() {
      _validate = false;
      if (_isUrlExist) {
        _isValid = _isEdit
            ? (displayName.text != _initialUsername ||
                    socialLink.text != _initialLink) &&
                displayName.text.trim().isNotEmpty &&
                socialLink.text.trim().isNotEmpty
            : displayName.text.trim().isNotEmpty &&
                socialLink.text.trim().isNotEmpty;
      } else {
        _isValid = _isEdit
            ? displayName.text.trim().isNotEmpty &&
                displayName.text != _initialUsername
            : displayName.text.trim().isNotEmpty;
      }
    });
  }

  void _setData() {
    final userProfile = ref.read(userProfileProvider);
    socialLinksData = userProfile?.socialLinks;
    widget.initial[1].isNotEmpty ? _isEdit = true : _isEdit = false;
    if (_isEdit) {
      _index = socialLinksData!.indexOf(widget.initial);
    }
    if (widget.initial.length == 3) {
      _initialUsername = widget.initial[1];
      _initialLink = widget.initial[2];
      displayName.text = widget.initial[1];
      socialLink.text = widget.initial[2];
    } else {
      _initialUsername = widget.initial[1];
      displayName.text = widget.initial[1];
    }
  }

  void _onDonePressed() async {
    _validate = true;

    if (_isEdit && socialFormKey.currentState!.validate()) {
      final List<String> modified = _isUrlExist
          ? [widget.initial[0], displayName.text, socialLink.text]
          : [widget.initial[0], displayName.text];

      socialLinksData![_index] = modified;

      ref.read(userProfileProvider.notifier).updateSocialLinks(socialLinksData);

      final response =
          await ref.read(userProfileProvider.notifier).updateUserLinks();
      ref.refresh(socialLinksFutureProvider);
      response.fold(
          (failure) =>
              showSnackBar(navigatorKey.currentContext!, failure.message), (r) {
        Navigator.pop(context);
        showSnackBar(
            navigatorKey.currentContext!, "Social links updated successfully");
      });
    } else if (socialFormKey.currentState!.validate()) {
      final List<String> added = _isUrlExist
          ? [widget.initial[0], displayName.text, socialLink.text]
          : [widget.initial[0], displayName.text];
      ref.read(userProfileProvider.notifier).addLink(added);
      ref.refresh(socialLinksFutureProvider);
      final response =
          await ref.read(userProfileProvider.notifier).updateUserLinks();
      response.fold(
          (failure) =>
              showSnackBar(navigatorKey.currentContext!, failure.message), (r) {
        Navigator.pop(context);
        Navigator.pop(context);
        showSnackBar(
            navigatorKey.currentContext!, "Social links updated successfully");
      });
    }
  }

  @override
  void initState() {
    _setData();
    super.initState();
  }

  @override
  void dispose() {
    displayName.dispose();
    socialLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          10.w, 5.h, 10.w, MediaQuery.of(context).viewInsets.bottom.h + 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_outlined,
                  size: 30.spMin,
                  color: AppColors.blueColor,
                ),
              ),
              SizedBox(width: 50.w),
              Text(
                "Add Social Link",
                style: AppTextStyles.boldTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 50.w),
              if (_isValid)
                IconButton(
                  onPressed: () => _onDonePressed(),
                  icon: Icon(
                    Icons.check,
                    size: 30.spMin,
                    color: AppColors.blueColor,
                  ),
                ),
            ],
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 13.w),
            decoration: BoxDecoration(
              color: AppColors.registerButtonColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.typePressed,
              style: AppTextStyles.buttonTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13.spMin,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 15.h),
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: socialFormKey,
            onChanged: _checkValidity,
            child: Column(children: [
              TextFormField(
                controller: displayName,
                cursorColor: AppColors.blueColor,
                style: AppTextStyles.primaryTextStyle,
                decoration: InputDecoration(
                  hintText: _hintText(),
                  hintStyle: AppTextStyles.primaryTextStyle
                      .copyWith(color: AppColors.whiteHideColor),
                  filled: true,
                  fillColor: AppColors.registerButtonColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0.r),
                    borderSide: const BorderSide(color: AppColors.whiteColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0.r),
                    borderSide: const BorderSide(color: AppColors.errorColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0.r),
                    borderSide: const BorderSide(color: AppColors.errorColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0.h, horizontal: 15.0.w),
                  counter: const SizedBox.shrink(),
                ),
                validator: (value) => null,
              ),
              SizedBox(height: 5.h),
              if (_isUrlExist)
                TextFormField(
                  controller: socialLink,
                  cursorColor: AppColors.blueColor,
                  style: AppTextStyles.primaryTextStyle,
                  decoration: InputDecoration(
                    hintText: "https://website.com",
                    hintStyle: AppTextStyles.primaryTextStyle
                        .copyWith(color: AppColors.whiteHideColor),
                    filled: true,
                    fillColor: AppColors.registerButtonColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0.r),
                      borderSide: const BorderSide(color: AppColors.whiteColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0.r),
                      borderSide: const BorderSide(color: AppColors.errorColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0.r),
                      borderSide: const BorderSide(color: AppColors.errorColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0.h, horizontal: 15.0.w),
                    counter: const SizedBox.shrink(),
                  ),
                  validator: (value) {
                    final urlRegex = RegExp(r'^(http|https):\/\/[^ "]+$',
                        caseSensitive: false);
                    if (!_validate) {
                      return null;
                    }
                    if (!urlRegex.hasMatch(value!)) {
                      return "Invalid url";
                    }
                    if (!value.contains(widget.typePressed.toLowerCase())) {
                      return "Domain is not allowed";
                    }
                    return null;
                  },
                ),
            ]),
          )
        ],
      ),
    );
  }
}