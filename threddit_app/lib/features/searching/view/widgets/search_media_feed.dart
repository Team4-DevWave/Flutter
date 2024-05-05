import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'package:threddit_clone/features/searching/model/media.dart';
import 'package:threddit_clone/features/searching/model/search_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_feed_widget.dart';
import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:video_player/video_player.dart';

class SearchMediaFeed extends ConsumerStatefulWidget {
  final String searchText;

  const SearchMediaFeed({super.key, required this.searchText});

  @override
  ConsumerState<SearchMediaFeed> createState() => _SearchMediaFeedState();
}

class _SearchMediaFeedState extends ConsumerState<SearchMediaFeed> {
  late int numbberOfvotes;
  int choiceBottum = -1; // 1 upvote 2 downvote
  final now = DateTime.now();
  late VideoPlayerController _controller;
  @override
  final _scrollController = ScrollController();
  final _media = <Media>[];
  int _currentPage = 1;
  bool _fetching = true;
  bool _fetchingFinish = true;
  String? userId;
  final List<String> tabs = ['Best', 'Hot', 'New', 'Top'];

  @override
  void initState() {
    super.initState();
    getUserID();
    _fetchMedia();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getUserID() async {
    userId = await getUserId();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMedia();
    }
  }

  Future _fetchMedia() async {

    String searchValue = ref.read(selectedSortProvider);
    final response =
        await searchTest(widget.searchText, _currentPage, sorting: searchValue);

    final SearchModel results = response;
    if (results.medias.isNotEmpty) {
      setState(() {
        _media.addAll(results.medias);
        _media.forEach((element) {
          if (element.video != null) {
            _controller = VideoPlayerController.networkUrl(
              Uri.parse(element.video!),
            )..initialize().then((_) {
                setState(() {});
              });
          }
        });
        _currentPage++;
        _fetching = true;
        if (_media.length < 10) {
          _fetchingFinish = false;
        }
      });
    } else {
      setState(() {
        _fetching = false;
        _fetchingFinish = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedSortProvider, (previous, next) {
      setState(() {
        _media.clear();
        _currentPage = 1;
        _fetching = true;
        _fetchingFinish = true;
      });
      _fetchMedia();
    });
    if (_media.isEmpty) {
      if (_fetching) {
        return Center(
          child: Lottie.asset(
            'assets/animation/loading.json',
            repeat: true,
          ),
        );
      } else {
        return Center(
          child: Text(
            'No feed available.',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownMenu<String>(
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
            ),
            textStyle: AppTextStyles.primaryTextStyle,
            dropdownMenuEntries:
                tabs.map<DropdownMenuEntry<String>>((String string) {
              return DropdownMenuEntry(value: string, label: string);
            }).toList(),
            width: 150.w,
            initialSelection: ref.read(selectedSortProvider),
            onSelected: (String? value) {
              ref.read(selectedSortProvider.notifier).state = value!;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Changed to tab $value'),
                duration: Durations.short1,
              ));
            },
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _media.length + 1,
              itemBuilder: (context, index) {
                if (index < _media.length) {
                  return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.backgroundColor),
                          borderRadius: BorderRadius.circular(
                              35) // Adjust the radius as needed
                          ),
                      child: (_media[index].image != null &&
                              _media[index].image != '')
                          ? Image(
                              height: 200.h,
                              width: 300.w,
                              fit: BoxFit.fitWidth,
                              image:
                                  NetworkImage(_media[index].image.toString()),
                            )
                          : (_media[index].video != null &&
                                  _media[index].video != '')
                              ? AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        VideoPlayer(_controller),
                                        Positioned(
                                          child: Container(
                                            width: 125.h,
                                            height: 200.w,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow_rounded,
                                              color: Colors.white,
                                              size: 32.sp,
                                            ),
                                          ),
                                        )
                                      ]),
                                )
                              : const SizedBox());
                } else {
                  return _fetchingFinish
                      ? SizedBox(
                          height: 75.h,
                          width: 75.w,
                          child: Lottie.asset(
                            'assets/animation/loading.json',
                            repeat: true,
                          ),
                        )
                      : SizedBox(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'No more posts available.',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ));
                }
              },
            ),
          ),
        ],
      );
    }
  }
}
