import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/community/view%20model/community_provider.dart';
import 'package:threddit_clone/features/listing/view/widgets/feed_widget.dart';
import 'package:threddit_clone/models/subreddit.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  final String id;
  final String uid;
  const CommunityScreen({super.key, required this.id, required this.uid});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  String _selectedItem = 'Hot Posts'; // Initial selected item
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final communityAsyncValue = ref.watch(fetchcommunityProvider(widget.id));
    return ScreenUtilInit(
      child: Scaffold(
        body: communityAsyncValue.when(
          data: (community) => buildCommunityScreen(community),
          loading: () => Center(
            child: Lottie.asset(
              'assets/animation/loading.json',
              repeat: true,
            ),
          ),
          error: (error, stack) => const Scaffold(body:Text("community not found :( )",style: TextStyle(color:Colors.white, fontSize: 20),),),
      ),
      ),
    );
  }

  Widget buildCommunityScreen(Subreddit community) {
    community.srLooks.banner ??= "https://htmlcolorcodes.com/assets/images/colors/bright-blue-color-solid-background-1920x1080.png";
    community.srLooks.icon ??= "https://st2.depositphotos.com/1432405/8410/v/450/depositphotos_84106432-stock-illustration-saturn-icon-simple.jpg";
    bool isCurrentUserModerator = community.moderators.contains(widget.uid);

    bool isCurrentUser = community.members.contains(widget.uid);

    bool getUserState(Subreddit community) {
      if (community.moderators.contains(widget.uid)) {
        Navigator.pushNamed(context, RouteClass.communityModTools);
        return true;
      } else {
        if (community.members.contains(widget.uid)) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Leave Community'),
                        onTap: () {
                              ref.watch(unjoinCommunityProvider(widget.id));
                              community.members.remove(widget.uid);
                          setState(() {});
                          Navigator.pop(context);
                        }),
                  ],
                );
              });
          return true;
        } else {
          ref.watch(joinCommunityProvider(widget.id));
          community.members.add(widget.uid);
          setState(() {});
          
          return true;
        }
      }
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 60.h,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    community.srLooks.banner!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 53.h,
                  right: 5.w,
                  child: Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton.filled(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(223, 49, 49, 49)),
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () {},
                            icon: const Icon(Icons.share_rounded),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(223, 49, 49, 49)),
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () {},
                            icon: const Icon(Icons.more_horiz),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(223, 49, 49, 49)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.sp),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              community.srLooks.icon!),
                          radius: 30,
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'r/${community.name}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${community.members.length} members',
                              style: const TextStyle(
                                color: Color.fromARGB(108, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 110.w,
                          height: 33.h,
                          child: FilledButton(
                            onPressed: () async {
                              getUserState(community);
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 8, 46, 77))),
                            child: Text(
                              isCurrentUserModerator
                                  ? 'Mod Tools'
                                  : isCurrentUser
                                      ? 'Joined'
                                      : 'Join',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  community.description!=null?
                  Text(
                    community.description!,
                    style: const TextStyle(color: Colors.white),
                  ):const Text(
                    '',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteClass.communityInfo,
                              arguments: {
                                'community': community,
                                'uid': widget.uid,
                              });
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              Size.zero), // Ensure minimum size is zero
                          padding: MaterialStateProperty.all(
                              EdgeInsets.zero), // Remove padding
                        ),
                        child: const Text(
                          'See community info',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: Column(
        children: [
          SizedBox(
            child: Container(
              color: const Color.fromARGB(130, 12, 12, 12),
              height: 40.h,
              width: double.infinity.w,
              child: Row(
                children: [
                  SizedBox(width: 16.w), // Add some spacing

                  SizedBox(width: 8.w), // Add some spacing
                  DropdownButton<String>(
                    value: _selectedItem,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value!;
                      });
                    },
                    underline: Container(), // Hide the default underline
                    dropdownColor: const Color.fromARGB(
                        206, 0, 0, 0), // Set dropdown background color
                    items: <String>[
                      'Hot Posts',
                      'New Posts',
                      'Top Posts',
                      // 'Controversial Posts',
                      // 'Rising Posts'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(_getIcon(value), color: Colors.white),
                            SizedBox(width: 8.w),
                            Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Flexible(child: FeedWidget(feedID: _selectedItem))
        ],
      ),
    );
  }

  IconData _getIcon(String item) {
    switch (item) {
      case 'Hot Posts':
        return Icons.whatshot;
      case 'New Posts':
        return Icons.fiber_new;
      case 'Top Posts':
        return Icons.star;
      // case 'Controversial Posts':
      //   return Icons.warning;
      // case 'Rising Posts':
      //   return Icons.trending_up;
      default:
        return Icons.whatshot; // Default to hot icon
    }
  }
}
