import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/chatting/model/UserModel.dart';
import 'package:threddit_clone/features/chatting/model/chat_repository.dart';

class NewChat extends ConsumerStatefulWidget {
  const NewChat({super.key, required this.uid});
  final String uid;
  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends ConsumerState<NewChat> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  String _foundUsername = '';
  List<String> _selectedUsers = [];
  String groupName = '';
  bool isSelected = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String username) async {
    // You can customize the URL based on your API endpoint
    final url = Uri.parse('https://www.threadit.tech/api/v1/users/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> user =
          jsonDecode(response.body)['data']['user'];
      User foundUser = User.fromJson(user);
      setState(() {
        isSelected = false;
        _foundUsername = foundUser.username;
      });
    } else {
      setState(() {
        isSelected = false;
        _foundUsername = '';
      });
      print('Error searching users: ${response.statusCode}');
    }
  }

  void createChatroomfn(BuildContext context, List<String> _selectedUsers,
      String groupName) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from being dismissed
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('redirecting to chatroom...'),
            ],
          ),
        );
      },
    );

    try {
      final chatCreationResult = await ref.read(
          createChatroom((users: _selectedUsers, groupName: groupName)).future);
      // Close the loading indicator dialog
      Navigator.pop(context);

      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        RouteClass.chatRoom,
        arguments: {
          'chatroom': chatCreationResult,
          'username': widget.uid,
        },
      );
    } catch (e) {
      // Handle error
      print('Error creating chatroom: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while creating the chatroom'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).viewInsets.bottom +
          300.h, // Adjust height as needed
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_selectedUsers.length > 1)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0.h),
                        child: TextField(
                          controller: _groupNameController,
                          onEditingComplete: () => FocusScope.of(context)
                              .nextFocus(), // Focus next field
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            setState(() {
                              groupName = value;
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 19, 19, 19),
                            filled: true,
                            hintText: 'Group Name*',
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
                              colorScheme:
                                  Theme.of(context).colorScheme.copyWith(
                                        primary: Colors
                                            .transparent, // Remove default highlight
                                      ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 10.0.h, bottom: 8.h),
                              child: TextField(
                                controller: _usernameController,
                                onEditingComplete: () => FocusScope.of(context)
                                    .nextFocus(), // Focus next field
                                style: const TextStyle(color: Colors.white),
                                onChanged: _searchUsers,
                                autofocus: true,
                                decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 19, 19, 19),
                                  filled: true,
                                  hintText: 'Search for a username',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0.w,
                                    vertical: 14.0.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _selectedUsers.map((user) {
                        return Chip(
                          backgroundColor: Colors.grey,
                          avatar: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/Default_Avatar.png'),
                          ),
                          label: Text(user),
                          deleteIcon: const Icon(Icons.cancel),
                          onDeleted: () {
                            setState(() {
                              _selectedUsers.remove(user);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0.h),
                      child: _foundUsername == ''
                          ? const Text(
                              'Search people by username to invite them to host',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(122, 255, 255, 255),
                              ),
                            )
                          : ListTile(
                              leading: const CircleAvatar(
                                radius: 20.0,
                                backgroundImage: AssetImage(
                                    'assets/images/Default_Avatar.png'),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    _foundUsername,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Spacer(),
                                  _foundUsername == widget.uid
                                      ? const Text(
                                          'It\'s You',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Checkbox(
                                          value: _selectedUsers
                                              .contains(_foundUsername),
                                          onChanged: (value) {
                                            setState(() {
                                              isSelected = value ?? false;
                                              if (value == true) {
                                                _selectedUsers
                                                    .add(_foundUsername);
                                              } else {
                                                _selectedUsers
                                                    .remove(_foundUsername);
                                              }
                                            });
                                          },
                                        ),
                                ],
                              ),
                            ),
                    ),
                    _selectedUsers.length <= 1
                        ? ElevatedButton(
                            onPressed: () async {
                              if (_selectedUsers.isEmpty) {
                                return;
                              } else {
                                createChatroomfn(
                                    context, _selectedUsers, 'New Chat');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedUsers.isNotEmpty
                                  ? Colors.blue
                                  : const Color.fromARGB(175, 90, 89,
                                      89), // Change color based on enabled state
                            ), // Handle button press
                            child: Text(
                              'Start Chat',
                              style: TextStyle(
                                  color: _selectedUsers.isNotEmpty
                                      ? Colors.white
                                      : const Color.fromARGB(
                                          81, 255, 255, 255)),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (groupName == '') {
                                return;
                              } else {
                                createChatroomfn(
                                    context, _selectedUsers, groupName);
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: groupName != ''
                                  ? Colors.blue
                                  : const Color.fromARGB(175, 90, 89,
                                      89), // Change color based on enabled state
                            ), // Handle button press
                            child: Text(
                              'Start Group Chat',
                              style: TextStyle(
                                  color: groupName != ''
                                      ? Colors.white
                                      : const Color.fromARGB(
                                          81, 255, 255, 255)),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
