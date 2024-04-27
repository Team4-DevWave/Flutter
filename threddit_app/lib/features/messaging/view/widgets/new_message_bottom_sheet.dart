import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/messaging/model/message_repository.dart';

class NewMessage extends ConsumerStatefulWidget {
  const NewMessage({super.key});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends ConsumerState {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// ignore: no_leading_underscores_for_local_identifiers
    String _getErrorMessage(dynamic e) {
      if (e.toString().contains('No user found with username')) {
        return 'No user found with the provided username';
      } else {
        return 'Failed to send message. Please try again later.';
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    // Get text from controllers
                    String recipient = _usernameController.text;
                    String subject = _subjectController.text;
                    String message = _messageController.text;

                    // Call createMessage function
                    try {
                      await MessageRepository()
                          .createMessage(recipient, subject, message);
                      // If message sent successfully, show success dialog
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Message sent successfully'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      // Show error dialog based on error type
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text(_getErrorMessage(e)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0.h),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixText: 'u/',
                hintText: 'username',
                hintStyle: TextStyle(color: Color.fromARGB(104, 255, 255, 255)),
              ),

              autofocus: true,
              textInputAction: TextInputAction.next,
              onEditingComplete: () =>
                  FocusScope.of(context).nextFocus(), // Focus next field
              style: const TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0.h),
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Subject',
                hintStyle: TextStyle(color: Color.fromARGB(104, 255, 255, 255)),
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: () =>
                  FocusScope.of(context).nextFocus(), // Focus next field
              style: const TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0.h),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Message',
                hintStyle: TextStyle(color: Color.fromARGB(104, 255, 255, 255)),
                border: InputBorder.none,
              ),
              maxLines: null, // Allow multiple lines for message
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
