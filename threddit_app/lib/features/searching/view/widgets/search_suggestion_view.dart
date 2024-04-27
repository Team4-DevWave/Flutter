// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
// import 'package:threddit_clone/theme/theme.dart';

// class SearchSuggestionsView extends ConsumerWidget {
//   final String query;
//   const SearchSuggestionsView({required this.query});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//       ref.read(searchInputProvider.notifier).state = query;
//     final searchResult = ref.read(searchFutureProvider);
//     return ListView.builder(
//         shrinkWrap: true,
//         itemCount: searchResult.when(
//             data: (data) => data.length, error: (_, __) => 0, loading: () => 0),
//         itemBuilder: (context, index) {
//           searchResult.when(
//               data: (data) {
//                 return ListTile(title: Text(data[index]));
//               },
//               error: (_, __) => const AlertDialog(
//                     title: Text("Error loading data."),
//                   ),
//               loading: () => const CircularProgressIndicator());
//         });
//   }
// }
