import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/Moderation/model/moderator.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_suggestion_view.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class Search extends SearchDelegate<String> {
  
  @override
  TextStyle? get searchFieldStyle => AppTextStyles.primaryTextStyle;
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        foregroundColor: AppColors.whiteGlowColor,
        titleTextStyle: AppTextStyles.primaryTextStyle,
        backgroundColor:
            AppColors.backgroundColor, // Adjust color for dark mode
        iconTheme: theme.iconTheme.copyWith(
            color: const Color.fromARGB(
                255, 138, 124, 124)), // Adjust icon color for dark mode
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, " ");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    return SearchSuggestionsView(query: query);
  }
}
