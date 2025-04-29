// https://www.geeksforgeeks.org/flutter-set-device-volume-with-slider/

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mistpine/widget/lyrics.dart';
import 'package:provider/provider.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

import 'package:mistpine/color.dart';
import 'package:mistpine/backend/audio_service.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  double setVolumeValue = 0.0;

  @override
  void initState() {
    super.initState();
    // get current device volume
    FlutterVolumeController.getVolume().then(
      (volume) => setVolumeValue = volume ?? 0.0,
    );
    // system volume change listener
    FlutterVolumeController.addListener((volume) {
      setState(() => setVolumeValue = volume);
    });
    // hide system UI
    FlutterVolumeController.updateShowSystemUI(false);
  }

  @override
  void dispose() {
    FlutterVolumeController.removeListener();
    super.dispose();
  }

  // Format Duration to mm:ss
  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    final currentTrack = audioService.currentTrack;
    final position = audioService.position ?? Duration.zero;
    final duration = audioService.duration ?? Duration.zero;
    final isShuffleEnabled = audioService.isShuffleEnabled;
    final loopMode = audioService.loopMode;

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 1.0,
            child: Image.asset(
              'assets/textures/background.jpg',
              color: AppColors.pine,
              colorBlendMode: BlendMode.color,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Opacity(
            opacity: 0.45,
            child: Image.asset(
              'assets/textures/grain.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 64.0,
              horizontal: 32.0,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Playing from',
                    style: TextStyle(color: AppColors.subtext, fontSize: 15),
                  ),
                  Text(
                    currentTrack != null ? currentTrack.album : 'Album',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Hero(
                      tag: 'cover',
                      child: Container(
                        height: 360,
                        width: 360,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            currentTrack != null
                                ? currentTrack.cover
                                : 'assets/textures/background.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    child: Hero(
                      tag: 'trackName',
                      child: AutoSizeText(
                        currentTrack != null
                            ? currentTrack.trackName
                            : 'Not Playing',
                        maxLines: 1,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    currentTrack != null ? currentTrack.artist : 'Artist',
                    style: TextStyle(color: AppColors.subtext, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.album_rounded,
                          color: AppColors.subtext,
                          size: 30,
                        ),
                        Text(
                          currentTrack != null
                              ? '${currentTrack.bitDepth} / ${currentTrack.sampleRate}'
                              : '-- / --',
                          style: TextStyle(
                            color: AppColors.subtext,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 70,
                          decoration: BoxDecoration(
                            color: AppColors.subtext,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              currentTrack != null ? 'FLAC' : '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 0.0,
                        ),
                      ),
                      child: Slider(
                        value:
                            duration.inSeconds > 0
                                ? position.inSeconds.toDouble().clamp(
                                  0,
                                  duration.inSeconds.toDouble(),
                                )
                                : 0.0,
                        max: duration.inSeconds.toDouble(),
                        onChanged:
                            duration.inSeconds > 0
                                ? (value) {
                                  audioService.seek(
                                    Duration(seconds: value.toInt()),
                                  );
                                }
                                : null,
                        onChangeEnd: (value) {
                          audioService.seek(Duration(seconds: value.toInt()));
                        },
                        padding: EdgeInsets.zero,
                        inactiveColor: AppColors.subtext.withValues(alpha: 0.5),
                        activeColor: AppColors.subtext,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: TextStyle(
                            color: AppColors.subtext,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: TextStyle(
                            color: AppColors.subtext,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: audioService.toggleShuffle,
                          child: Icon(
                            isShuffleEnabled
                                ? Icons.shuffle_on_rounded
                                : Icons.shuffle_rounded,
                            size: 30,
                            color: AppColors.subtext,
                          ),
                        ),
                        Hero(
                          tag: 'prev',
                          child: TextButton(
                            onPressed: audioService.previousTrack,
                            child: Icon(
                              Icons.skip_previous_rounded,
                              size: 50,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        Hero(
                          tag: 'play',
                          child: TextButton(
                            onPressed:
                                audioService.isPlaying
                                    ? audioService.pause
                                    : audioService.play,
                            child: Icon(
                              audioService.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 50,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        Hero(
                          tag: 'next',
                          child: TextButton(
                            onPressed: audioService.nextTrack,
                            child: Icon(
                              Icons.skip_next_rounded,
                              size: 50,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: audioService.cycleLoopMode,
                          child: Icon(
                            loopMode == LoopMode.all
                                ? Icons.repeat_on_rounded
                                : loopMode == LoopMode.one
                                ? Icons.repeat_one_on_rounded
                                : Icons.repeat_rounded,
                            size: 30,
                            color: AppColors.subtext,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.volume_down_rounded,
                        size: 20,
                        color: AppColors.subtext,
                      ),
                      SizedBox(
                        width: 300,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbColor: Colors.transparent,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 0.0,
                            ),
                          ),
                          child: Slider(
                            min: 0.0,
                            max: 1.0,
                            value: setVolumeValue,
                            onChanged: (double value) {
                              setVolumeValue = value;
                              FlutterVolumeController.setVolume(setVolumeValue);
                              setState(() {});
                            },
                            padding: EdgeInsets.zero,
                            inactiveColor: AppColors.subtext.withValues(
                              alpha: 0.5,
                            ),
                            activeColor: AppColors.subtext,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.volume_down_rounded,
                        size: 20,
                        color: AppColors.subtext,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'assets/textures/background1.jpg',
                        color: AppColors.pine,
                        colorBlendMode: BlendMode.color,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.45,
                      child: Image.asset(
                        'assets/textures/grain.png',
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: 2.0,
                        color: AppColors.text.withValues(alpha: 0.1),
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: ListView(
                      
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.text,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Center(child: Lyrics()),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
