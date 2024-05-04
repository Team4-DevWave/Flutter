import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/Moderation/view/screens/on_exit_mod.dart';
import 'package:threddit_clone/features/Moderation/view_model/description.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class DescriptionScreen extends ConsumerStatefulWidget {
  const DescriptionScreen({super.key});

  @override
  ConsumerState<DescriptionScreen> createState() => _DescriptionScreen();
}

class _DescriptionScreen extends ConsumerState<DescriptionScreen> {
  TextEditingController textBodyController = TextEditingController(text: "");
  String initialValue = '';
  bool _isLoading = false;
  bool _isValid = false;

  void _updateFormValidity() {
    setState(() {
      _isValid = textBodyController.text.trim().isNotEmpty &&
          textBodyController.text.trim() != initialValue;
    });
  }

  Future<void> onSave() async {
    ref
        .read(descriptionProvider.notifier)
        .updateDescriptioState(textBodyController.text);
    final response =
        await ref.read(descriptionProvider.notifier).updateDescription();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (success) {
      Navigator.pop(context);
    });
  }

  Future<void> _setData() async {
    setState(() {
      _isLoading = true;
    });
    final response =
        await ref.read(descriptionProvider.notifier).getDescription();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (initialDescription) {
      initialValue = initialDescription;
      textBodyController.text = initialValue;
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              leading: _isValid
                  ? const ExitMod()
                  : IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, size: 27.spMin)),
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                'Description',
                style:
                    AppTextStyles.primaryTextStyle.copyWith(fontSize: 24.spMin),
              ),
              actions: [
                TextButton(
                  onPressed: _isValid ? onSave : null,
                  child: Text(
                    'Save',
                    style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 20.spMin,
                        color: _isValid
                            ? AppColors.blueColor
                            : AppColors.blueHideColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
              height: MediaQuery.of(context).size.height.h,
              width: MediaQuery.of(context).size.width.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Describe your community',
                    style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 20.spMin, color: AppColors.blueColor),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: textBodyController,
                      onChanged: (value) {
                        textBodyController.text = value;
                        _updateFormValidity();
                      },
                      style: AppTextStyles.primaryTextStyle
                          .copyWith(fontSize: 20.spMin),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueColor,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueColor,
                          ),
                        ),
                      ),
                      cursorColor: AppColors.blueColor,
                      maxLength: 500,
                      maxLines: null, // Allow multiple lines
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
  }
}
