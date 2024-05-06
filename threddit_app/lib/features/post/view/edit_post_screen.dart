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

/// A StatefulWidget for editing an existing post.
///
/// This widget allows users to edit the content of an existing post,
/// including the post body, NSFW status, and spoiler status. Users can
/// also add or edit links within the post body.
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

  /// Updates the form validity based on the text body changes.
  void _updateFormValidity() {
    _isChanged = (textBodyController.text != initialValue);
    setState(
      () {
        _isValid = textBodyController.text.trim().isNotEmpty &&
                textBodyController.text.trim() != initialValue.trim()
            ? true
            : false;
      },
    );
  }

  /// Toggles the bottom sheet buttons visibility.
  void onIsOn() {
    setState(() {
      isOn = !isOn;
    });
  }

  /// Toggles the NSFW option.
  void onIsNSFW() {
    setState(() {
      isNSFW = !isNSFW;
    });
  }

  /// Toggles the spoiler option.
  void onIsSpoiler() {
    setState(() {
      isSpoiler = !isSpoiler;
    });
  }

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
      if (link.contains("http")) {
        textBodyController.text = "${textBodyController.text}[$name]($link)";
      } else {
        textBodyController.text =
            "${textBodyController.text}[$name](http://$link)";
      }
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

  @override
  void initState() {
    _setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateFormValidity();
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
                  color:
                      _isValid ? AppColors.blueColor : AppColors.whiteHideColor,
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
              controller: textBodyController,
              onChanged: (value) {
                // ref
                //     .read(isEditFirstTime.notifier)
                //     .update((state) => false);

                // lastValue = value;

                textBodyController.text = value;
                _updateFormValidity();
              },
              // initialValue: ref.read(isEditFirstTime)
              //     ? lastValue = ref.read(editPostProvider).textBody ?? ""
              //     : lastValue,
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
              onPressed: onIsOn,
              icon:
                  const Icon(Icons.more_vert, color: AppColors.whiteHideColor),
            ),
            isOn
                ? Row(
                    children: [
                      ElevatedButton(
                        onPressed: onIsNSFW,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isNSFW
                              ? AppColors.redColor
                              : AppColors.backgroundColor,
                          side: BorderSide(
                            color: AppColors.whiteColor,
                            width: 2.0.w,
                          ),
                        ),
                        child: Text(
                          'NSFW',
                          style: AppTextStyles.primaryTextStyle.copyWith(
                              color: isNSFW
                                  ? AppColors.backgroundColor
                                  : AppColors.whiteColor),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      ElevatedButton(
                        onPressed: onIsSpoiler,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSpoiler
                              ? AppColors.whiteGlowColor
                              : AppColors.backgroundColor,
                          side: const BorderSide(
                            color: AppColors.whiteColor,
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          'SPOILER',
                          style: AppTextStyles.primaryTextStyle.copyWith(
                              color: isSpoiler
                                  ? AppColors.backgroundColor
                                  : AppColors.whiteColor),
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
