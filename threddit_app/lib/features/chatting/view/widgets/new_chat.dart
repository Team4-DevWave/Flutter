import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/messaging/model/message_repository.dart';

class NewChat extends ConsumerStatefulWidget {
  const NewChat({super.key});

  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends ConsumerState<NewChat> {
  final TextEditingController _usernameController = TextEditingController();
  List<String> _usernames = [];

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).viewInsets.bottom +
          200.h, // Adjust height as needed
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 36, 36, 36),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 50.h, // Adjust app bar height as desired
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 19, 19, 19),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Search for people by username to chat with them.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(122, 255, 255, 255),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                  primary: Colors
                                      .transparent, // Remove default highlight
                                ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0.h, bottom: 8.h),
                            child: TextField(
                              controller: _usernameController,
                              autofocus: true,
                              decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 19, 19, 19),
                                filled: true,
                                hintText: 'Search for a username',
                                hintStyle: const TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0.w,
                                  vertical: 14.0.h,
                                ), // Adjust padding as needed
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none, // Remove border
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.h),
                    child: const Text(
                      'Search people by username to invite them to host',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(122, 255, 255, 255),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(_usernames.isEmpty)
                      {
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _usernames.isNotEmpty
                          ? Colors.blue
                          : const Color.fromARGB(175, 90, 89, 89), // Change color based on enabled state
                    ), // Handle button press
                    child:  Text(
                      'Start Chat',
                      style: TextStyle(color: _usernames.isNotEmpty?Colors.white:const Color.fromARGB(81, 255, 255, 255)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
