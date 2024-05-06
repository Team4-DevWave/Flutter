import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';


class AddLinkWidget extends ConsumerStatefulWidget {
  const AddLinkWidget({super.key, required this.removeLink});
  final Function()? removeLink;

  @override
  ConsumerState<AddLinkWidget> createState() => _AddLinkWidgetState();
}

class _AddLinkWidgetState extends ConsumerState<AddLinkWidget> {
  TextEditingController? _linkController;
  bool isValid = true;

  @override
  void initState() {
    _linkController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final intialData = ref.watch(postDataProvider);
    _linkController = TextEditingController(text: intialData?.url);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _linkController!.dispose();
    super.dispose();
  }

  bool _validateLink(String value) {

    // Regular expression for URL validation
    final urlRegex = RegExp(r'^(http|https):\/\/[^ "]+$', caseSensitive: false);

    // Check if the input string matches the URL format
    return urlRegex.hasMatch(value);
  }



  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    PostData? post = ref.read(postDataProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _linkController,
        style: AppTextStyles.primaryTextStyle,
        onChanged: (data) {
          ///check the validity of the.url
          final bool result = _validateLink(data);
          setState(() {
            isValid = result;
            ref.watch(validLink.notifier).update((state) => isValid);
          });
          ///check if the.url actually changed and the.url is valid
          if (post?.url != data) {
            ///update the.url with the new value
            ref.read(postDataProvider.notifier).updateLink(data);
          }
        },
        decoration: InputDecoration(
          errorText: !isValid
              ? "Oops, this link isn't valid, Double check, and try again"
              : null,
          errorStyle: AppTextStyles.primaryTextStyle
              .copyWith(color: AppColors.errorColor.withOpacity(0.9)),
          errorBorder: !isValid
              ? const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.errorColor))
              : InputBorder.none,
          labelText: "Enter link",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.whiteGlowColor)),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
            onPressed: () {
                ref.read(postDataProvider.notifier).removeLink();
                _linkController?.clear();
                widget.removeLink?.call();
            },
          ),
        ),
      ),
    );
  }
}
