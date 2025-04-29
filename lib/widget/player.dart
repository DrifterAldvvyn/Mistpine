import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mistpine/color.dart';
import 'package:mistpine/page/now_playing.dart';
import 'package:mistpine/backend/data.dart';
import 'package:mistpine/backend/audio_service.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  void initState() {
    super.initState();
    final audioService = Provider.of<AudioService>(context, listen: false);
    audioService.setPlaylist(queue);
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    final currentTrack = audioService.currentTrack;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NowPlaying()),
              );
            },
            child: Hero(
              tag: 'cover',
              child: Container(
                height: 150,
                width: 150,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 180,
                child: Center(
                  child: Hero(
                    tag: 'trackName',
                    child: AutoSizeText(
                      currentTrack != null
                          ? currentTrack.trackName
                          : 'Not Playing',
                      style: TextStyle(color: AppColors.text, fontSize: 20),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Hero(
                    tag: 'prev',
                    child: TextButton(
                      onPressed: audioService.previousTrack,
                      child: Icon(
                        Icons.skip_previous_rounded,
                        size: 40,
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
                        size: 40,
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
                        size: 40,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
