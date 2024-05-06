import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/theme.dart';
import 'package:video_player/video_player.dart';

/// A widget for adding videos to a post.
class AddVideoWidget extends ConsumerStatefulWidget {
  /// Constructs a new [AddVideoWidget] instance.
  ///
  /// The [onPressed] and [videoPath] parameters are required. The [onPressed]
  /// callback function is called when the video is pressed, and the [videoPath]
  /// represents the file path of the video to be added.
  const AddVideoWidget(
      {super.key, required this.onPressed, required this.videoPath});

  /// Callback function triggered when the video is pressed.
  final Function()? onPressed;

  /// The path of the video file to be added.
  final File videoPath;

  @override
  ConsumerState<AddVideoWidget> createState() => _AddVideoWidgetState();
}

class _AddVideoWidgetState extends ConsumerState<AddVideoWidget> {
  late VideoPlayerController _videoController;
  late Future<void> _intializeVideoPlayer;

  @override
  void initState() {
    // the video controller contains the path of the video
    _videoController = VideoPlayerController.file(widget.videoPath);

    // intializing the _video object
    _intializeVideoPlayer = _videoController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.hardEdge, children: [
      FutureBuilder(
          future: _intializeVideoPlayer,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ConstrainedBox(
                constraints: BoxConstraints.loose(const Size.fromHeight(400)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
      Positioned(
        bottom: 10,
        left: 10,
        child: IconButton(
          onPressed: () {
            setState(() {
              _videoController.value.isPlaying
                  ? _videoController.pause()
                  : _videoController.play();
            });
          },
          icon: Icon(
              _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppColors.whiteGlowColor),
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  AppColors.mainColor.withOpacity(0.5))),
        ),
      ),
      Positioned(
        top: 10,
        right: 10,
        child: IconButton(
          onPressed: () {
            widget.onPressed!.call();
            ref.read(postDataProvider.notifier).removeVideo();
          },
          icon: const Icon(Icons.close, color: AppColors.whiteGlowColor),
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  AppColors.mainColor.withOpacity(0.5))),
        ),
      )
    ]);
  }
}
