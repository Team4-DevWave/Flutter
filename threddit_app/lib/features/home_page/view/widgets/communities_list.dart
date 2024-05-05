import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class CommunityList extends ConsumerStatefulWidget {
  const CommunityList({super.key, required this.searchRes});
  final List<List<String>> searchRes;

  @override
  ConsumerState<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends ConsumerState<CommunityList> {
  bool _isLoading = false;
  List<List<String>> _communityData = [[]];
  Future<void> _fetchCommunities() async {
    setState(() {
      _isLoading = true;
    });

    final response =
        await ref.read(userCommunitisProvider.notifier).getUserCommunities();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (list) {
      setState(() {
        _communityData = list;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _fetchCommunities();
    super.initState();
  }

  ImageProvider putProfilepic(String commLink) {
    if (commLink == "") {
      return const NetworkImage(
          "https://st2.depositphotos.com/1432405/8410/v/450/depositphotos_84106432-stock-illustration-saturn-icon-simple.jpg");
    } else {
      return NetworkImage(commLink);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dispalyedData =
        widget.searchRes.isEmpty ? _communityData : widget.searchRes;

    return _isLoading
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Loading(),
          )
        : Column(children: [
            ...dispalyedData.map(
              (community) => ListTile(
                onTap: () {
                  ref
                      .read(postDataProvider.notifier)
                      .updateCommunityName(community[0]);
                  Navigator.pushReplacementNamed(
                      context, RouteClass.confirmPostScreen);
                },
                leading: CircleAvatar(
                  radius: 10,
                  backgroundImage: putProfilepic(community[1]),
                ),
                title: Text(community[0],
                    style: AppTextStyles.primaryTextStyle.copyWith(
                      fontSize: 20.spMin,
                    )),
              ),
            )
          ]);
  }
}
