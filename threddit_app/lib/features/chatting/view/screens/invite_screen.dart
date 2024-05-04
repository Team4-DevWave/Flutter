import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/chatting/model/UserModel.dart';
import 'package:threddit_clone/features/chatting/model/chat_repository.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


// ignore: must_be_immutable
class InviteScreen extends ConsumerStatefulWidget {
  InviteScreen({super.key, required this.username, required this.chatroom});
  final String username;
  Chatroom chatroom;
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends ConsumerState<InviteScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  bool isSelected = false;
  String _foundUsername = '';
  List<String> _selectedUsers = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String username) async {
    // You can customize the URL based on your API endpoint
    final url =
        Uri.parse('http://${AppConstants.local}:8000/api/v1/users/$username');
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

  void invitemembersfn(BuildContext context) async {
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
              Text('adding new members....'),
            ],
          ),
        );
      },
    );

    try {
      await ref.read(addMember((
        memberName: _selectedUsers,
        chatroomId: widget.chatroom.id,
      )).future);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      print('Error reanming chatroom: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while renaming the chatroom'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(199, 10, 10, 10),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(199, 10, 10, 10),
          title: const Text(
            "Add to Group",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                invitemembersfn(context);
              },
              child: Text(
                "Add",
                style: TextStyle(
                    color: _selectedUsers.isNotEmpty
                        ? Colors.white
                        : const Color.fromARGB(91, 255, 255, 255),
                    fontSize: 16.sp),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          onEditingComplete: () => FocusScope.of(context)
                              .nextFocus(), // Focus next field
                          style: const TextStyle(color: Colors.white),
                          onChanged: _searchUsers,
                          autofocus: true,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 19, 19, 19),
                            filled: true,
                            hintText: 'Search for a username',
                            hintStyle: const TextStyle(color: Colors.grey),
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
                          backgroundImage:
                              AssetImage('assets/images/Default_Avatar.png'),
                        ),
                        title: Row(
                          children: [
                            Text(
                              _foundUsername,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Spacer(),
                            _foundUsername == widget.username
                                ? const Text(
                                    'It\'s You',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Checkbox(
                                    value:
                                        _selectedUsers.contains(_foundUsername),
                                    onChanged: (value) {
                                      setState(() {
                                        isSelected = value ?? false;
                                        if (value == true) {
                                          _selectedUsers.add(_foundUsername);
                                        } else {
                                          _selectedUsers.remove(_foundUsername);
                                        }
                                      });
                                    },
                                  ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
