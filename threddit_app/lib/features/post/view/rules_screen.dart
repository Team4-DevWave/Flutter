import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/community/view%20model/get_community.dart';

import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class RulesPage extends ConsumerStatefulWidget {
  const RulesPage({super.key, required this.communityName});
  final String communityName;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RulesPageState();
}

class _RulesPageState extends ConsumerState<RulesPage> {
  bool _isLoading = false;
  List<String> _rules = [];

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
