import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/commenting/view/widgets/comment_item.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedScreen.dart';
import 'package:threddit_clone/features/listing/view/widgets/post_feed_widget.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/models/comment.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  TabController? _tabController;
  bool _isLoading = false;
  List<Post> _savedPosts = [];
  List<Comment> _savedComments = [];

  Future<void> _getSaved() async {
    setState(() {
      _isLoading = true;
    });
    final response = await ref.read(savePostProvider.notifier).getSaved();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (tuple) {
      setState(() {
        _savedPosts = tuple.item1;
        _savedComments = tuple.item2;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    _getSaved();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(updatesSaveProvider, (previous, current) {
      if (current != null && _savedPosts.any((post) => post.id == current)) {
        _getSaved();
      }
      if (current != null &&
          _savedComments.any((comment) => comment.id == current)) {
        _getSaved();
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: AppColors.blueColor,
              labelColor: AppColors.whiteColor,
              labelStyle: AppTextStyles.primaryTextStyle
                  .copyWith(fontSize: 17.spMin, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(
                  text: "Posts",
                ),
                Tab(
                  text: "Comments",
                )
              ]),
          title: Text(
            "Saved",
            style: AppTextStyles.primaryTextStyle
                .copyWith(fontSize: 25.spMin, fontWeight: FontWeight.w400),
          ),
        ),
        body: _isLoading
            ? const Loading()
            : TabBarView(
                controller: _tabController,
                children: [
                  _savedPosts.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning_amber,
                              color: AppColors.whiteGlowColor,
                            ),
                            Text(
                              "Wow, such empty in Posts!",
                              style: AppTextStyles.primaryTextStyle,
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: _savedPosts.length,
                          itemBuilder: (context, index) {
                            final post = _savedPosts[index];
                            return post.parentPost != null
                                ? FeedUnitShare(
                                    dataOfPost: post.parentPost!,
                                    parentPost: post,
                                    ref.watch(userModelProvider)!.id!)
                                : FeedUnit(
                                    post, ref.watch(userModelProvider)!.id!);
                          },
                        ),
                  _savedComments.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning_amber,
                              color: AppColors.whiteGlowColor,
                            ),
                            Text(
                              "Wow, such empty in Comments!",
                              style: AppTextStyles.primaryTextStyle,
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ..._savedComments.map(
                                (comment) => CommentItem(
                                  comment: comment,
                                  uid: ref.watch(userModelProvider)!.id!,
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
      ),
    );
  }
}
