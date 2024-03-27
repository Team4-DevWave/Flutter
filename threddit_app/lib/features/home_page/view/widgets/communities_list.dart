import 'package:flutter/material.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommunityList extends StatefulWidget {
  const CommunityList({super.key});

  @override
  State<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  late Future<List<String>> _communityData;

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _communityData = UserCommunitiesAPI().getUserCommunities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _communityData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); //Placeholder while loading
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<String> dataList = snapshot.data ?? [];
            return ListView.builder(
                itemCount: dataList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {},
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
