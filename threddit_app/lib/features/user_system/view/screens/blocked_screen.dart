import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/theme/text_styles.dart';

/// A placeholder screen that should show the accounts blocked by a user.
class BlockedScreen extends ConsumerStatefulWidget {
  const BlockedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends ConsumerState<BlockedScreen> {
  final client = http.Client();
  List<UserMock> usernames = [];
  Future<UserMock> fetchBlockedUser() async {
    setState(() {
      ref.watch(settingsFetchProvider.notifier).getBlockedUsers(client);
    });
    return ref.watch(settingsFetchProvider.notifier).getBlockedUsers(client);
  }

  void search(query) async {
    if (query.isEmpty) {
      setState(() {
        usernames.clear();
      });
      return;
    }
    final UserMock blockedUser = await ref.watch(settingsFetchProvider.notifier).getBlockedUsers(client);
    final List<UserMock> blockedUsers = [blockedUser];
    final List<UserMock> results = await ref
        .watch(settingsFetchProvider.notifier)
        .searchUsers(client, query);
    setState(() {
      usernames = results.where((user) => !blockedUsers.any((blocked) => blocked.getUsername == user.getUsername)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Blocked accounts"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              TextField(
                onChanged: (query) {
                  search(query);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  labelText: 'Block new account',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: fetchBlockedUser(),
                  builder:
                      (BuildContext ctx, AsyncSnapshot<UserMock> snapshot) {
                    while (
                        snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Text("ERROR LOADING USER DATA");
                    } else {
                      final UserMock user = snapshot.data!;
                      List<UserMock> users = [user];
                      if (user.getBlocked) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) => ListTile(
                                title: Text(users[index].getUsername,
                                    style: AppTextStyles.secondaryTextStyle),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      unblockUser(
                                          client: client,
                                          userToUnBlock: users[index].getUsername);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      textStyle: AppTextStyles.buttonTextStyle,
                                      backgroundColor: const Color.fromARGB(
                                          255, 0, 140, 255)),
                                  child: const Text("Unblock"),
                                )));
                      } else {
                        return const SizedBox();
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
                                    client: client, userToUnBlock: username);
                              } else {
                                blockUser(
                                    client: client, userToBlock: username);
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
