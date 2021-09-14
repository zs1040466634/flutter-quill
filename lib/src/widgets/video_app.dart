import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../flutter_quill.dart';

/// Widget for playing back video
/// Refer to https://github.com/flutter/plugins/tree/master/packages/video_player/video_player
class VideoApp extends StatefulWidget {
  const VideoApp(
      {required this.videoUrl,
      required this.context,
      required this.readOnly,
      this.playIconSize = 50,
      this.corner = 0,
      this.alignment = Alignment.center,
      this.minHeight = 0,
      this.maxHeight = double.infinity,
      Key? key})
      : super(key: key);

  final String videoUrl;
  final BuildContext context;
  final bool readOnly;
  final double playIconSize;
  final double corner;
  final Alignment alignment;
  final double minHeight;
  final double maxHeight;

  @override
  VideoAppState createState() => VideoAppState();
}

class VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.videoUrl.startsWith('http')
        ? VideoPlayerController.network(widget.videoUrl)
        : VideoPlayerController.file(File(widget.videoUrl))
      ..initialize().then((event) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      })
      ..addListener(() {
        if (!_controller.value.isPlaying) {
          setState(() {});
        }
      });
  }

  void stop() {
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyles = DefaultStyles.getInstance(context);
    if (!_controller.value.isInitialized || _controller.value.hasError) {
      //   if (widget.readOnly) {
      //     return RichText(
      //       text: TextSpan(
      //           text: widget.videoUrl,
      //           style: defaultStyles.link,
      //           recognizer: TapGestureRecognizer()
      //             ..onTap = () => launch(widget.videoUrl)),
      //     );
      //   }
      //
      //   return RichText(
      //       text: TextSpan(text: widget.videoUrl, style: defaultStyles.link));
      return Container(
        constraints: BoxConstraints(
            minHeight: widget.minHeight, maxHeight: widget.maxHeight),
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: ClipOval(
            child: Container(
              height: widget.playIconSize,
              width: widget.playIconSize,
              color: Colors.black.withOpacity(0.4),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: widget.playIconSize / 2,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
          minHeight: widget.minHeight, maxHeight: widget.maxHeight),
      child: InkWell(
        onTap: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Stack(alignment: widget.alignment, children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.corner)),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          _controller.value.isPlaying
              ? const SizedBox.shrink()
              : ClipOval(
                  child: Container(
                    height: widget.playIconSize,
                    width: widget.playIconSize,
                    color: Colors.black.withOpacity(0.4),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: widget.playIconSize / 2,
                    ),
                  ),
                )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
