import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';
// ignore: must_be_immutable
class PollWidget extends ConsumerStatefulWidget {
  String postId;
  String? userVote;
   int votes;
  final List<String> options;

  PollWidget(
      {super.key,
      required this.votes,
      required this.options,
      required this.userVote,
      required this.postId});

  @override
  _PollWidgetState createState() => _PollWidgetState();
}

class _PollWidgetState extends ConsumerState<PollWidget> {
  // ... (State management for selected options and vote counts)
  String? pollVote;
  @override
  void initState() {
    pollVote = widget.userVote;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(
              108, 255, 255, 255), // Specify the border color
          width: 0.4,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "${widget.votes} Votes",
                    style: const TextStyle(
                      color: Color.fromARGB(118, 255, 255, 255),
                      fontSize: 14,
                    ),
                  ),
                ),
                // Add a horizontal divider
              ],
            ),
            const Divider(
              color: Color.fromARGB(118, 255, 255, 255),
            ),

            // Add radio buttons for each option
            Column(
              children: widget.options.map<Widget>((option) {
                return Row(
                  children: [
                    Radio<String>(
                      value: option,
                      activeColor: Colors.white,
                      groupValue: pollVote, // Provide the selected option here
                      onChanged: (value) {
                        if (widget.userVote == '') {
                          setState(() {
                            pollVote = value!;
                          });
                        }
                      },
                    ),
                    Text(
                      option,
                      style: const TextStyle(
                          color: Color.fromARGB(118, 255, 255, 255)),
                    ),
                  ],
                );
              }).toList(),
            ),
            if (widget.userVote == '')
              Center(
                child: FilledButton(
                  onPressed: () async {
                    if(pollVote!='')
                   { await ref.watch(votePoll((postID: widget.postId, option:pollVote! )).future);
                   widget.userVote=pollVote;
                   widget.votes++;
                   setState(() {
                     
                   });

                   }
                   else{
                    return;
                   }
                  },
                  style: FilledButton.styleFrom(backgroundColor:pollVote!=''? Colors.blue:Colors.grey),
                  child: const Text(
                    "Submit Vote",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
