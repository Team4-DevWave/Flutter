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

/// A widget that displays a list of communities.
///
/// This widget displays a list of communities. The list of communities to display
/// can either be provided through the `searchRes` property (for search results) or
/// fetched from the backend using the `userCommunitisProvider`.
///
/// The widget handles loading states using a [Loading] indicator and displays a
/// list of [ListTile] widgets, each representing a community.

class CommunityList extends ConsumerStatefulWidget {
  /// Creates a [CommunityList] widget.
  ///
  /// The [searchRes] argument is required and specifies a list of communities to display.
  /// Each community is represented as a list of strings: [community name, community icon URL]
  const CommunityList({super.key, required this.searchRes});

  /// A list of communities to display, each represented as a list of strings:
  /// [community name, community icon URL].
  final List<List<String>> searchRes;

  @override
  ConsumerState<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends ConsumerState<CommunityList> {
  bool _isLoading = false;
  List<List<String>> _communityData = [[]];

  /// get user communities from thhe "getUserCommunities()" funciton in the 
  /// "userCommunitisProvider" that fetches it from the backend.
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
    /// fetches the data when the widget is intialized
    _fetchCommunities();
    super.initState();
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

  /// Chooses the profile picture based on the commLink
  /// If it is empty, it returns the default image
  /// else it returns the image in the link.
  ImageProvider putProfilepic(String commLink) {
    if (commLink == "") {
      return const NetworkImage(
          "https://st2.depositphotos.com/1432405/8410/v/450/depositphotos_84106432-stock-illustration-saturn-icon-simple.jpg");
    } else {
      return NetworkImage(commLink);
    }
  }