import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/model/approved_user.dart';
import 'package:threddit_clone/features/Moderation/view/widgets/approved_user_search.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

class ApprovedUsersScreen extends ConsumerStatefulWidget {
  const ApprovedUsersScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApprovedUsersScreenState();
}

class _ApprovedUsersScreenState extends ConsumerState<ApprovedUsersScreen> {
  final client = http.Client();
  Future<List<ApprovedUser>> fetchApprovedUsers() async {
    setState(() {
      ref
          .watch(moderationApisProvider.notifier)
          .getApprovedUsers(client: client);
    });
    return ref
        .watch(moderationApisProvider.notifier)
        .getApprovedUsers(client: client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approved users"),
        actions: [
          IconButton(
              onPressed: () async {
                showSearch(
                    context: context,
                    delegate: ApprovedUsersSearch(
                        searchTerms: await ref
                            .watch(moderationApisProvider.notifier)
                            .getApprovedUsers(client: client)));
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteClass.approveScreen)
                    .then((value) => setState(() {
                          ref
                              .watch(moderationApisProvider.notifier)
                              .getApprovedUsers(client: client);
                        }));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: fetchApprovedUsers(),
        builder: (context, snapshot) {
          {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              final approvedUsers = snapshot.data!;
              return ListView.builder(
                itemCount: approvedUsers.length,
                itemBuilder: (context, index) {
                  final username = approvedUsers[index].getUsername;
                  return ListTile(
                    leading: const CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        AssetImage('assets/images/Default_Avatar.png'),
                  ),
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
                                onTap: () {},
                                title: Text(
                                  "Send Message",
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
                                leading: const FaIcon(FontAwesomeIcons.xmark),
                                onTap: () async {
                                  setState(() {
                                    ref
                                        .watch(moderationApisProvider.notifier)
                                        .removeUser(
                                            client: client, username: username);
                                    Navigator.pop(context);
                                  });
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
                },
              );
            }
          }
        },
      ),
    );
  }
}
