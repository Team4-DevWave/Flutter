import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/messaging/model/message_repository.dart';
import 'package:threddit_clone/features/messaging/view/widgets/new_message_bottom_sheet.dart';
import 'package:threddit_clone/features/notifications/view_model/notification_optian.dart';

class InboxOptionsBotttomSheet extends ConsumerStatefulWidget {
  const InboxOptionsBotttomSheet({
    super.key,
  });
  @override
  _InboxOptionsBotttomSheetState createState() =>
      _InboxOptionsBotttomSheetState();
}

class _InboxOptionsBotttomSheetState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text(
            "New message",
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.edit),
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              scrollControlDisabledMaxHeightRatio: double.infinity,
              backgroundColor: const Color.fromARGB(255, 7, 7, 7),
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: const NewMessage(),
                );
              },
            );
          },
        ),
        ListTile(
          title: const Text(
            "Mark all inbox tabs as read",
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.mark_chat_read_outlined),
          onTap: () {
            ref.read(markAllMessagesAsReadProvider);
            ref.read(markAllNotificationsAsReadProvider);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text(
            "Edit notifications settings",
            style: TextStyle(color: Colors.white),
          ),
          leading: const Icon(Icons.settings),
          onTap: () {},
        ),
      ],
    );
  }
}
