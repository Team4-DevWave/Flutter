import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

void moderation(
    BuildContext context, WidgetRef ref, bool isSpam, bool isLocked) async {
  showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      context: context,
      builder: (context) => StatefulBuilder(
            builder: (context, setState) => Wrap(
              children: [
                ListTile(
                  title: isSpam
                      ? Text(
                          "Already marked as spam",
                          style: AppTextStyles.primaryTextStyle,
                        )
                      : Text(
                          "Mark as spam",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                  leading: const FaIcon(FontAwesomeIcons.box),
                  onTap: isSpam
                      ? () {}
                      : () {
                          ref
                              .watch(moderationApisProvider.notifier)
                              .markSpam(spam: true)
                              .then((value) {
                            setState(() {
                              isSpam = true;
                            });
                            //Navigator.pop(context);
                          });
                        },
                ),
                ListTile(
                  title: isLocked
                      ? Text(
                          "Unlock post",
                          style: AppTextStyles.primaryTextStyle,
                        )
                      : Text(
                          "Lock post",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                  leading: isLocked
                      ? const FaIcon(
                          FontAwesomeIcons.unlock,
                        )
                      : const FaIcon(
                          FontAwesomeIcons.lock,
                        ),
                  onTap: isLocked
                      ? () {
                          ref
                              .watch(moderationApisProvider.notifier)
                              .lock(lock: false)
                              .then((value) {
                            setState(() {
                              isLocked = false;
                            });

                            //Navigator.pop(context);
                          });
                        }
                      : () {
                          ref
                              .watch(moderationApisProvider.notifier)
                              .lock(lock: true)
                              .then((value) {
                            setState(() {
                              isLocked = true;
                            });

                            //Navigator.pop(context);
                          });
                        },
                ),
              ],
            ),
          ));
}
