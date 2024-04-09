import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/models/fetch_community.dart';

class CommunityInfo extends ConsumerWidget {
  const CommunityInfo({Key? key, required this.community, required this.uid})
      : super(key: key);

  final FetchCommunity community;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCustomAppBar(context),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'About',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (community.subredditDescription != '')
                          Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    community.subredditDescription,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              )
                            ],
                          ),
                        const SizedBox(height: 15),
                        if (community.rules.isNotEmpty)
                          Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    'Rules',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              for (var rule in community.rules)
                                Row(
                                  children: [
                                    Text(
                                      rule,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                // TODO add moderators but need to add their usernames and not the uid
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      height: 105.0, // Adjust the height as needed
      decoration: BoxDecoration(
        image: DecorationImage(
          opacity: 0.7,
          image: NetworkImage(community.communitySettings.subredditBanner),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(223, 49, 49, 49)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.white, // Set the color of the icon
            ),
            title: Text(
              'r/${community.subredditTitle}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            actions: [
              community.moderators.contains(uid)
                  ? TextButton(
                      onPressed: () {Navigator.pushNamed(context, RouteClass.communityModTools);},
                      child: const Text('Mod Tools'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(223, 49, 49, 49)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      children: [
                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                          style: ButtonStyle(
                            iconColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(223, 49, 49, 49)),
                          ),
                        ),
                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          style: ButtonStyle(
                            iconColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(223, 49, 49, 49)),
                          ),
                        ),
                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                          style: ButtonStyle(
                            iconColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(223, 49, 49, 49)),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ],
      ),
    );
  }
}
