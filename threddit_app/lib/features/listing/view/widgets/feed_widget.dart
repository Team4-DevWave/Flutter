import 'package:flutter/material.dart';
import 'package:threddit_app/features/listing/view/widgets/post_feed_widget.dart';
import 'package:threddit_app/features/listing/view_model/fetching_posts.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_app/theme/colors.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  late Future<PostApi> futuredata;
  @override
  void initState() {
    super.initState();
    futuredata = fetchdata('1');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: FutureBuilder<PostApi>(
          future: futuredata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: Lottie.asset(
                    'assets/animation/loading.json',
                    repeat: true,
                  ),
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
              return Text('No data available.');
            }
          },
        ));
  }
}
