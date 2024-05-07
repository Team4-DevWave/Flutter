import 'package:flutter/material.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_post_feed_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_shared_feed_unit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

class PostSearchFeedWidget extends StatefulWidget {
  final List<Post> posts;

  const PostSearchFeedWidget({Key? key, required this.posts}) : super(key: key);

  @override
  _PostSearchFeedWidgetState createState() => _PostSearchFeedWidgetState();
}

class _PostSearchFeedWidgetState extends State<PostSearchFeedWidget> {
  late ScrollController _scrollController;
  late List<Post> _posts;
String? userId;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _posts = widget.posts;
     getUserID();
  }

  Future<void> getUserID() async {
    userId = await getUserId();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_posts.isEmpty) {
      return Center(
        child: Text(
          'No posts available.',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return _posts[index].parentPost != null
              ? Column(
                  children: [
                    SearchFeedUnitShare(
                          dataOfPost: _posts[index].parentPost!,
                          parentPost: _posts[index],
                          userId!), // Pass userId here
                    const Divider(color: Colors.white),
                  ],
                )
              : Column(
                  children: [
                    SearchFeedUnit(_posts[index], ''), // Pass userId here
                    const Divider(color: Colors.white),
                  ],
                );
        },
      );
    }
  }
}
