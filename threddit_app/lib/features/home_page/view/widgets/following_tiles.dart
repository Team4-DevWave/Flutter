import 'package:flutter/material.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/view_model/get_user_following.dart';
import 'package:threddit_clone/features/posting/data/data.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FollowingTiles extends StatefulWidget {
  const FollowingTiles({super.key, required this.title});
  final String title;
  @override
  State<FollowingTiles> createState() => _FollowingTilesState();
}

class _FollowingTilesState extends State<FollowingTiles> {
  late Future<List<String>> _userFollowingData;

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _userFollowingData = UserFollowingAPI().getUserFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _userFollowingData,
        builder: (context, snapshot) {
           //Placeholder while loading
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

                        /// There should be an icon with the data of following but it will be
                        /// implemented when the community class is made
                        onTap: () {
                          ///go to the user's profile screen
                          
                          //temporarily using this to go to a post screen //Aya
                          Navigator.pushNamed(context, RouteClass.postScreen,
                              arguments: {
                                'currentpost': posts[0],
                                'uid': 'user2',
                              });

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
