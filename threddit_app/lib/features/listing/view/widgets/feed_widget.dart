import 'package:flutter/material.dart';
import 'package:threddit_clone/features/listing/view/widgets/post_feed_widget.dart';
import 'package:threddit_clone/features/listing/view_model/fetching_posts.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/theme/colors.dart';

class FeedWidget extends StatefulWidget {
  final String feedID;
  const FeedWidget({super.key, required this.feedID});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  late Future<PostApi> futuredata;

  @override
  void initState() {
    super.initState();

    futuredata = fetchdata(widget.feedID);
  }

  @override
  Widget build(BuildContext context) {
    futuredata = fetchdata(widget.feedID);
    return Container(
        color: AppColors.backgroundColor,
        child: FutureBuilder<PostApi>(
          future: futuredata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/animation/loading.json',
                  repeat: true,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              final countryData = snapshot.data!.result;
              return ListView.builder(
                itemCount: countryData.length,
                itemBuilder: (BuildContext context, int index) {
                  return FeedUnit(countryData[index]);
                },
              );
            } else {
              return const Text('No data available.');
            }
          },
        ));
  }
}
