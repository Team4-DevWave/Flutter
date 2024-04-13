import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class RulesPage extends ConsumerWidget {
  const RulesPage({
    super.key,
    /*required this.communityName*/
  });
  //final String communityName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(
          "Rules",
          style: AppTextStyles.boldTextStyle,
        ),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ElevatedButton(
                onPressed: Navigator.of(context).pop,
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(AppColors.redditOrangeColor)),
                child: Text(
                  "I Understand",
                  style: AppTextStyles.boldTextStyle,
                )),
          ),
        )
      ]),
    );
  }
}
