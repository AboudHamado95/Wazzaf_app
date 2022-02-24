import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wazzaf/cubit/video/video_bloc.dart';
import 'package:wazzaf/cubit/video/video_state.dart';
import 'package:wazzaf/screens/video/video_controls.dart';

class Video extends StatelessWidget {
  const Video._(
    this.url, {
    Key? key,
    required this.aspectRatio,
  }) : super(key: key);

  static Widget blocProvider(
    File file, {
    required double aspectRatio,
    bool autoPlay = false,
    bool? controlsVisible,
  }) {
    return BlocProvider(
      create: (_) {
        return VideoCubit(
          file,
          autoPlay: autoPlay,
          controlsVisible: controlsVisible ?? !autoPlay,
        );
      },
      child: Video._(
        file,
        aspectRatio: aspectRatio,
      ),
    );
  }

  final File url;
  final double aspectRatio;

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (_, state) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 100),
          child: AspectRatio(
            key: ValueKey(state.loaded),
            aspectRatio: aspectRatio,
            child: state.notLoaded
                ? Center(child: CircularProgressIndicator())
                : _buildVideo(state),
          ),
        );
      },
    );
  }

  Stack _buildVideo(
    VideoState state,
  ) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        VideoPlayer(
          state.controller,
        ),
        VideoControls(
          state.controller,
        ),
      ],
    );
  }
}
