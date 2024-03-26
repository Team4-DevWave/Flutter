import 'package:flutter/material.dart';
import 'package:threddit_app/features/listing/view/widgets/post_feed_widget.dart';
import 'package:threddit_app/features/listing/view_model/fetching_posts.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  late Future<PostApi> futuredata;
  void initState() async {
    super.initState();
    futuredata = fetchdata('1');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FeedUnit(),
          FeedUnit(),
          FeedUnit(),
          FeedUnit(),
          FeedUnit(),
          FeedUnit(),
        ],
      ),
    );
  }
}
