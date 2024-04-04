import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class AddLinkWidget extends ConsumerStatefulWidget {
  const AddLinkWidget({super.key, required this.removeLink});
  final Function()? removeLink;

  @override
  ConsumerState<AddLinkWidget> createState() => _AddLinkWidgetState();
}

class _AddLinkWidgetState extends ConsumerState<AddLinkWidget> {
  TextEditingController? _linkController;

  @override
  void initState() {
    _linkController = TextEditingController();
    super.initState();
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
          ///check if the link actually changed
          if (post?.link != data) {
            ///update the link with the  new value
            ref.read(postDataProvider.notifier).state = post?.copyWith(link: data);
          }
        },
        decoration: InputDecoration(
          labelText: "Enter link",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              ///sets the isLink variable to false in the add_post screen
              widget.removeLink?.call();
              ///set the link to null if the user removed the field.
              if (post?.link != null) {
                ref.read(postDataProvider.notifier).state =  post!.copyWith(link: null);
              }
            },
          ),
        ),
      ),
    );
  }
}
