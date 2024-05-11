import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/model/moderator.dart';
import 'package:threddit_clone/features/Moderation/view/widgets/moderators_search.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

enum ViewType { all, editable }
/// This screen displays a list of moderators in the subreddit, 
/// divided into two tabs: "All" and "Editable".
///  In the "All" tab, all moderators are displayed without any distinction. 
/// In the "Editable" tab, only moderators with limited permissions are shown, allowing admins to easily identify which moderators can have their permissions edited.
///  Moderators can be searched using the search bar and new moderators can be added using the add button.

class ModeratorsScreen extends ConsumerStatefulWidget {
  const ModeratorsScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ModeratorsScreenState();
}

class _ModeratorsScreenState extends ConsumerState<ModeratorsScreen> {
  final client = http.Client();
  ViewType view = ViewType.all;
  Future<List<Moderator>> fetchModerators() async {
    setState(() {
      ref.watch(moderationApisProvider.notifier).getMods(client: client);
    });
    return ref.watch(moderationApisProvider.notifier).getMods(client: client);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
            Tab(
              text: "All",
            ),
            Tab(
              text: "Editable",
            )
          ]),
          title: const Text("Moderators"),
          actions: [
            IconButton(
              onPressed: () async {
                showSearch(
                  context: context,
                  delegate: ModeratorsSearch(
                    searchTerms: await ref
                        .watch(moderationApisProvider.notifier)
                        .getMods(client: client),
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteClass.addModeratorScreen)
                    .then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: fetchModerators(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final moderators = snapshot.data as List<Moderator>;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: moderators.length,
                    itemBuilder: (context, index) {
                      final username = moderators[index].username;
                      return ListTile(
                        leading: const CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              AssetImage('assets/images/Default_Avatar.png'),
                        ),
                        title: Text(
                          "u/$username",
                          style: AppTextStyles.primaryTextStyle,
                        ),
                      );
                    },
                  );
                }
              },
            ),
            FutureBuilder(
              future: fetchModerators(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final moderators = snapshot.data as List<Moderator>;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: moderators.length,
                    itemBuilder: (context, index) {
                      final username = moderators[index].username;
                      final fullPermissions = moderators[index].fullPermissions;
                      if (fullPermissions != true) {
                        return ListTile(
                          leading: const CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                AssetImage('assets/images/Default_Avatar.png'),
                          ),
                          title: Text(
                            "u/$username",
                            style: AppTextStyles.primaryTextStyle,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: AppColors.backgroundColor,
                                context: context,
                                builder: (context) => Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.edit),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RouteClass.editModeratorScreen,
                                          arguments: username,
                                        ).then((value) {
                                          setState(() {});
                                          Navigator.pop(context);
                                        });
                                      },
                                      title: Text(
                                        "Edit permissions",
                                        style: AppTextStyles.primaryTextStyle,
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.person),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        "View profile",
                                        style: AppTextStyles.primaryTextStyle,
                                      ),
                                    ),
                                    ListTile(
                                      leading:
                                          const FaIcon(FontAwesomeIcons.xmark),
                                      onTap: () async {
                                        await ref
                                            .watch(
                                                moderationApisProvider.notifier)
                                            .unMod(
                                              client: client,
                                              username: username,
                                            );
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        "Remove",
                                        style: AppTextStyles.primaryTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                }
              },
            ), // Add the second TabBarView here if needed
          ],
        ),
      ),
    );
  }
}
