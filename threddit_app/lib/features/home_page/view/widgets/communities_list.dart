import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class CommunityList extends ConsumerStatefulWidget {
  const CommunityList({super.key});

  @override
  ConsumerState<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends ConsumerState<CommunityList> {
  late Future<List<String>> _communityData;

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _communityData = UserCommunitiesAPI().getUserCommunities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final post = ref.read(postDataProvider);
    return FutureBuilder<List<String>>(
        future: _communityData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading(); //Placeholder while loading
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<String> dataList = snapshot.data ?? [];
            return ListView.builder(
                itemCount: dataList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String communityName = dataList[index];
                  return InkWell(
                      onTap: (){
                        ref.read(postDataProvider.notifier).state = post?.copyWith(community: communityName);
                        Navigator.pushNamed(context, RouteClass.confirmPostScreen);
                      },
                      splashColor: AppColors.whiteColor,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Text(dataList[index],
                            style: AppTextStyles.secondaryTextStyle
                                .copyWith(fontSize: 14)),
                      ));
                });
          }
        });
  }
}
