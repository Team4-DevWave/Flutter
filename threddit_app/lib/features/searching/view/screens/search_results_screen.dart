import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/searching/view_model/searching_apis.dart';
import 'package:threddit_clone/theme/theme.dart';

class SearchResultsScreen extends ConsumerWidget {
  final String query;
  const SearchResultsScreen({required this.query});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.read(searchFutureProvider(query));
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(
                text: "Posts",
              ),
              Tab(
                text: "Subreddits",
              ),
              Tab(
                text: "Comments",
              ),
              Tab(
                text: "Media",
              ),
            ]),
          ),
          body: TabBarView(children: [
            ListView.builder(itemBuilder: (context, index) {
              searchResults.when(
                  data: (data) {
                    Center(
                      child: Text(data.comments[1].content),
                    );
                  },
                  error: (error, stackTrace) {
                    Center(
                      child: Text("error:"),
                    );
                  },
                  loading: () => const CircularProgressIndicator());
            }),
            ListView.builder(itemBuilder: (context, index) {
              searchResults.when(
                  data: (data) {
                    Center(
                      child: Text(data.comments[1].content),
                    );
                  },
                  error: (error, stackTrace) {
                    Center(
                      child: Text("error:"),
                    );
                  },
                  loading: () => const CircularProgressIndicator());
            }),
            ListView.builder(itemBuilder: (context, index) {
              searchResults.when(
                  data: (data) {
                    Center(
                      child: Text(data.comments[1].content),
                    );
                  },
                  error: (error, stackTrace) {
                    Center(
                      child: Text("error:"),
                    );
                  },
                  loading: () => const CircularProgressIndicator());
            }),
            ListView.builder(itemBuilder: (context, index) {
              searchResults.when(
                  data: (data) {
                    Center(
                      child: Text(data.comments[1].content),
                    );
                  },
                  error: (error, stackTrace) {
                    Center(
                      child: Text("error:"),
                    );
                  },
                  loading: () => const CircularProgressIndicator());
            }),
            
          ]),
        ));
  }
}
