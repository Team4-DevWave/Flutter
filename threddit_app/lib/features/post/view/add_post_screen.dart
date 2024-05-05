import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threddit_clone/features/post/view/widgets/add_image.dart';
import 'package:threddit_clone/features/post/view/widgets/add_link.dart';
import 'package:threddit_clone/features/post/view/widgets/add_poll.dart';
import 'package:threddit_clone/features/post/view/widgets/add_video.dart';
import 'package:threddit_clone/features/post/view/widgets/close_button.dart';
import 'package:threddit_clone/features/post/view/widgets/next_button.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';

/// The [AddPostScreen] widget allows users to create a new post by providing a title, body text, and optionally adding images, videos, or links.
///
/// Users can input a title and body text for their post. They can also add images, videos, or links to their post content.
///
/// To add an image or video, users can tap on the respective icon located in the bottom sheet. Once selected, the chosen media will be displayed in the post.
///
/// Users can remove added images or videos by tapping on the corresponding remove button.
///
/// To add a link, users can tap on the link icon located in the bottom sheet. This will enable the link input field where they can enter the desired link.
///
/// Users can navigate between different sections of the screen using the provided buttons in the app bar: a close button to discard the post and a next button to proceed.
///
/// If the user decides to discard the post, all entered data will be reset.
///
/// The [AddPostScreen] widget relies on the [postDataProvider] for managing post data state.
///
/// Example usage:
/// ```dart
/// AddPostScreen()
/// ```
class AddPostScreen extends ConsumerStatefulWidget {
  /// Constructor for [AddPostScreen].
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
  bool isVideo = false;
  bool isPoll = false;

  ///add image picker data
  final ImagePicker picker = ImagePicker();
  String? image;
  String? video;
  File? videoFile;
  File? imageFile;

  /// Function to pick an image from the gallery.
  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    imageFile = File(pickedImage.path);

    Uint8List imageBytes = await imageFile!.readAsBytes();
    setState(() {
      image = base64Encode(imageBytes);
      isImage = true;
      ref.read(postDataProvider.notifier).updateImages(image!);
      ref.read(postDataProvider.notifier).updateImagePath(imageFile!);
    });
  }

  /// Function to pick a video from the gallery.
  Future<void> _pickVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    // If the user does not select a video then return null.
    if (pickedVideo == null) return;
    videoFile = File(pickedVideo.path);
    Uint8List videoBytes = await videoFile!.readAsBytes();
    setState(() {
      video = base64Encode(videoBytes);
      isVideo = true;
      ref.read(postDataProvider.notifier).updateVideo(video!);
      ref.read(postDataProvider.notifier).updateVideoPath(videoFile!);
    });
  }

  /// Function to remove the currently selected image.
  Future<void> _removeImage() async {
    setState(() {
      image = null;
      isImage = false;
    });
  }

  /// Function to remove the currently selected video.
  Future<void> _removeVideo() async {
    setState(() {
      video = null;
      isVideo = false;
    });
  }

  /// Function to enable the link input field.
  Future<void> _addLink() async {
    setState(() {
      isLink = true;
    });
  }

  Future<void> _addPoll() async {
    setState(() {
      isPoll = true;
    });
  }

  // Future<void> _addPoll() async {
  //   setState(() {
  //     isPoll = true;
  //   });
  // }

  /// Function to disable the link input field.
  Future<void> _removeLink() async {
    setState(() {
      isLink = false;
    });
  }

  void _removePoll() {
    setState(() {
      isPoll = false;
    });
  }

  // void _removePoll() {
  //   setState(() {
  //     isPoll = false;
  //   });
  // }

  /// Function to reset all entered data.
  void resetAll() {
    _titleController = TextEditingController(text: "");
    _bodytextController = TextEditingController(text: "");
    ref.read(postDataProvider.notifier).resetAll();
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

  /// Callback function for title text field changes.
  void onTitleChanged(String value) {
    final post = ref.watch(postDataProvider);
    if (post!.title != value) {
      ref.watch(postDataProvider.notifier).updateTitle(value);
    }
  }

  /// Callback function for body text field changes.
  void onBodyChanged(String value) {
    final post = ref.watch(postDataProvider);
    if (post!.text_body != value) {
      ref.watch(postDataProvider.notifier).updateBodyText(value);
    }
    postBody = value;
  }

  @override
  Widget build(BuildContext context) {
    Widget buildImageContent() {
      if (image == null || isLink || isVideo) {
        return const SizedBox();
      }
      return AddImageWidget(onPressed: _removeImage, imagePath: imageFile!);
    }


    Widget buildVideoContent() {
      if (video == null || isLink || isImage) {
        return const SizedBox();
      }
      return AddVideoWidget(onPressed: _removeVideo, videoPath: videoFile!);
    }

    Widget buildLink() {
      if (isLink) {
        return AddLinkWidget(
          removeLink: _removeLink,
        );
      }
      return const SizedBox();
    }

    Widget buildPoll() {
      if (isPoll) {
        return AddPoll(removePoll: _removePoll);
      }
      return const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: ClosedButton(
            resetAll: resetAll,
            firstScreen: 1,
            titleController: _titleController,
            isImage: isImage,
            isLink: isLink,
            isVideo: isVideo,
            isPoll : isPoll),
        actions: [
          NextButton(titleController: _titleController),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        onChanged: (value) => {onTitleChanged(value)},
                      ),
                    ),
                    buildImageContent(),
                    buildLink(),
                    buildVideoContent(),
                    buildPoll(),
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
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: TextStyle(
                                  color: AppColors.whiteColor, fontSize: 16)),
                          onChanged: (value) => {onBodyChanged(value)}),
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
              onPressed: (!isLink && !isVideo && !isPoll) ? _pickImage : () {},
              icon: const Icon(Icons.image),
              color: isLink || isImage || isVideo || isPoll
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isLink && !isImage & !isPoll) ? _pickVideo : () {},
              icon: const Icon(Icons.video_library_outlined),
              color: isLink || isImage || isVideo || isPoll
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isImage && !isVideo && !isPoll) ? _addLink : () {},
              icon: const Icon(Icons.link),
              color: isLink || isImage || isVideo || isPoll
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isImage && !isVideo && !isLink) ? _addPoll : () {},
              icon: const Icon(Icons.poll_outlined),
              color: isLink || isImage || isVideo || isPoll
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
          ],
        ),
      ),
    );
  }
}
