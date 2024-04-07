import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/commenting/view/widgets/comment_item.dart';
import 'package:threddit_clone/features/commenting/view/widgets/add_comment.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/models/post.dart';
import 'package:threddit_clone/features/posting/view/widgets/post_card.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/features/commenting/view_model/comment_provider.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class PostScreen extends ConsumerStatefulWidget {
  final Post currentPost;
  const PostScreen({super.key, required this.currentPost});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  @override
  void initState() {
    super.initState();
  }

  
  void _openAddCommentOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddComment(
              postID: widget.currentPost.id,
              uid: 'user2',
            ));
  }

 @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(199, 10, 10, 10),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(
                            context, RouteClass.mainLayoutScreen);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                Builder(
                  // Use Builder to obtain a Scaffold's context
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
                const SizedBox(width: 5)
              ],
            ),
          ],
        ),
        endDrawer: Drawer(
        backgroundColor: AppColors.mainColor,
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteClass.userProfileScreen);
                      },
                      child: Image.asset(
                        Photos.snoLogo,
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                    Text(
                      "u/UserName",
                      style: AppTextStyles.primaryTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.person_outline,
                  color: AppColors.whiteColor,
                ),
                title: "My profile",
                onTap: () {
                  Navigator.pushNamed(context, RouteClass.postScreen);
                }),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.group_add_outlined,
                  color: AppColors.whiteColor,
                ),
                title: "Create a community",
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteClass.createCommunityScreen);
                }),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.bookmarks_outlined,
                  color: AppColors.whiteColor,
                ),
                title: "Saved",
                onTap: () {}),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.history_toggle_off_rounded,
                  color: AppColors.whiteColor,
                ),
                title: "History",
                onTap: () {}),
            RightDrawerButtons(
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.whiteColor,
                ),
                title: "Settings",
                onTap: () {
                  Navigator.pushNamed(context, RouteClass.accountSettingScreen);
                }),
          ],
        ),
      ),
        body: Consumer(
          builder: (context, watch, child) {
            var postComments =
                ref.watch(commentsProvider(widget.currentPost.id));
            return postComments.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              data: (postComments) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          PostCard(
                            post: widget.currentPost,
                            uid: 'user2',
                            onCommentPressed: _openAddCommentOverlay,
                          ),
                          const Padding(
                              padding: EdgeInsets.only(bottom: 8)),
                          if (postComments != [])
                            ...postComments
                                .map((comment) => CommentItem(
                                      comment: comment,
                                      uid: 'user2',
                                    ))
                                .toList(),
                        ],
                      ),
                    ),
                    AddComment(
                      postID: widget.currentPost.id,
                      uid: 'user2',
                      
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    ),
  );
}
}
