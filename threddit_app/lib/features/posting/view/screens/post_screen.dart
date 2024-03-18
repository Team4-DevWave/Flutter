// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:threddit_app/features/commenting/view/widgets/comment_item.dart';
// import 'package:threddit_app/features/commenting/model/comment.dart';
// import 'package:threddit_app/features/commenting/view/widgets/add_comment.dart';
// import 'package:threddit_app/features/posting/data/data.dart';
// import 'package:threddit_app/features/commenting/model/post.dart';
// import 'package:threddit_app/features/posting/view/widgets/post_card.dart';
// import 'package:threddit_app/theme/colors.dart';

// class PostScreen extends ConsumerStatefulWidget {
  
//   const PostScreen({super.key});

//   @override
//   _PostScreenState createState() => _PostScreenState();
// }

// class _PostScreenState extends ConsumerState<PostScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   void _openAddCommentOverlay() {
//     // showModalBottomSheet(
//     //     useSafeArea: true,
//     //     isScrollControlled: true,
//     //     context: context,
//     //     builder: (ctx) => AddComment(
//     //           postID: widget.currentPost.id,
//     //           uid: 'user1',
//     //         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Comment> postComments = comments
//         .where((comment) => comment.postId == widget.currentPost.id)
//         .toList();
//     return MaterialApp(
//       home: SafeArea(
//         child: Scaffold(
//           backgroundColor: const Color.fromARGB(199, 10, 10, 10),
//           appBar: AppBar(
//             iconTheme: const IconThemeData(color: Colors.white),
//             backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
//             leading: IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.arrow_back),
//             ),
//             actions: [
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.search),
//                   ),
//                   IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
//                   IconButton(
//                       onPressed: () {}, icon: const Icon(Icons.more_horiz)),
//                   Builder(
//                     // Use Builder to obtain a Scaffold's context
//                     builder: (context) => IconButton(
//                       icon: const Icon(Icons.face_2_rounded),
//                       onPressed: () => Scaffold.of(context).openEndDrawer(),
//                     ),
//                   ),
//                   const SizedBox(width: 5)
//                 ],
//               ),
//             ],
//           ),
//           endDrawer: Drawer(
//             backgroundColor: AppColors.backgroundColor,
//             width: 330,
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: <Widget>[
//                 //TODO: add drawer items
//               ],
//             ),
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: ListView(
//                   children: [
//                     PostCard(
//                       post: ,
//                       uid: 'user1',
//                       onCommentPressed: _openAddCommentOverlay,
//                     ),
//                     const Padding(padding: EdgeInsets.only(bottom: 8)),
//                     ...postComments
//                         .map((comment) => CommentItem(
//                               comment: comment,
//                               uid: 'user1',
//                             ))
//                         .toList(),
//                   ],
//                 ),
//               ),
//               AddComment(
//                 postID: widget.currentPost.id,
//                 uid: 'user1',
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
