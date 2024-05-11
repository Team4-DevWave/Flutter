import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';
import 'package:threddit_clone/theme/theme.dart';

class PostInsightsScreen extends ConsumerStatefulWidget {
  const PostInsightsScreen({super.key, required this.uid, required this.post});
  final String uid;
  final Post post;
  @override
  _PostInsightsScreenState createState() => _PostInsightsScreenState();
}

class _PostInsightsScreenState extends ConsumerState<PostInsightsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post Insights',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer(
          builder: (context, watch, child) {
            // ignore: non_constant_identifier_names
            final AsyncInsights = ref.watch(getPostInsights(widget.post.id));
            return AsyncInsights.when(
              data: (insights) {
                return Padding(
                  padding: EdgeInsets.only(top:50.0.h),
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      _buildInsightBlock(
                        context,
                        'Views',
                        insights.numViews.toString(),
                        Icons.visibility,
                      ),
                      _buildInsightBlock(
                        context,
                        'Upvotes Rate',
                        insights.upvotesRate.toStringAsFixed(2),
                        Icons.thumb_up,
                      ),
                      _buildInsightBlock(
                        context,
                        'Comments',
                        insights.numComments.toString(),
                        Icons.comment,
                      ),
                      _buildInsightBlock(
                        context,
                        'Shares',
                        insights.numShares.toString(),
                        Icons.share,
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Loading(),
              error: (error, stack) => Text('Error: $error'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInsightBlock(
      BuildContext context, String label, String value, IconData iconData) {
    return Container(
      margin: EdgeInsets.all(8.0.sp),
      padding: EdgeInsets.all(16.0.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Theme.of(context).primaryColor,
            size: 32.0,
          ),
          SizedBox(height: 8.0.h),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              
            ),
          ),
          SizedBox(height: 4.0.h),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
