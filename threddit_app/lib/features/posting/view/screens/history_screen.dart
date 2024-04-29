import 'package:flutter/material.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/posting/view/widgets/post_card.dart';
import 'package:threddit_clone/features/posting/view/widgets/shared_post_card.dart';

import 'package:threddit_clone/features/posting/view_model/history_manager.dart';

/// This widget displays the history screen
/// It displays the history of the user and which pots he had previously viewed 
/// it uses the shared prefrences to store the history of the user

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.uid});
  final String uid;
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Post> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await HistoryManager.getHistory();
    setState(() {
      _history = history.reversed
          .toList(); // Reverse the list to display the latest posts first
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        
      ),
      floatingActionButton: FloatingActionButton.extended(
    onPressed: () {HistoryManager.clearHistory();
    setState(() {
      _history.clear();
    });
    },
    label: const Text('Clear History'),
    icon: const Icon(Icons.delete),
  ),
      body: _history.isEmpty
          ? const Center(
              child: Text('No history available'),
            )
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final post = _history[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteClass.postScreen,
                        arguments: {
                          'currentpost': post,
                          'uid': widget.uid,
                        },
                      );
                    },
                    child: post.parentPost == null
                        ? PostCard(
                            post: post,
                            uid: widget.uid,
                          )
                        : SharedPostCard(
                            post: post,
                            uid: widget.uid,
                          ),
                  ),
                );
              },
            ),
    );
  }
}
