import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:threddit_app/features/home_page/home_page_provider.dart';
import 'package:threddit_app/theme/colors.dart';

class PostToScreen extends ConsumerStatefulWidget {
  const PostToScreen({super.key});
  @override
  ConsumerState<PostToScreen> createState() => _PostToScreenState();
}

class _PostToScreenState extends ConsumerState<PostToScreen> {
  late TextEditingController _communityText;

  @override
  void initState() {
    super.initState();
    _communityText = TextEditingController();
  }

  @override
  void dispose() {
    _communityText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        title: const Text(
          'Post to',
          style: TextStyle(
              color: AppColors.realWhiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _communityText,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              maxLines: 1,
              decoration:  InputDecoration(
                  prefixIcon: _communityText.text.isEmpty?  Icon(Icons.search) :  null,
                  border: InputBorder.none,
                  fillColor: const Color.fromARGB(255, 11, 7, 7),
                  labelText: 'Search for a community',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 144, 145, 144),
                  )),
              onChanged: (String? value) => setState(
                () {
                  _communityText.text = value!;
                },
              ),
            ),
            Container(
                //child: get communities from database
                )
          ],
        ),
      ),
    );
  }
}
