import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/theme/text_styles.dart';
import "package:threddit_clone/features/user_system/model/token_storage.dart";

/// A placeholder screen that should show the accounts blocked by a user.
class BlockedScreen extends ConsumerStatefulWidget {
  const BlockedScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends ConsumerState<BlockedScreen> {
  String? token;
  final client = http.Client();
  List<UserMock> usernames = [];
  Future<UserModelMe> fetchBlockedUser() async {
    setState(() {
      ref
          .watch(settingsFetchProvider.notifier)
          .getMe(client: client, token: token!);
    });
    return ref
        .watch(settingsFetchProvider.notifier)
        .getMe(client: client, token: token!);
  }

  void block(query) async {
    if (query.isEmpty) {
      setState(() {
        usernames.clear();
      });
      return;
    }
    // final UserModelMe blockedUser = await ref
    //     .watch(settingsFetchProvider.notifier)
    //     .getMe(client: client, token: token!);
    // final List<UserModelMe> blockedUsers = [blockedUser];
    // final List<UserMock> results = await ref
    //     .watch(settingsFetchProvider.notifier)
    //     .searchUsers(client, query);
    // setState(() {
    //   usernames = results
    //       .where((user) => !blockedUsers
    //           .any((blocked) => blocked.getUsername == user.getUsername))
    //       .toList();
    // });
  }

  Future getUserToken() async {
    String? result = await getToken();
    print(result);
    setState(() {
      token = result!;
    });
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteClass.blockUserScreen);
                },
                icon: const Icon(Icons.add))
          ],
          title: const Text("Blocked accounts"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              FutureBuilder(
                  future: fetchBlockedUser(),
                  builder:
                      (BuildContext ctx, AsyncSnapshot<UserModelMe> snapshot) {
                    while (
                        snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Text("ERROR LOADING USER DATA");
                    } else {
                      final UserModelMe user = snapshot.data!;
                      List<String> users = user.blockedUsers!;
                      if (users.isEmpty) {
                        return SizedBox();
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) => ListTile(
                                title: Text(users[index],
                                    style: AppTextStyles.secondaryTextStyle),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      unblockUser(
                                          client: client,
                                          userToUnBlock: users[index],
                                          token: token!);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      textStyle: AppTextStyles.buttonTextStyle,
                                      backgroundColor: const Color.fromARGB(
                                          255, 0, 140, 255)),
                                  child: const Text("Unblock"),
                                )));
                      }
                    }
                  }),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: usernames.length,
                    itemBuilder: (context, index) => ListTile(
                          title: Text(
                              usernames.isEmpty
                                  ? ''
                                  : usernames[index].getUsername,
                              style: AppTextStyles.secondaryTextStyle),
                          trailing: ElevatedButton(
                            onPressed: () {
                              final username = usernames[index].getUsername;
                              if (usernames[index].getBlocked) {
                                unblockUser(
                                    client: client,
                                    userToUnBlock: username,
                                    token: token!);
                              } else {
                                blockUser(
                                    client: client,
                                    userToBlock: username,
                                    token: token!);
                              }
                              setState(() {
                                usernames[index] = usernames[index].copyWith(
                                  isBlocked: !usernames[index].getBlocked,
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                textStyle: AppTextStyles.buttonTextStyle,
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 140, 255)),
                            child: usernames[index].getBlocked
                                ? const Text("Unblock")
                                : const Text("Block"),
                          ),
                        )),
              ),
            ])));
  }
}
