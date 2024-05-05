// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/community/view%20model/get_community_rules.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// A StatefulWidget responsible for displaying the rules of a community.
///
/// This widget fetches and displays the rules of a community and provides
/// an "I Understand" button for users to acknowledge the rules.
class RulesPage extends ConsumerStatefulWidget {
  /// Constructs a new [RulesPage] with the given [communityName].
  const RulesPage({super.key, required this.communityName});

  /// The name of the community whose rules are being displayed.
  final String communityName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RulesPageState();
}

class _RulesPageState extends ConsumerState<RulesPage> {
  bool _isLoading = false;
  List<String> _rules = [];

  /// Fetches the rules of the community.
  Future<void> _fetchCommunities() async {
    setState(() {
      _isLoading = true;
    });
    final response = await ref
        .read(getCommunityRules.notifier)
        .getCommunityRules(widget.communityName);
    response.fold(
      (failure) => showSnackBar(navigatorKey.currentContext!, failure.message),
      (list) => setState(() {
        _isLoading = false;
        _rules = list;
      }),
    );
  }

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _fetchCommunities();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(
          "Rules",
          style: AppTextStyles.boldTextStyle,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ..._rules.map(
                (rule) => Text(
                  rule,
                  style: AppTextStyles.primaryTextStyle.copyWith(
                    fontSize: 20.spMin,
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            AppColors.redditOrangeColor)),
                    child: Text(
                      "I Understand",
                      style: AppTextStyles.boldTextStyle,
                    )),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
