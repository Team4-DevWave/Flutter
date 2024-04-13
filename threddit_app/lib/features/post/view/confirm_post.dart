import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';
import 'package:threddit_clone/features/post/view/add_post_screen.dart';
import 'package:threddit_clone/features/post/view/rules_screen.dart';
import 'package:threddit_clone/features/post/view/widgets/add_image.dart';
import 'package:threddit_clone/features/post/view/widgets/add_link.dart';
import 'package:threddit_clone/features/post/view/widgets/add_video.dart';
import 'package:threddit_clone/features/post/view/widgets/close_button.dart';
import 'package:threddit_clone/features/post/view/widgets/post_button.dart';
import 'package:threddit_clone/features/post/view/widgets/tags.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ConfirmPost extends AddPostScreen {
  const ConfirmPost({super.key});

  @override
  ConsumerState<ConfirmPost> createState() => _ConfirmPostState();
}

class _ConfirmPostState extends ConsumerState<ConfirmPost> {
  late TextEditingController _titleController;
  late TextEditingController _bodytextController;
  bool isImage = false;
  bool isLink = false;
  bool isVideo = false;
  late String postTitle;
  late String postBody;

  ///add image picker data
  final ImagePicker picker = ImagePicker();
  String? image;
  String? video;
  File? videoFile;
  File? imageFile;

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
    });
  }

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
    });
  }

  Future<void> _removeImage() async {
    setState(() {
      image = null;
      isImage = false;
    });
  }

  Future<void> _addLink() async {
    setState(() {
      isLink = true;
    });
  }

  Future<void> _removeVideo() async {
    setState(() {
      video = null;
      isVideo = false;
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
  }

  @override
  void didChangeDependencies() {
    final intialData = ref.watch(postDataProvider);
    _titleController = TextEditingController(text: intialData?.title ?? '');
    if (intialData?.image != null) {
      image = intialData?.image!;
      isImage = true;
    }
    if (intialData?.video != null) {
      video = intialData?.video;
      isVideo = true;
    }
    _bodytextController = TextEditingController(text: intialData?.text_body);
    if (intialData?.url != "") {
      isLink = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodytextController.dispose();
    super.dispose();
  }

  void resetAll() {
    _titleController = TextEditingController(text: "");
    _bodytextController = TextEditingController(text: "");
    image = null;
    ref.read(postDataProvider.notifier).resetAll();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    PostData? post = ref.watch(postDataProvider);

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
      return AddVideoWidget(
          onPressed: _removeVideo, videoPath: videoFile!.path);
    }

    Widget buildLink() {
      if (isLink) {
        return AddLinkWidget(
          removeLink: _removeLink,
        );
      }
      return const SizedBox();
    }

    void openRulesOverlay() {
      showModalBottomSheet(
          backgroundColor: AppColors.backgroundColor,
          context: context,
          builder: (ctx) {
            return const RulesPage();
          });
    }

    void openTagsOverlay() {
      showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.backgroundColor,
          builder: (ctx) {
            return TagsWidget(
              post: post,
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: ClosedButton(
            resetAll: resetAll,
            firstScreen: false,
            titleController: _titleController,
            isImage: isImage,
            isLink: isLink,
            isVideo: isVideo,
          ),
          actions: [
            if (isImage)
              PostButton(
                titleController: _titleController,
                type: "image",
              )
            else if (isLink)
              PostButton(titleController: _titleController, type: "url")
            else if (isVideo)
              PostButton(titleController: _titleController, type: "video")
            else
              PostButton(titleController: _titleController, type: "text")
          ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteClass.postToScreen);
                              },
                              splashColor: AppColors.realWhiteColor,
                              child: Text(
                                post!.community.toString(),
                                style: AppTextStyles.boldTextStyle,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                openRulesOverlay();
                              },
                              child: const Text(
                                "Rules",
                                style: TextStyle(
                                  color: AppColors.redditOrangeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                          onChanged: (value) => {
                            if (post.title != value)
                              {
                                ref
                                    .read(postDataProvider.notifier)
                                    .updateTitle(value)
                              },
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: openTagsOverlay,
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                AppColors.whiteHideColor)),
                        child: const Text(
                          "Add Tags",
                          style: TextStyle(color: AppColors.whiteGlowColor),
                        ),
                      ),
                      buildImageContent(),
                      buildLink(),
                      buildVideoContent(),
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
                            onChanged: (value) => {
                                  if (post.text_body != value)
                                    {
                                      ref
                                          .read(postDataProvider.notifier)
                                          .updateBodyText(value)
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
      ),
      bottomSheet: Container(
        color: AppColors.backgroundColor,
        height: 40.h,
        child: Row(
          children: [
            IconButton(
              onPressed: (!isLink && !isVideo) ? _pickImage : () {},
              icon: const Icon(Icons.image),
              color: isLink || isImage || isVideo
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isLink && !isImage) ? _pickVideo : () {},
              icon: const Icon(Icons.video_library_outlined),
              color: isLink || isImage || isVideo
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
            IconButton(
              onPressed: (!isImage && !isVideo) ? _addLink : () {},
              icon: const Icon(Icons.link),
              color: isLink || isImage || isVideo
                  ? AppColors.whiteHideColor
                  : AppColors.whiteGlowColor,
            ),
          ],
        ),
      ),
    );
  }
}
