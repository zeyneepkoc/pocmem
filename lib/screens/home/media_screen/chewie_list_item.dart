import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:pocmem/constants/colors/color.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping, showControl;
  const ChewieListItem(
      {Key? key, required this.videoPlayerController, required this.looping, required this.showControl})
      : super(key: key);

  @override
  State<ChewieListItem> createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        autoInitialize: true,
        autoPlay: false,
        showControls: widget.showControl,
        looping: widget.looping,
        materialProgressColors: ChewieProgressColors(
            playedColor: darkColor,
            handleColor: Colors.white,
            bufferedColor: backgroundColor,
            backgroundColor: lightColor),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage),
          );
        });
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController);
  }
}
