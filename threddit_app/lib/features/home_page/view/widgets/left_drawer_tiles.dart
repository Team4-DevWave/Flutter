import 'package:flutter/material.dart';
import 'package:threddit_app/features/home_page/model/left_drawer_data.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class LeftDrawerTiles extends StatefulWidget {
  const LeftDrawerTiles({super.key, required this.title, required this.data});

  final List<DrawerTile> data;
  final String title;
  @override
  State<LeftDrawerTiles> createState() => _LeftDrawerTilesState();
}

class _LeftDrawerTilesState extends State<LeftDrawerTiles> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.title,
        style: AppTextStyles.primaryTextStyle,
      ),
      //key: PageStorageKey(),
      children: [
        ListView.builder(
          itemCount: widget.data.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              splashColor: AppColors.whiteColor,
              child: ListTile(
                title: Text(widget.data[index].title,
                    style:
                        AppTextStyles.secondaryTextStyle.copyWith(fontSize: 14)),
                leading: widget.data[index].icon,
                iconColor: Colors.white,
                onTap: (){ 
                  //go to the community/user's profile screen
                },
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.star_border_purple500_sharp, size: 24,),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
