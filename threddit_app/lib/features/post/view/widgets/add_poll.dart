import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class AddPoll extends ConsumerStatefulWidget {
  const AddPoll({super.key, required this.removePoll});
  final Function()? removePoll;

  @override
  ConsumerState<AddPoll> createState() => _AddPollState();
}

class _AddPollState extends ConsumerState<AddPoll> {
  List<String> choices = []; // choices of poll
  List<TextEditingController> choiceControllers = [];
  Map<String, dynamic> poll = {};
  int duration = 1; // duration of poll in days

  _AddPollState() {
    // Initialize the choiceControllers list
    for (int i = 0; i < 5; i++) {
      choiceControllers.add(TextEditingController());
    }
  }
  @override
  void didChangeDependencies() {
    final oldPoll = ref.read(postDataProvider)!.poll;
    if (oldPoll != null) {
      duration = ref.read(postDataProvider)!.duration!;
      poll.addEntries(oldPoll.entries);
      for (int i = 0; i < 5; i++) {
        if (oldPoll.containsKey("option${i + 1}")) {
          choiceControllers[i].text = oldPoll["option${i + 1}"];
          choices.add(choiceControllers[i].text);
        }
      }
    } else {
      duration = 1;
      choices.add(choiceControllers[0].text);
      choices.add(choiceControllers[1].text);
      poll = {
        "option1": choices[0],
        "option2": choices[1],
      };
    }
    super.didChangeDependencies();
  }

  void addChoice(int index) {
    if (choices.length < 6) {
      setState(() {
        choiceControllers.add(TextEditingController(text: ""));
        choices.add(choiceControllers[index].text);
        final newPoll = <String, dynamic>{'option${index + 1}': choices[index]};
        poll.addEntries(newPoll.entries);

      });

      ref.read(postDataProvider.notifier).updatePoll(poll);
    }
  }

  //removes a choice from the poll
  void removeChoice(int index) {
    final keysList = poll.keys.toList(); // Get list of keys
    if (index < keysList.length) {
      final keyToRemove = keysList[index];

      setState(() {
        choices.removeAt(index);
        choiceControllers.removeAt(index);
        poll.remove(keyToRemove);
      });
    }
    ref.read(postDataProvider.notifier).updatePoll(poll);
  }

  void clearAll() {
    setState(() {
      for (var controller in choiceControllers) {
        controller.clear();
      }
      choices.clear();
      choices.add(choiceControllers[0].text);
      choices.add(choiceControllers[1].text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.spMin),
      child: Container(
        padding: EdgeInsets.all(10.spMin),
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid, color: Colors.white),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton<int>(
                  value: duration,
                  style: TextStyle(color: Colors.grey.shade600),
                  items: List.generate(7, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(
                        '${index + 1} days',
                      ),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      duration = value!;
                      ref
                          .read(postDataProvider.notifier)
                          .updateDuration(duration);
                    });
                  },
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    //remove the poll
                    ref.read(postDataProvider.notifier).removePoll;
                    clearAll();
                    widget.removePoll?.call();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      choices[0] = value;
                      poll['option1'] = value;
                      ref.read(postDataProvider.notifier).updatePoll(poll);
                    },
                    maxLines: 1,
                    style: AppTextStyles.primaryTextStyle,
                    controller: choiceControllers[0],
                    decoration: InputDecoration(
                        labelText: 'Choice 1',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: AppTextStyles.secondaryTextStyle),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      choices[1] = value;
                      poll['option2'] = value;
                      ref.read(postDataProvider.notifier).updatePoll(poll);
                    },
                    controller: choiceControllers[1],
                    maxLines: 1,
                    style: AppTextStyles.primaryTextStyle,
                    decoration: InputDecoration(
                        labelText: 'Choice 2',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: AppTextStyles.secondaryTextStyle),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: choices.length - 2,
              itemBuilder: (context, index) {
                final actualIndex = index + 2;
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          choices[actualIndex] = value;
                          poll['option${actualIndex + 1}'] = value;
                          ref.read(postDataProvider.notifier).updatePoll(poll);
                        },
                        maxLines: 1,
                        style: AppTextStyles.primaryTextStyle,
                        decoration: InputDecoration(
                            labelText: 'Choice ${index + 3}',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: AppTextStyles.secondaryTextStyle),
                        controller: choiceControllers[actualIndex],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () => removeChoice(actualIndex),
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: 5.h,
            ),
            choices.length < 6
                ? ElevatedButton(
                    onPressed: () {
                      addChoice(choices.length);
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            AppColors.registerButtonColor)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "Add Option",
                          style: AppTextStyles.secondaryTextStyle,
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
