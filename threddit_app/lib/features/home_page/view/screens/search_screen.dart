import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/features/home_page/view/widgets/search_bar_widget.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class SearchScreen extends ConsumerStatefulWidget{
  const SearchScreen({super.key});

  ConsumerState<SearchScreen> createState() =>  _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, size: 22, color: AppColors.realWhiteColor,),
        ),
        title: SearchBarWidget(hintText: "Search Reddit", onTextChange: (text){}),
            ),
      );

  }
}