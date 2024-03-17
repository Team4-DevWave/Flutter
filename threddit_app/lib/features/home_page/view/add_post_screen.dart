//import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:threddit_app/features/home_page/home_page_provider.dart';
import 'package:threddit_app/features/home_page/view/widgets/image_picker.dart';
import 'package:threddit_app/features/home_page/view/widgets/next_button.dart';
//import 'package:threddit_app/features/home_page/view/home_screen.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_app/theme/colors.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  late String postTitle;
  late String postBody;
  late TextEditingController _titleController;
  late TextEditingController _bodytextController;

  ///add image picker data
  final ImagePicker picker = ImagePicker();
  List<XFile>? _imagesList;

  Future<void> _pickMulti() async {
    final pickedList = await picker.pickMultiImage();
    if (pickedList.isEmpty) return;
    setState(() {
      _imagesList = pickedList;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodytextController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodytextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///a widget for the image
    Widget content = Container();

    if (_imagesList != null) {
      content = SizedBox(
        height: 150,
        width: double.maxFinite,
        child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            scrollDirection: Axis.horizontal,
            itemCount: _imagesList!.length,
            itemBuilder: (context, index) {
                return Image.file(
                  File(_imagesList![index].path),
                  width: MediaQuery.of(context).size.width - 8,
                  fit: BoxFit.cover,
                );
            }),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              ref.read(currentScreenProvider.notifier).returnToPrevious();
            },
            icon: const Icon(Icons.close)),
        actions: [
          NextButton(titleController: _titleController),
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(
                    fontSize: 24, color: AppColors.realWhiteColor),
                cursorColor: AppColors.redditOrangeColor,
                cursorWidth: 1.5,
                decoration: const InputDecoration(
                    labelText: 'Title',
                    focusColor: null,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    labelStyle: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
                onChanged: (value) => {
                  setState(() {
                    postTitle = value;
                  })
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: content,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _bodytextController,
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.realWhiteColor),
                    cursorColor: AppColors.redditOrangeColor,
                    cursorWidth: 1.5,
                    decoration: const InputDecoration(
                        labelText: 'body text (optional)',
                        focusColor: null,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelStyle: TextStyle(
                            color: AppColors.whiteColor, fontSize: 16)),
                    onChanged: (value) => {
                          setState(() {
                            postBody = value;
                          })
                        }),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _pickMulti,
                  icon: const Icon(Icons.image),
                  color: AppColors.realWhiteColor,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.link),
                  color: AppColors.realWhiteColor,
                ),
              ],
            )
          ]),
    );
  }
}
