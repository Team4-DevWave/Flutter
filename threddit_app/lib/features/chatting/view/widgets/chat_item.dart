import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/models/message.dart';

class ChatItem extends ConsumerStatefulWidget {
  const ChatItem({super.key, required this.message, required this.uid});
  final Message message;
  final String uid;
  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends ConsumerState<ChatItem> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(widget.message.timestamp);
    final hoursSincePost = difference.inHours;
    return GestureDetector(
      onTap: (){
        //Navigator.of(context).pushNamed(Routes.chatScreen,arguments: widget.message);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:10.0),
        child: Container(
          decoration: const BoxDecoration(
            color: const Color.fromARGB(199, 10, 10, 10),
          ),
          child: Row(children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/Default_Avatar.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(widget.message.sender,style: const TextStyle(color: const Color.fromARGB(65, 255, 255, 255),fontSize: 15,fontWeight: FontWeight.bold),),
                if(widget.message.imageUrl==null)
                Text(widget.message.text!,style: const TextStyle(color: const Color.fromARGB(73, 255, 255, 255),fontSize: 15))
                else 
                Text('${widget.message.sender} sent an image',style: TextStyle(color: const Color.fromARGB(70, 255, 255, 255)))
              ],),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                                '${hoursSincePost}h',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(65, 255, 255, 255),
                                ),
                              ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
