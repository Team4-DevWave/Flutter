import 'package:flutter/material.dart';

/// A placeholder screen that should show the accounts blocked by a user.
class BlockedScreen extends StatelessWidget {
  const BlockedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Blocked accounts"),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) => ListTile(
                        title: Text('Name',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      )),
            )
          ],
        ));
  }
}
