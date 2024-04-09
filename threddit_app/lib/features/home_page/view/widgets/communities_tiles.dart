import 'package:flutter/material.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_communities.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommunitiesTiles extends StatefulWidget {
  const CommunitiesTiles({super.key, required this.title});
  final String title;
  @override
  State<CommunitiesTiles> createState() => _CommunitiesTilesState();
}

class _CommunitiesTilesState extends State<CommunitiesTiles> {
  late Future<List<String>> _userCommunitiesData;

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _userCommunitiesData = UserCommunitiesAPI().getUserCommunities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _userCommunitiesData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<String> dataList = snapshot.data ?? [];
            return ExpansionTile(
              title: Text(
                widget.title,
                style: AppTextStyles.primaryTextStyle,
              ),
              children: [
                ListView.builder(
                  itemCount: dataList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: AppColors.whiteColor,
                      child: ListTile(
                        title: Text(dataList[index],
                            style: AppTextStyles.secondaryTextStyle
                                .copyWith(fontSize: 14)),
                        /// There should be an icon with the data of community but it will be
                        /// implemented when the community class is made
                        onTap: () {
                          ///go to the community/user's profile screen
                           
                        },
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.star_border_purple500_sharp,
                            size: 24,
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          }
        });
  }
}
