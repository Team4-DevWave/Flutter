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
  void search(query) async {
    if (query.isEmpty) {
      setState(() {
        usernames.clear();
      });
      return;
    }
    final List<UserMock> results = await ref
        .watch(settingsFetchProvider.notifier)
        .searchUsers(client, query);
    setState(() {
      usernames = results;
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
          child: Column(
            children: [
              TextField(
                onChanged: (query) {
                  search(query);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  labelText: 'Search',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
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
              )
            ],
          ),
        ));
  }
}
