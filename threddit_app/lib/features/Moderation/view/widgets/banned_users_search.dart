import 'package:flutter/material.dart';
import 'package:threddit_clone/features/Moderation/model/banned_user.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class BannedUsersSearch extends SearchDelegate<BannedUser> {
  final List<BannedUser> searchTerms;

  BannedUsersSearch({required this.searchTerms});
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
            color: Color.fromARGB(
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
        close(context, BannedUser(username: "", reason: ""));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final matchQuery = query.toLowerCase().isEmpty
        ? searchTerms
        : searchTerms
            .where((user) =>
                user.username.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final BannedUser result = matchQuery[index];
        return ListTile(
          title: Text(
            "u/${result.username}",
            style: AppTextStyles.primaryTextStyle,
          ),
          subtitle: Text(result.reason),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) => Container(), 
    );
  }
}
