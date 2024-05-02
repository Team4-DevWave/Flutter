import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/chatting/model/chat_repository.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class RenameChatroom extends ConsumerStatefulWidget {
  RenameChatroom(
      {super.key, required this.username, required this.chatroom});
  final String username;
  Chatroom chatroom;
  @override
  _RenameChatroomState createState() => _RenameChatroomState();
}

class _RenameChatroomState extends ConsumerState<RenameChatroom>
    with SingleTickerProviderStateMixin {
  String initialName = '';
  final TextEditingController _groupNameController = TextEditingController();
  bool _isedited = false;
  @override
  void initState() {
    initialName = widget.chatroom.chatroomName;
    _groupNameController.text = initialName;
    super.initState();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void renameChatroomfn(
      BuildContext context, String editedName, String chatId) async {
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
              Text('editing group chat name....'),
            ],
          ),
        );
      },
    );

    try {
      await ref.read(renameChatroom((
        chatName: _groupNameController.text,
        chatroomId: widget.chatroom.id
      )));
      widget.chatroom.chatroomName = editedName;
      Navigator.pop(context);
      showSnackBar(context, "renamed chatroom to $editedName");
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
            "Rename",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (_isedited) {
                  renameChatroomfn(context, _groupNameController.text,
                      widget.chatroom.id);
                } else {
                  return;
                }
              },
              child: Text(
                "Save",
                style: TextStyle(
                    color: _isedited
                        ? Colors.white
                        : const Color.fromARGB(105, 255, 255, 255),
                    fontSize: 16.sp),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0.sp),
          child: Column(
            children: [
              TextFormField(
                controller: _groupNameController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.primaryTextStyle,
                maxLength: 50,
                cursorColor: AppColors.redditOrangeColor,
                decoration: InputDecoration(
                  hintText: _groupNameController.text,
                  hintStyle: AppTextStyles.primaryTextStyle,
                  filled: true,
                  fillColor: AppColors.registerButtonColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: AppColors.whiteColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: AppColors.errorColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: AppColors.errorColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 18.0.h, horizontal: 20.0.w),
                  counter: const SizedBox.shrink(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  value == initialName ? _isedited = false : _isedited = true;
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
