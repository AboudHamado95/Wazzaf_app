import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wazzaf/cubit/video/video_bloc.dart';
import 'package:wazzaf/cubit/video/video_state.dart';
import 'package:wazzaf/screens/video/audio_controls.dart';
import 'package:wazzaf/screens/video/play_controls.dart';
import 'package:wazzaf/screens/video/progress_indicator_control.dart';

class VideoControls extends StatefulWidget {
  const VideoControls(
    this.controller, {
    Key? key,
    this.iconSize = 36,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 4.0,
    ),
  }) : super(key: key);

  final VideoPlayerController controller;
  final double iconSize;
  final EdgeInsets padding;

  static const _heightProgressControl = 4.0;

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  double get height =>
      widget.iconSize +
      VideoControls._heightProgressControl +
      widget.padding.vertical;

  double _getOffsetY(
    bool visible,
    bool initialVisibility,
  ) {
    // No animation on initial visibility
    if (initialVisibility) {
      return 0;
    }
    return visible ? 0 : height * -1;
  }

  Offset _getOffset(
    bool visible,
    bool initialVisibility,
  ) {
    return Offset(
      0.0,
      _getOffsetY(
        visible,
        initialVisibility,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final cubit = BlocProvider.of<VideoCubit>(context);
    return GestureDetector(
      onTap: cubit.toggleControlsVisibility,
      behavior: HitTestBehavior.translucent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                BlocBuilder<VideoCubit, VideoState>(
                  buildWhen: (previous, current) {
                    return previous.controlsVisible != current.controlsVisible;
                  },
                  builder: (context, state) {
                    return TweenAnimationBuilder<Offset>(
                      child: _buildBar(
                        context,
                        cubit: cubit,
                      ),
                      duration: Duration(milliseconds: 150),
                      tween: Tween<Offset>(
                        begin: _getOffset(
                          state.controlsNotVisible,
                          state.visibilityNotChanged,
                        ),
                        end: _getOffset(
                          state.controlsVisible,
                          state.visibilityNotChanged,
                        ),
                      ),
                      builder: (_, value, child) {
                        return Positioned(
                          height: height,
                          left: 0.0,
                          right: 0.0,
                          bottom: value.dy,
                          child: child!,
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
    BuildContext context, {
    required VideoCubit cubit,
  }) {
    return Container(
      color: Colors.black38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlayControl(
                  iconSize: widget.iconSize,
                ),
                AudioControl(
                  iconSize: widget.iconSize,
                ),
              ],
            ),
          ),
          ProgressIndicatorControl(
            controller: widget.controller,
          ),
        ],
      ),
    );
  }
}
