import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProgressIndicatorControl extends StatefulWidget {
  const ProgressIndicatorControl({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final VideoPlayerController controller;

  @override
  State<ProgressIndicatorControl> createState() =>
      _ProgressIndicatorControlState();
}

class _ProgressIndicatorControlState extends State<ProgressIndicatorControl> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return VideoProgressIndicator(
      widget.controller,
      allowScrubbing: true,
      padding: const EdgeInsets.all(0),
      colors: VideoProgressColors(
        backgroundColor: Colors.transparent,
        bufferedColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        playedColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      ),
    );
  }
}
