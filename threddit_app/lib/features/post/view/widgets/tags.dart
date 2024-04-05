import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class TagsWidget extends ConsumerWidget{
  const TagsWidget({super.key, required this.post});
  final PostData?post;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.warning_amber, color: AppColors.whiteGlowColor,),
                      Text("Mark as Spoiler", style: AppTextStyles.primaryTextStyle,),
                      Switch(
                        value: post!.isSpoiler,
                        onChanged: (value) => ref
                            .read(postDataProvider.notifier)
                            .update((state) => state!.copyWith(isSpoiler: value)),
                            activeColor: AppColors.redditOrangeColor,
                            dragStartBehavior: DragStartBehavior.start,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.no_adult_content_rounded, color: AppColors.whiteGlowColor),
                      Text("Mark as NSFW", style: AppTextStyles.primaryTextStyle),
                      Switch(
                        value: post!.isNSFW,
                        onChanged: (value) => ref
                            .read(postDataProvider.notifier)
                            .update((state) => state!.copyWith(isNSFW: value)),
                            activeColor: AppColors.redditOrangeColor,
                            dragStartBehavior: DragStartBehavior.start,
                      ),
                    ],
                  ),
                ],
              ),);
  }
}