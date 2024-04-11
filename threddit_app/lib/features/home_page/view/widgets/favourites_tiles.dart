
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/view_model/favourites_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FavouriteTiles extends ConsumerStatefulWidget {
  const FavouriteTiles({super.key});
  @override
  ConsumerState<FavouriteTiles> createState() => _FavouriteTilesState();
}

class _FavouriteTilesState extends ConsumerState<FavouriteTiles> {
  @override
  Widget build(BuildContext context) {
    final List<String> favs = ref.watch(favouriteListProvider);

    Widget content = ExpansionTile(
              title: Text(
                "My favourites",
                style: AppTextStyles.primaryTextStyle,
              ),
              children: [
    ListView.builder(
        itemCount: favs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
              splashColor: AppColors.whiteColor,
              child: ListTile(
                title: Text(favs[index],
                    style: AppTextStyles.secondaryTextStyle
                        .copyWith(fontSize: 14)),
              ));
        })]);

    if(favs==[])
    {
      setState(() {
        content = const SizedBox();
      });
    }

    return content;
  }
}
