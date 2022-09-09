import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../config/size_config.dart';
import '../../../constants/colors/color.dart';
import '../../../methods/time_format.dart';

class AudioPlayerItem extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerItem(
      {Key? key,
      required this.audioUrl})
      : super(key: key);

  @override
  State<AudioPlayerItem> createState() => _AudioPlayerItemState();
}

class _AudioPlayerItemState extends State<AudioPlayerItem> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    setAudio(widget.audioUrl);
  }

  Future setAudio(String _audioUrl) async {
    setState(() {
      _audioPlayer.setUrl(_audioUrl);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    _audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: const Icon(Icons.audiotrack_rounded),
            color: Colors.black26,
            height: SizeConfig.defaultSize * 20,
            width: SizeConfig.defaultSize * 20,
          ),
        ),
        Expanded(
          child: Slider(
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await _audioPlayer.seek(position);
              await _audioPlayer.resume();
            },
            min: 0.0,
            max: duration.inSeconds.toDouble(),
            activeColor: darkColor,
            inactiveColor: backgroundColor,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize * 4.8,
                vertical: SizeConfig.defaultSize * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(timeFormat(position)),
                Text(timeFormat(duration))
              ],
            ),
          ),
        ),
        Expanded(
          child: CircleAvatar(
            radius: 25,
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () async {
                isPlaying
                    ? await _audioPlayer.pause()
                    : await _audioPlayer.resume();
              },
            ),
            backgroundColor: darkColor,
          ),
        ),
      ],
    );
  }
}
