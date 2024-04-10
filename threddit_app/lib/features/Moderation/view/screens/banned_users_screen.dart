import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/model/banned_user.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderatio_apis.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class BannedUsersScreen extends ConsumerStatefulWidget {
  const BannedUsersScreen({super.key});
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BannedUsersScreenState();
}

class _BannedUsersScreenState extends ConsumerState<BannedUsersScreen> {
  Future<List<BannedUser>> fetchBannedUsers() async {
    return ref.watch(moderationApisProvider.notifier).getBannedUsers();
  }

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
                Navigator.pushNamed(context, RouteClass.banScreen);
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
