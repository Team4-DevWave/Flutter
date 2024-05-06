import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';

/// A switch button widget for toggling post settings.
///
/// This widget displays a switch button that allows users to toggle between
/// different post settings such as spoiler and NSFW.
///
/// [k] is a required parameter of type [Key] used to uniquely identify the
/// switch button.
///
/// [type] is a required parameter of type [int] which specifies the type of
/// setting to be toggled. It should be either 1 for spoiler or 0 for NSFW.
class AppSwitchButton extends ConsumerStatefulWidget {
  /// Constructs a [AppSwitchButton] widget.
  ///
  /// The [k] parameter is used to uniquely identify the switch button.
  ///
  /// The [type] parameter specifies the type of setting to be toggled. It
  /// should be either 1 for spoiler or 0 for NSFW.
  const AppSwitchButton({super.key, required this.k, required this.type});

  /// The key used to uniquely identify the switch button.
  final Key k;

  /// Specifies the type of setting to be toggled.
  ///
  /// Should be 1 for spoiler or 0 for NSFW.
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
      value: widget.type == 1 ? post!.spoiler : post!.NSFW,
      onChanged: (value) => setState(() {
        if (widget.type == 1) {
          ref.read(postDataProvider.notifier).updateIsSpoiler(value);
        } else {
          ref.read(postDataProvider.notifier).updateNFSW(value);
        }
      }),
      activeColor: AppColors.redditOrangeColor,
      dragStartBehavior: DragStartBehavior.start,
    );
  }
}
