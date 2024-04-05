
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';
import 'package:threddit_clone/features/post/view/widgets/add_image.dart';
import 'package:threddit_clone/features/post/view/widgets/add_link.dart';
import 'package:threddit_clone/features/home_page/view_model/home_page_provider.dart';
import 'package:threddit_clone/features/post/view/widgets/next_button.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';

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
  bool isImage = false;
  bool isLink = false;


  ///add image picker data
  final ImagePicker picker = ImagePicker();
  List<XFile>? _imagesList;

  Future<void> _pickMulti() async {
    final pickedList = await picker.pickMultiImage();
    if (pickedList.isEmpty) return;
    setState(() {
      _imagesList = pickedList;
      isImage = true;
    });
  }

  Future<void> _removeImage()async{
    setState(() {
      _imagesList = null;
      isImage=false;
    });
  }

  Future<void> _addLink() async {
    setState(() {
      isLink = true;
    });
  }

  Future<void> _removeLink() async {
    setState(() {
      isLink = false;
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

    final ref = this.ref;
    PostData? post = ref.watch(postDataProvider);

    Widget buildImageContent() {
      if (_imagesList == null || isLink) {
        return const SizedBox();
      }
      return AddImageWidget(onPressed: _removeImage, imagesList: _imagesList!);
    }

    Widget buildLink() {
      if (isImage) {
        return const SizedBox();
      }
      return AddLinkWidget(removeLink: _removeLink,);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: _titleController,
                    style: const TextStyle(
                        fontSize: 24, color: AppColors.whiteGlowColor),
                    cursorColor: AppColors.redditOrangeColor,
                    cursorWidth: 1.5,
                    decoration: const InputDecoration(
                        labelText: 'Title',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                    onChanged: (value) => {
                      if(post?.title != value){
                        ref.read(postDataProvider.notifier).state = post?.copyWith(title: value)
                      },
                      setState(() {
                        postTitle = value;
                      })
                    },
                  ),
                ),
                buildImageContent(),
                isLink ? buildLink() : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
                  child: TextField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      controller: _bodytextController,
                      style: const TextStyle(
                          fontSize: 16, color: AppColors.whiteGlowColor),
                      cursorColor: AppColors.redditOrangeColor,
                      cursorWidth: 1.5,
                      decoration: const InputDecoration(
                          labelText: 'body text (optional)',
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelStyle:
                              TextStyle(color: AppColors.whiteColor, fontSize: 16)),
                      onChanged: (value) => {
                        if(post?.postBody != value){
                        ref.read(postDataProvider.notifier).state = post?.copyWith(postBody: value)
                      },
                      setState(() {
                        postBody = value;
                      })
                          }),
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: AppColors.backgroundColor,
        height: 40.h,
        child: Row(
          children: [
            IconButton(
              onPressed: !isLink ? _pickMulti : (){},
              icon: const Icon(Icons.image),
              color: isLink || isImage?  AppColors.whiteHideColor : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: !isImage ? _addLink : (){},
              icon: const Icon(Icons.link),
              color: isLink || isImage?  AppColors.whiteHideColor : AppColors.whiteGlowColor,
            ),
          ],
        ),
      ),
    );
  }
}
