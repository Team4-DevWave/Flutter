// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:threddit_clone/app/route.dart';
// import 'package:threddit_clone/features/Moderation/view/widgets/moderators_search.dart';
// import 'package:threddit_clone/theme/colors.dart';
// import 'package:threddit_clone/theme/text_styles.dart';

// class SavedScreen extends ConsumerStatefulWidget {
//   const SavedScreen({super.key});
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _SavedScreenState();
// }

// class _SavedScreenState extends ConsumerState<SavedScreen> {
//   Future<void> _getSaved() async {
//     // final history = await HistoryManager.getHistory();
//     // setState(() {
//     //   _history = history.reversed
//     //       .toList(); // Reverse the list to display the latest posts first
//     // });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getSaved();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           bottom: TabBar(
//               indicatorSize: TabBarIndicatorSize.tab,
//               indicatorColor: AppColors.blueColor,
//               labelColor: AppColors.whiteColor,
//               labelStyle: AppTextStyles.primaryTextStyle
//                   .copyWith(fontSize: 17.spMin, fontWeight: FontWeight.w600),
//               tabs: const [
//                 Tab(
//                   text: "Posts",
//                 ),
//                 Tab(
//                   text: "Comments",
//                 )
//               ]),
//           title: Text(
//             "Saved",
//             style: AppTextStyles.primaryTextStyle
//                 .copyWith(fontSize: 25.spMin, fontWeight: FontWeight.w400),
//           ),
//         ),
//         body:   _history.isEmpty
//           ? const Center(
//               child: Text('No history available'),
//             )
//           : ListView.builder(
//               itemCount: _history.length,
//               itemBuilder: (context, index) {
//                 final post = _history[index];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(
//                         context,
//                         RouteClass.postScreen,
//                         arguments: {
//                           'currentpost': post,
//                           'uid': widget.uid,
//                         },
//                       );
//                     },
//                     child: post.parentPost == null
//                         ? PostCard(
//                             post: post,
//                             uid: widget.uid,
//                           )
//                         : SharedPostCard(
//                             post: post,
//                             uid: widget.uid,
//                           ),
//                   ),
//                 );
//               },
//             ),
//       ),
//     );
//   }
// }
