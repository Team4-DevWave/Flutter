import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/user_profile/view_model/update_dis_name.dart';
import 'package:threddit_clone/features/user_profile/view_model/update_pfp.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/user_settings_provider.dart';
import 'package:threddit_clone/theme/colors.dart';

class SaveButton extends ConsumerStatefulWidget {
  const SaveButton(
      {super.key,
      required this.changed,
      required this.dis,
      required this.image});
  final bool changed;
  final String dis;
  final String image;

  @override
  ConsumerState<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<SaveButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final disName = ref.watch(userModelProvider)!.displayName;
    final oldPfp = ref.watch(userModelProvider)!.profilePicture;
    return ElevatedButton(
      onPressed: widget.changed
          ? () async {
              setState(() {
                _isLoading = true;
              });
              if (widget.dis != disName) {
                final response2 = await updateDisplayName(widget.dis, ref);
                response2.fold((l) {
                  showSnackBar(navigatorKey.currentContext!, l.message);
                }, (r) {
                });
              }
              if (widget.image != oldPfp) {
                final response3 = await updateProfilePicture(widget.image, ref);
                response3.fold((l) {
                  showSnackBar(navigatorKey.currentContext!, l.message);
                }, (r) {
                });
              }
              final response =
                  await ref.read(userProfileProvider.notifier).updateUserData();
              response.fold((l) {
                showSnackBar(navigatorKey.currentContext!, l.message);
              }, (r) {
                showSnackBar(navigatorKey.currentContext!, "User data saved!");
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
              });
            }
          : null,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(widget.changed
            ? AppColors.redditOrangeColor
            : const Color.fromARGB(255, 30, 31, 31)),
      ),
      child: _isLoading
          ? SizedBox(
              height: 13.h,
              width: 13.h,
              child: const CircularProgressIndicator(
                color: AppColors.whiteColor,
                strokeWidth: 3,
              ),
            )
          : Text(
              "Save",
              style: TextStyle(
                  color: widget.changed ? Colors.white : AppColors.whiteColor),
            ),
    );
  }
}
