import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class WaveBubble extends StatefulWidget {
  final bool isSender;
  final int? index;
  final String? path;
  final double? width;
  final Directory appDirectory;

  const WaveBubble({
    Key? key,
    required this.appDirectory,
    this.width,
    this.index,
    this.isSender = false,
    this.path,
  }) : super(key: key);

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  File? file;

  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  var playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Color(0xFFA2B615),
    liveWaveColor: Color(0xFFA2B615),
    spacing: 6,
  );

  @override
  void initState() {
    super.initState();
    playerWaveStyle = PlayerWaveStyle(
      fixedWaveColor: widget.isSender? const Color(0xFFA2B615) : const Color(0xFFC8C8C8),
      liveWaveColor: widget.isSender? const Color(0xFFA2B615) : const Color(0xFF231F20),
      spacing: 6,
    );
    controller = PlayerController();
    _preparePlayer();
    playerStateSubscription = controller.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  void _preparePlayer() async {
    // Opening file from assets folder
    if (true) {
      final response = await http.get(Uri.parse(widget.path!));
      file = File('${widget.appDirectory.path}/audio${widget.index}.m4a');
      file?.writeAsBytesSync(response.bodyBytes);
      // await file?.writeAsBytes(
      //     (await rootBundle.load('assets/audios/audio${widget.index}.mp3'))
      //         .buffer
      //         .asUint8List());
    }
    if (widget.index == null && widget.path == null && file?.path == null) {
      return;
    }
    // Prepare player with extracting waveform if index is even.
    controller.preparePlayer(
      path: file!.path,
      shouldExtractWaveform: widget.index?.isEven ?? true,
    );
    // Extracting waveform separately if index is odd.
    if (widget.index?.isOdd ?? false) {
      controller
          .extractWaveformData(
            path: widget.path ?? file!.path,
            noOfSamples:
                playerWaveStyle.getSamplesForWidth(widget.width ?? 200),
          )
          .then((waveformData) => debugPrint(waveformData.toString()));
    }
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.path != null || file?.path != null
        ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!controller.playerState.isStopped)
              IconButton(
                onPressed: () async {
                  controller.playerState.isPlaying
                      ? await controller.pausePlayer()
                      : await controller.startPlayer(
                          finishMode: FinishMode.pause,
                        );
                },
                icon: Stack(
                  alignment: Alignment.center,
                  children:[
                    Icon(Icons.circle, color: Colors.white, size: 42.sp,
                    ),
                    Icon(
                      controller.playerState.isPlaying
                          ? Icons.stop
                          : Icons.play_arrow,
                    ),
                  ]
                ),
                color: widget.isSender? const Color(0xFFA2B615) : const Color(0xFF231F20),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width / 2, 70),
              playerController: controller,
              waveformType: WaveformType.long,
              playerWaveStyle: playerWaveStyle,
            ),
          ],
        )
        : const SizedBox.shrink();
  }
}
