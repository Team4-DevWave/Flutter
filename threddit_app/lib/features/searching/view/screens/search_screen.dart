import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';

class SearchScreen extends ConsumerStatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
 final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
        child: Column(
          children: [
            TextFormField(
                   controller: searchController,
                    onChanged: (text) {
                        ref.read(searchingApisProvider.notifier).search(text);
                        ref.read(searchInputProvider.notifier).state = text;
                        setState(() {
                          

                        });
                    },
            ),
            Expanded(
              child: ref.watch(searchFutureProvider).when(
                  data: (data) {
                    print('final data length : ${data?.posts.length}');
                    return ListView.builder(
                        itemCount: data?.posts.length ?? 0,
                        itemBuilder: (_, int index) {
                          return ListTile(
                            dense: true,
                            title:  Text("TEST")
                          );
                        });
                  },
                  error: (e, s) => Center(child: Text("ERROR")),
                  loading: () => Center(child: CircularProgressIndicator())),
            )
          ],
        ),
      ),
    );
  }
}
