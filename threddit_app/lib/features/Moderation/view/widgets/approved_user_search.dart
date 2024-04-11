import 'package:flutter/material.dart';
import 'package:threddit_clone/features/Moderation/model/approved_user.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ApprovedUsersSearch extends SearchDelegate<ApprovedUser> {
  final List<ApprovedUser> searchTerms;

  ApprovedUsersSearch({required this.searchTerms});
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
        close(context, ApprovedUser(username: ""));
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
        final ApprovedUser result = matchQuery[index];
        return ListTile(
          title: Text(
            "u/${result.username}",
            style: AppTextStyles.primaryTextStyle,
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Consider implementing suggestions if desired (optional)
    return ListView.builder(
      itemCount: 0, // Set to 0 to hide suggestions
      itemBuilder: (context, index) => Container(), // Empty container
    );
  }
}
