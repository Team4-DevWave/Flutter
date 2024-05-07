// ignore_for_file: unused_result
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/user_settings_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A form widget for adding or editing social links.
///
/// This widget provides a form interface for users to add or edit social links.
/// It includes fields for entering the display name (e.g., username) and the
/// link associated with the social account.
///
/// The [typePressed] parameter specifies the type of social link being added
/// or edited, which determines the behavior and appearance of the form.
///
/// The [initial] parameter contains the initial data for the social link. It
/// is used to pre-fill the form fields when editing an existing social link.
class SocialForm extends ConsumerStatefulWidget {
  const SocialForm(
      {super.key, required this.typePressed, required this.initial});

  /// The type of social link being added or edited.
  final String typePressed;

  /// The initial data for the social link.
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

  /// Determines the appropriate hint text for the display name field based on the type of social link.
  ///
  /// This method returns the hint text for the display name field based on the type of social link
  /// being added or edited. For example, for Instagram or Twitter links, the hint text is "username",
  /// while for Reddit links, it may be "r/Community, u/Username".
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

  /// Checks the validity of the form fields and updates the validation status.
  ///
  /// This method is called whenever the form fields are changed. It validates the input
  /// and updates the [_validate] and [_isValid] flags accordingly. The [_validate] flag
  /// ensures that validation is performed, while [_isValid] indicates whether the input
  /// is currently valid.
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

  /// Sets initial data and state for the form.
  ///
  /// This method initializes the form with the initial data provided by the `initial`
  /// parameter. It also determines whether the form is in edit mode based on the presence
  /// of initial data
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

  /// Handles the "Done" button press event and updates the social links.
  ///
  /// This method is called when the user presses the "Done" button to save or update
  /// the social link. It performs validation, updates the social link data, and triggers
  /// the appropriate actions to add or update the link.
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
                    counterStyle: AppTextStyles.primaryTextStyle
                        .copyWith(color: AppColors.whiteHideColor)),
                validator: (value) => null,
                maxLength: 30,
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
