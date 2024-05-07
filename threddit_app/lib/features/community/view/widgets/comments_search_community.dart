import 'package:flutter/material.dart';
import 'package:threddit_clone/features/searching/model/search_comment_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_comment_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

class CommunitySearchCommentFeedWidget extends StatefulWidget {
  final List<SearchCommentModel> comments;

  const CommunitySearchCommentFeedWidget({Key? key, required this.comments})
      : super(key: key);

  @override
  _CommunitySearchCommentFeedWidgetState createState() =>
      _CommunitySearchCommentFeedWidgetState();
}

class _CommunitySearchCommentFeedWidgetState extends State<CommunitySearchCommentFeedWidget> {
  late ScrollController _scrollController;
  late List<SearchCommentModel> _comments;
String? userId;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _comments = widget.comments;
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
    if (_comments.isEmpty) {
      return Center(
        child: Text(
          'No comments available.',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: _comments.length + 1,
        itemBuilder: (context, index) {
          if (index < _comments.length) {
            return Column(
              children: [
                SearchCommentItem(
                  comment: _comments[index],
                  uid: '', // Pass userId here
                  parentPost: _comments[index].post,
                ),
                const Divider(),
              ],
            );
          } else {
            return SizedBox(
              height: 75.h,
              width: 75.w,
              child: Lottie.asset(
                'assets/animation/loading.json',
                
              ),
            );
          }
        },
      );
    }
  }
}
