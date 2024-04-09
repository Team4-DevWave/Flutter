import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';

class AppSwitchButton extends ConsumerStatefulWidget {
  const AppSwitchButton({super.key, required this.k, required this.type});
  final Key k;
  final int type;
  @override
  ConsumerState<AppSwitchButton> createState() => _AppSwitchButtonState();
}

class _AppSwitchButtonState extends ConsumerState<AppSwitchButton> {

  @override
  Widget build(BuildContext context) {
    PostData? post = ref.watch(postDataProvider);
    return Switch(
      key: widget.k,
      value: widget.type == 1? post!.isSpoiler : post!.isNSFW,
      onChanged: (value) => setState(() {
      if(widget.type == 1)
      {
        ref
          .read(postDataProvider.notifier).updateIsSpoiler(value);
      }
      else{
        ref
          .read(postDataProvider.notifier).updateIsNsfw(value);
      }
      }),
      activeColor: AppColors.redditOrangeColor,
      dragStartBehavior: DragStartBehavior.start,
    );
  }
}
