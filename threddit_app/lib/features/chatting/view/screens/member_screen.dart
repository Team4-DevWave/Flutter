import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/chatting/model/chat_repository.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';

/// This file contains the implementation of the [MemberScreen] class.
/// The [MemberScreen] class is responsible for displaying the list of members in a chat group.
/// It provides functionality to view member profiles and send direct messages to members.


// ignore: must_be_immutable
class MembersScreen extends ConsumerStatefulWidget {
  MembersScreen({super.key, required this.username, required this.chatroom});
  final String username;
  Chatroom chatroom;
  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 56, 56, 56),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(199, 10, 10, 10),
          title: const Text(
            "Members",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0.sp),
          child: ListView.builder(
            itemCount: widget.chatroom.chatroomMembers.length,
            itemBuilder: (BuildContext context, int index) {
              final member = widget.chatroom.chatroomMembers[
                  widget.chatroom.chatroomMembers.length - index - 1];
              return ListTile(
                title: Text(
                  member.username,
                  style: const TextStyle(color: Colors.white),
                ),
                leading: const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/Default_Avatar.png'),
                  radius: 20.0,
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    showDragHandle: true,
                    scrollControlDisabledMaxHeightRatio: double.infinity,
                    backgroundColor: const Color.fromARGB(199, 10, 10, 10),
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          ListTile(
                            leading:
                                const Icon(Icons.person, color: Colors.white),
                            title: Text(
                              "View ${member.username} Profile",
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              //navigate to profile
                            },
                          ),
                          if (member.username != widget.username)
                            ListTile(
                              leading: const Icon(Icons.message_sharp,
                                  color: Colors.white),
                              title: Text(
                                "Message ${member.username}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {},
                            ),
                          if (member.username != widget.username)
                            ListTile(
                              leading: const Icon(Icons.block_outlined,
                                  color: Colors.white),
                              title: Text(
                                "Block ${member.username}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {},
                            ),
                          if (member.username != widget.username &&
                              widget.chatroom.chatroomAdmin.username ==
                                  widget.username)
                            ListTile(
                              leading: const Icon(Icons.remove_circle,
                                  color: Colors.white),
                              title: Text(
                                "Remove ${member.username} from chat",
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // Prevent dialog from being dismissed
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const CircularProgressIndicator(),
                                          const SizedBox(height: 16),
                                          Text(
                                              'removing ${member.username}....'),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                ref.read(removeMember((
                                  memberName: member.username,
                                  chatroomId: widget.chatroom.id
                                )).future);
                                Navigator.pop(context);
                                showSnackBar(
                                    context, "removed ${member.username} from chat");
                                    
                                Navigator.pop(context);
                                setState(() {
                                  widget.chatroom.chatroomMembers.remove(member);
                                });
                              },
                            ),
                        ]),
                      );
                    },
                  );
                },
                tileColor: const Color.fromARGB(199, 10, 10, 10),
                trailing: member.username == widget.username
                    ? const Text(
                        "(you)",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )
                    : const Text(""),
              );
            },
          ),
        ),
      ),
    );
  }
}
