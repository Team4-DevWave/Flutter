

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:threddit_clone/features/posting/view_model/post_provider.dart';
// import 'package:threddit_clone/theme/colors.dart';
// import 'package:threddit_clone/theme/text_styles.dart';
// import 'package:threddit_clone/models/post.dart';
// import 'package:video_player/video_player.dart';


// class PostCard extends ConsumerStatefulWidget {
//   const PostCard(
//       {super.key,
//       required this.post,
//       required this.uid,
//       required this.onCommentPressed});
//   final Post post;
//   final String uid;
//   final VoidCallback onCommentPressed;
//   @override
//   _PostCardState createState() => _PostCardState();
// }


// class _PostCardState extends ConsumerState<PostCard> {
//   late VideoPlayerController _controller;
//   late AsyncValue<Votes> upvotes;
//   late AsyncValue<Votes> downvotes;
//   void initState() {
//     super.initState();
//     upvotes=ref.read(getUserUpvotesProvider);
//     downvotes=ref.read(getUserDownvotesProvider);
//     if (widget.post.video != null) {
//       _controller = VideoPlayerController.networkUrl(
//         Uri.parse(widget.post.video!),
//       )..initialize().then((_) {
//           setState(() {});
//         });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Dispose the controller when the widget is removed
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext) {
    
//      bool upvoteStatus = upvotes.maybeWhen(
//     data: (votes) => votes.containsPost(widget.post.id),
//     orElse: () => false,
//   );

//   bool downvoteStatus = downvotes.maybeWhen(
//     data: (votes) => votes.containsPost(widget.post.id),
//     orElse: () => false,
//   );
//   void upVotePost(WidgetRef ref) async {
    
//     }

//     void downVotePost(WidgetRef ref) async {
     
//     }
//     final now = DateTime.now();
//     final difference = now.difference(widget.post.postedTime);
//     final hoursSincePost = difference.inHours;

//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.backgroundColor,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.0),
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundImage:
//                         AssetImage('assets/images/Default_Avatar.png'),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('r/${widget.post.community}',
//                         style: AppTextStyles.primaryTextStyle.copyWith(
//                             fontSize: 12,
//                             color: const Color.fromARGB(98, 255, 255, 255),
//                             fontWeight: FontWeight.bold)),
//                     Row(
//                       children: [
//                         Text(
//                           'u/${widget.post.userID}',
//                           style: AppTextStyles.primaryTextStyle.copyWith(
//                               fontSize: 12,
//                               color: const Color.fromARGB(206, 20, 113, 190)),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         const Icon(
//                           Icons.circle,
//                           size: 4,
//                           color: Color.fromARGB(98, 255, 255, 255),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           '${hoursSincePost}h',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Color.fromARGB(110, 255, 255, 255),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 13.0),
//               child: Text(
//                 widget.post.title,
//                 style: AppTextStyles.primaryTextStyle.copyWith(
//                     color: const Color.fromARGB(238, 255, 255, 255),
//                     fontSize: 18),
//               ),
//             ),
//             if (widget.post.textBody != null)
//               Text(
//                 widget.post.textBody!,
//                 style: AppTextStyles.primaryTextStyle.copyWith(
//                     color: const Color.fromARGB(196, 255, 255, 255),
//                     fontSize: 15),
//               ),
//             if (widget.post.image != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Image.network(widget.post.image!),
//               ),
//             if (widget.post.video != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: _controller.value.isInitialized
//                     ? GestureDetector(
//                         onTap: () {
//                           if (_controller.value.isPlaying) {
//                             _controller.pause();
//                           } else {
//                             _controller.play();
//                           }
//                           setState(() {
                            
//                           });
//                         },
//                         child: AspectRatio(
//                           aspectRatio: _controller.value.aspectRatio,
//                           child: Stack(alignment: Alignment.center, children: [
//                             VideoPlayer(_controller),
//                             Positioned(
//                               child: Container(
//                                 width: 50,
//                                 height: 50,
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.5),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   _controller.value.isPlaying
//                                       ? Icons.pause
//                                       : Icons.play_arrow_rounded,
//                                   color: Colors.white,
//                                   size: 32,
//                                 ),
//                               ),
//                             )
//                           ]),
//                         ),
//                       )
//                     : CircularProgressIndicator(),
//               ),
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     upVotePost(ref);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_upward_outlined,
//                     size: 30,
//                   ),
//                   color: upvoteStatus
//                       ? const Color.fromARGB(255, 217, 77, 67)
//                       : Colors.white,
//                 ),
//                 Text(
//                   '${widget.post.votes.upvotes - widget.post.votes.downvotes == 0 ? "vote" : widget.post.votes.upvotes- widget.post.votes.downvotes}',
//                   style: AppTextStyles.primaryTextStyle
//                       .copyWith(color: AppColors.whiteColor),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     downVotePost(ref);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_downward_outlined,
//                     size: 30,
//                   ),
//                   color: downvoteStatus
//                       ? const Color.fromARGB(255, 97, 137, 212)
//                       : Colors.white,
//                 ),
//                 IconButton(
//                     onPressed: widget.onCommentPressed,
//                     icon: const Icon(Icons.comment)),
//                 Text(
//                     '${widget.post.commentsID.isEmpty ? "comment" : widget.post.commentsID.length}',
//                     style: AppTextStyles.primaryTextStyle
//                         .copyWith(color: AppColors.whiteColor)),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: widget.uid == widget.post.userID
//                         ? [
//                             IconButton(
//                                 onPressed: () {
//                                   showModalBottomSheet(
//                                       context: context,
//                                       backgroundColor:
//                                           AppColors.backgroundColor,
//                                       builder: (context) {
//                                         return Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: <Widget>[
//                                             ListTile(
//                                               title: Text(
//                                                 widget.post.spoiler
//                                                     ? 'UnMark Spoiler'
//                                                     : 'Mark Spoiler',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                   Icons.warning_rounded),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Lock Comments',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(Icons.lock),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: Text(
//                                                 widget.post.nsfw
//                                                     ? 'UnMark NSFW'
//                                                     : 'Mark NSFW',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(Icons.copy),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Distinguish as moderator',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                 Icons.star_outline_outlined,
//                                               ),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Remove post',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                 Icons.delete,
//                                               ),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Remove as spam',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                   Icons.folder_delete_outlined),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Approve',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                   Icons.verified_user_rounded),
//                                               onTap: () {},
//                                             )
//                                           ],
//                                         );
//                                       });
//                                 },
//                                 icon: const Icon(Icons.add_moderator_sharp)),
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.insights,
//                                 color: Colors.purple,
//                               ),
//                             )
//                           ]
//                         : [
//                             ElevatedButton.icon(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.ios_share_rounded,
//                                 color: Colors.white,
//                               ),
//                               label: Text("Share"),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.transparent,
//                                   foregroundColor: Colors.white),
//                             ),
//                           ],
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PostCardState extends ConsumerState<PostCard> {
//   late VideoPlayerController _controller;
//   void initState() {
//     super.initState();
//     if (widget.post.videoUrl != null) {
//       _controller = VideoPlayerController.networkUrl(
//         Uri.parse(widget.post.videoUrl!),
//       )..initialize().then((_) {
//           setState(() {});
//         });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Dispose the controller when the widget is removed
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     void upVotePost(WidgetRef ref) async {
//       final upvoteFunction = ref.read(postUpvoteProvider(widget.post));
//       upvoteFunction(widget.uid);
//       setState(() {});
//     }

//     void downVotePost(WidgetRef ref) async {
//       final downvoteFunction = ref.read(postDownvoteProvider(widget.post));
//       downvoteFunction(widget.uid);
//       setState(() {});
//     }

//     final now = DateTime.now();
//     final difference = now.difference(widget.post.postedTime);
//     final hoursSincePost = difference.inHours;

//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.backgroundColor,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8.0),
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundImage:
//                         AssetImage('assets/images/Default_Avatar.png'),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('r/${widget.post.community}',
//                         style: AppTextStyles.primaryTextStyle.copyWith(
//                             fontSize: 12,
//                             color: const Color.fromARGB(98, 255, 255, 255),
//                             fontWeight: FontWeight.bold)),
//                     Row(
//                       children: [
//                         Text(
//                           'u/${widget.post.userID}',
//                           style: AppTextStyles.primaryTextStyle.copyWith(
//                               fontSize: 12,
//                               color: const Color.fromARGB(206, 20, 113, 190)),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         const Icon(
//                           Icons.circle,
//                           size: 4,
//                           color: Color.fromARGB(98, 255, 255, 255),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           '${hoursSincePost}h',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Color.fromARGB(110, 255, 255, 255),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 13.0),
//               child: Text(
//                 widget.post.title,
//                 style: AppTextStyles.primaryTextStyle.copyWith(
//                     color: const Color.fromARGB(238, 255, 255, 255),
//                     fontSize: 18),
//               ),
//             ),
//             if (widget.post.postBody != null)
//               Text(
//                 widget.post.postBody!,
//                 style: AppTextStyles.primaryTextStyle.copyWith(
//                     color: const Color.fromARGB(196, 255, 255, 255),
//                     fontSize: 15),
//               ),
//             if (widget.post.imageUrl != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Image.network(widget.post.imageUrl!),
//               ),
//             if (widget.post.videoUrl != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: _controller.value.isInitialized
//                     ? GestureDetector(
//                         onTap: () {
//                           if (_controller.value.isPlaying) {
//                             _controller.pause();
//                           } else {
//                             _controller.play();
//                           }
//                           setState(() {
                            
//                           });
//                         },
//                         child: AspectRatio(
//                           aspectRatio: _controller.value.aspectRatio,
//                           child: Stack(alignment: Alignment.center, children: [
//                             VideoPlayer(_controller),
//                             Positioned(
//                               child: Container(
//                                 width: 50,
//                                 height: 50,
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.5),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   _controller.value.isPlaying
//                                       ? Icons.pause
//                                       : Icons.play_arrow_rounded,
//                                   color: Colors.white,
//                                   size: 32,
//                                 ),
//                               ),
//                             )
//                           ]),
//                         ),
//                       )
//                     : CircularProgressIndicator(),
//               ),
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     upVotePost(ref);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_upward_outlined,
//                     size: 30,
//                   ),
//                   color: widget.post.upvotes.contains(widget.uid)
//                       ? const Color.fromARGB(255, 217, 77, 67)
//                       : Colors.white,
//                 ),
//                 Text(
//                   '${widget.post.upvotes.length - widget.post.downvotes.length == 0 ? "vote" : widget.post.upvotes.length - widget.post.downvotes.length}',
//                   style: AppTextStyles.primaryTextStyle
//                       .copyWith(color: AppColors.whiteColor),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     downVotePost(ref);
//                   },
//                   icon: const Icon(
//                     Icons.arrow_downward_outlined,
//                     size: 30,
//                   ),
//                   color: widget.post.downvotes.contains(widget.uid)
//                       ? const Color.fromARGB(255, 97, 137, 212)
//                       : Colors.white,
//                 ),
//                 IconButton(
//                     onPressed: widget.onCommentPressed,
//                     icon: const Icon(Icons.comment)),
//                 Text(
//                     '${widget.post.commentsID.isEmpty ? "comment" : widget.post.commentsID.length}',
//                     style: AppTextStyles.primaryTextStyle
//                         .copyWith(color: AppColors.whiteColor)),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: widget.uid == widget.post.userID
//                         ? [
//                             IconButton(
//                                 onPressed: () {
//                                   showModalBottomSheet(
//                                       context: context,
//                                       backgroundColor:
//                                           AppColors.backgroundColor,
//                                       builder: (context) {
//                                         return Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: <Widget>[
//                                             ListTile(
//                                               title: Text(
//                                                 widget.post.spoiler
//                                                     ? 'UnMark Spoiler'
//                                                     : 'Mark Spoiler',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                   Icons.warning_rounded),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Lock Comments',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(Icons.lock),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: Text(
//                                                 widget.post.NSFW
//                                                     ? 'UnMark NSFW'
//                                                     : 'Mark NSFW',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(Icons.copy),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Distinguish as moderator',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                 Icons.star_outline_outlined,
//                                               ),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Remove post',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                 Icons.delete,
//                                               ),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Remove as spam',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                   Icons.folder_delete_outlined),
//                                               onTap: () {},
//                                             ),
//                                             ListTile(
//                                               title: const Text(
//                                                 'Approve',
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                               leading: const Icon(
//                                                   Icons.verified_user_rounded),
//                                               onTap: () {},
//                                             )
//                                           ],
//                                         );
//                                       });
//                                 },
//                                 icon: const Icon(Icons.add_moderator_sharp)),
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.insights,
//                                 color: Colors.purple,
//                               ),
//                             )
//                           ]
//                         : [
//                             ElevatedButton.icon(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.ios_share_rounded,
//                                 color: Colors.white,
//                               ),
//                               label: Text("Share"),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.transparent,
//                                   foregroundColor: Colors.white),
//                             ),
//                           ],
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

