import 'package:flutter/material.dart';
import 'package:threddit_app/features/home_page/view_model/left_drawer_api.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class LeftDrawerTiles extends StatefulWidget {
  const LeftDrawerTiles(
      {super.key, required this.title, required this.tileType});
  final String tileType;
  final String title;
  @override
  State<LeftDrawerTiles> createState() => _LeftDrawerTilesState();
}

class _LeftDrawerTilesState extends State<LeftDrawerTiles> {
  late Future<Map<String, List<String>>> _drawerData;

  @override
  void initState() {
    ///fetches the data when the widget is intialized
    _drawerData = LeftDrawerAPI().getDrawerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<String>>>(
        future: _drawerData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); //Placeholder while loading
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<String> dataList = widget.tileType == 'community'
                ? snapshot.data!['communities']!
                : snapshot.data!['following']!;
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
                        //leading: widget.,
                        //iconColor: Colors.white,
                        onTap: () {
                          //remove after phase 2

                          //go to the community/user's profile screen
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
