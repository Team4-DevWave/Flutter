import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/community/view%20model/community_provider.dart';
import 'package:threddit_clone/models/fetch_community.dart';

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
    return Scaffold(
      body: communityAsyncValue.when(
        data: (community) => buildCommunityScreen(community),
        loading: () => Center(
                child: Lottie.asset(
                  'assets/animation/loading.json',
                  repeat: true,
                ),
              ),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }

  Widget buildCommunityScreen(FetchCommunity community) {
    bool isCurrentUserModerator = community.moderators.contains(widget.uid);
    bool isCurrentUser = community.listOfMembers.contains(widget.uid);
    bool getUserState(FetchCommunity community) {
      if (community.moderators.contains(widget.uid)) {
        Navigator.pushNamed(context, RouteClass.communityModTools);
        return true;
      } else {
        if (community.listOfMembers.contains(widget.uid)) {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Leave Community'),
                        onTap: () {
                          var leaveFunction =
                              ref.watch(unjoinCommunityProvider(widget.id));
                          leaveFunction(widget.uid);
                          setState(() {});
                          community.listOfMembers.remove(widget.uid);
                          Navigator.pop(context);
                        }),
                  ],
                );
              });
          return true;
        } else {
          var JoinFunction = ref.watch(joinCommunityProvider(widget.id));
          JoinFunction(widget.uid);
          setState(() {});
          community.listOfMembers.add(widget.uid);

          return true;
        }
      }
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 60,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    community.communitySettings.subredditBanner,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 53,
                  left: 5,
                  right: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(223, 49, 49, 49)),
                        ),
                      ),
                      const SizedBox(width: 205),
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
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(community.communitySettings.subredditImage),
                          radius: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'r/${community.subredditTitle}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${community.listOfMembers.length} members',
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
                          width: 110,
                          height: 33,
                          child: FilledButton(
                            onPressed: () async {
                              await getUserState(community);
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
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${community.subredditDescription}',
                    style: const TextStyle(color: Colors.white),
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
              height: 40,
              width: double.infinity,
              child: Row(
                children: [
                  const SizedBox(width: 16), // Add some spacing

                  const SizedBox(width: 8), // Add some spacing
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
                      'Controversial Posts',
                      'Rising Posts'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(_getIcon(value),
                                color: Colors.white), // Get corresponding icon
                            const SizedBox(width: 8), // Add some spacing
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
      case 'Controversial Posts':
        return Icons.warning;
      case 'Rising Posts':
        return Icons.trending_up;
      default:
        return Icons.whatshot; // Default to hot icon
    }
  }
}
