import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  List<String> usernames = [];
  void search(query) async{
    final List<String> results =
        await ref.watch(settingsFetchProvider.notifier).searchUsers(client, query);
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  labelText: 'Search',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: usernames.length ?? 0,
                    itemBuilder: (context, index) => ListTile(
                          title: Text(usernames.isEmpty ? '': usernames[index] ,
                              style: AppTextStyles.secondaryTextStyle),
                        )),
              )
            ],
          ),
        ));
  }
}
