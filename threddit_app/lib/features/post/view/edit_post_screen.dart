import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/view/exit_edit.dart';
import 'package:threddit_clone/features/post/view/widgets/add_edit_link.dart';
import 'package:threddit_clone/features/post/viewmodel/edit_post.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:tuple/tuple.dart';

String onInsertData(String name, String link, String value) {
  if (link.contains("http")) {
    return "$value[$name]($link)";
  } else {
    return "$value[$name](http://$link)";
  }
}

/// Updates the form validity based on the text body changes.
Tuple2<bool, bool> updateFormValidity(String value, String initialValue) {
  Tuple2<bool, bool> tuple2 = Tuple2(value != initialValue,
      value.trim().isNotEmpty && value.trim() != initialValue.trim());
  return tuple2;
}

/// Toggles the bottom sheet buttons visibility.
bool onIsOn(bool isOn) {
  return !isOn;
}

/// Toggles the NSFW option.
bool onIsNSFW(bool isNSFW) {
  return !isNSFW;
}

/// Toggles the spoiler option.
bool onIsSpoiler(bool isSpoiler) {
  return !isSpoiler;
}

Color saveButtonColor(bool isValid) {
  return isValid ? AppColors.blueColor : AppColors.whiteHideColor;
}

/// Determines the background color of the NSFW button based on its status.
Color isNSFWButtonBackgroundColor(bool isNSFW) {
  return isNSFW ? AppColors.redColor : AppColors.backgroundColor;
}

/// Determines the text color of the NSFW button based on its status.
Color isNSFWButtonTextColor(bool isNSFW) {
  return isNSFW ? AppColors.backgroundColor : AppColors.whiteColor;
}

/// Determines the text color of the spoiler button based on its status.
Color isSpoilerButtonTextColor(bool isSpoiler) {
  return isSpoiler ? AppColors.backgroundColor : AppColors.whiteColor;
}

/// Determines the background color of the spoiler button based on its status.
Color isSpoilerButtonBackgroundColor(bool isSpoiler) {
  return isSpoiler ? AppColors.whiteGlowColor : AppColors.backgroundColor;
}

/// A StatefulWidget for editing an existing post.
///
/// This widget allows users to edit the content of an existing post,
/// including the post body, NSFW status, and spoiler status. Users can
/// also add or edit links within the post body.
///
class EditPost extends ConsumerStatefulWidget {
  const EditPost({super.key});

  @override
  ConsumerState<EditPost> createState() => _EditPostState();
}

class _EditPostState extends ConsumerState<EditPost> {
  TextEditingController textBodyController = TextEditingController(text: "");
  String initialValue = '';
  String? postingIn;
  bool isOn = false;
  bool isNSFW = false;
  bool isSpoiler = false;
  bool isNotProfile = true;
  bool _isValid = true;
  bool _isChanged = false;

  void onSave() async {
    ref.read(editPostProvider.notifier).updateNFSW(isNSFW);
    ref
        .read(editPostProvider.notifier)
        .updatePostTextBody(textBodyController.text);
    ref.read(editPostProvider.notifier).updateSpoiler(isSpoiler);
    final respnose =
        await ref.read(editPostProvider.notifier).editPostRequest();
    respnose.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (post) {
      showSnackBar(navigatorKey.currentContext!, "Post updated successfully");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, RouteClass.postScreen,
          arguments: {'currentpost': post, 'uid': post.id});
    });
  }

  void onInsert(String name, String link) {
    setState(() {
      textBodyController.text =
          onInsertData(name, link, textBodyController.text);
    });
  }

  void _setData() {
    isNSFW = ref.read(editPostProvider).nsfw;
    isSpoiler = ref.read(editPostProvider).spoiler;
    textBodyController.text = ref.read(editPostProvider).textBody ?? "";
    initialValue = ref.read(editPostProvider).textBody ?? "";
    _isValid = textBodyController.text.trim().isNotEmpty &&
            textBodyController.text.trim() != initialValue.trim()
        ? true
        : false;
  }

  void _updateFormValidityData() {
    setState(() {
      Tuple2<bool, bool> tuple2 =
          updateFormValidity(textBodyController.text, initialValue);
      _isChanged = tuple2.item1;
      _isValid = tuple2.item2;
    });
  }

  @override
  void initState() {
    _setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateFormValidityData();
    return Scaffold(
      appBar: AppBar(
        leading: _isChanged
            ? const ExitEdit()
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, size: 27.spMin)),
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Edit post',
          style: AppTextStyles.primaryTextStyle.copyWith(fontSize: 24.spMin),
        ),
        actions: [
          TextButton(
            onPressed: _isValid ? onSave : null,
            child: Text(
              'Save',
              style: AppTextStyles.primaryTextStyle.copyWith(
                  fontSize: 20.spMin,
                  color: saveButtonColor(_isValid),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
        height: MediaQuery.of(context).size.height.h,
        width: MediaQuery.of(context).size.width.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              scrollPhysics: const ClampingScrollPhysics(),
              controller: textBodyController,
              onChanged: (value) {
                textBodyController.text = value;
                _updateFormValidityData();
              },
              style:
                  AppTextStyles.primaryTextStyle.copyWith(fontSize: 20.spMin),
              decoration: InputDecoration(
                hintText: 'Your text post (optional)',
                hintStyle:
                    AppTextStyles.primaryTextStyle.copyWith(fontSize: 20.spMin),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.whiteHideColor,
                  ),
                ),
              ),
              cursorColor: AppColors.blueColor,
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
      bottomSheet: Container(
        color: AppColors.backgroundColor,
        child: Row(
          children: [
            EditLink(onInsert),
            IconButton(
              onPressed: () {
                setState(() {
                  isOn = onIsOn(isOn);
                });
              },
              icon:
                  const Icon(Icons.more_vert, color: AppColors.whiteHideColor),
            ),
            isOn
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isNSFW = onIsNSFW(isNSFW);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isNSFWButtonBackgroundColor(isNSFW),
                          side: BorderSide(
                            color: AppColors.whiteColor,
                            width: 2.0.spMin,
                          ),
                        ),
                        child: Text(
                          'NSFW',
                          style: AppTextStyles.primaryTextStyle.copyWith(
                            color: isNSFWButtonTextColor(isNSFW),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSpoiler = onIsSpoiler(isSpoiler);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSpoilerButtonBackgroundColor(isSpoiler),
                          side: BorderSide(
                            color: AppColors.whiteColor,
                            width: 2.0.spMin,
                          ),
                        ),
                        child: Text(
                          'SPOILER',
                          style: AppTextStyles.primaryTextStyle.copyWith(
                              color: isSpoilerButtonTextColor(isSpoiler)),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

void editPost(BuildContext context, WidgetRef ref, Post post) {
  ref.read(editPostProvider.notifier).updatePostToBeEdited(post);
  Navigator.pushNamed(context, RouteClass.editPostScreen);
}
