import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/models/comment.dart';

class SearchResultsCommunity extends ConsumerStatefulWidget {
  const SearchResultsCommunity(
      {super.key,
      required this.posts,
      required this.comments,
      required this.communityName,
      required this.serachedItem});
  final List<Post> posts;
  final List<Comment> comments;
  final String communityName;
  final String serachedItem;

  @override
  _SearchResultsCommunityState createState() => _SearchResultsCommunityState();
}

class _SearchResultsCommunityState extends ConsumerState<SearchResultsCommunity>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        
        titleSpacing: BorderSide.strokeAlignCenter,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          title: TextField(
            style: const TextStyle(color: Colors.white),
            onTap: () {
              Navigator.pop(context);
            },
            
            decoration: InputDecoration(
              
              fillColor: const Color.fromARGB(168, 34, 34, 34),
              filled: true,
              hintText: widget.serachedItem,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: const Color.fromARGB(255, 221, 106, 24),
                    labelColor: Colors.white,
                    tabs: const [
                      Tab(text: 'Posts'),
                      Tab(text: 'Comments'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [],
        ),
      ),
    );
  }
}
