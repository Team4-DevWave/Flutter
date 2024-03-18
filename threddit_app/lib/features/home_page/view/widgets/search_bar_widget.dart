import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/theme/colors.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget(
      {super.key, required this.hintText, required this.onTextChange, this.textController});

  final String hintText;
  //the text editing controller will probably be removed and replaced by providers
  final TextEditingController?textController;
  final void Function(String) onTextChange;
  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Adjust the height of the container
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20), // Make edges circular
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
         const Icon(
            Icons.search,
            color: AppColors.whiteColor,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextField(
                style: const TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 144, 145, 144),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                onChanged: widget.onTextChange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
