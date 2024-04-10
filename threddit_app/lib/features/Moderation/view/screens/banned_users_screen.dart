import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/model/banned_user.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

class BannedUsersScreen extends ConsumerStatefulWidget {
  const BannedUsersScreen({super.key});
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BannedUsersScreenState();
}

class _BannedUsersScreenState extends ConsumerState<BannedUsersScreen> {
  final client = http.Client();
  Future<List<BannedUser>> fetchBannedUsers() async {
    setState(() {
      ref.watch(moderationApisProvider.notifier).getBannedUsers(client: client);
    });
    return ref
        .watch(moderationApisProvider.notifier)
        .getBannedUsers(client: client);
  }

  String bannedOption = "";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Banned users"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteClass.banScreen)
                    .then((value) => setState(() {
                          ref
                              .watch(moderationApisProvider.notifier)
                              .getBannedUsers(client: client);
                        }));
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: fetchBannedUsers(),
        builder: (context, snapshot) {
          {
            if (snapshot.connectionState == ConnectionState.waiting)
              return const Center(child: CircularProgressIndicator());
            else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              final bannedUsers = snapshot.data!;
              return ListView.builder(
                itemCount: bannedUsers.length,
                itemBuilder: (context, index) {
                  final username = bannedUsers[index].getUsername;
                  print(username);
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text("u/$username",
                        style: AppTextStyles.primaryTextStyle),
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
                                  Navigator.pop(context);
                                },
                                title: Text(
                                  "See details",
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
                                leading: const FaIcon(FontAwesomeIcons.hammer),
                                onTap: () async{
                                  setState(() {
                                     ref
                                        .watch(moderationApisProvider.notifier)
                                        .unbanUser(
                                            client: client, username: username);
                                    Navigator.pop(context);
                                  });
                                },
                                title: Text(
                                  "Unban",
                                  style: AppTextStyles.primaryTextStyle,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
