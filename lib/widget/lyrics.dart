import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lrc/lrc.dart';
import 'package:provider/provider.dart';

import 'package:mistpine/color.dart';
import 'package:mistpine/backend/audio_service.dart';

class Lyrics extends StatefulWidget {
  const Lyrics({super.key});

  @override
  State<Lyrics> createState() => _LyricsState();
}

class _LyricsState extends State<Lyrics> {
  final ScrollController _scrollController = ScrollController();
  List<LrcLine> _parsedLyrics = [];
  int _currentIndex = 0;
  late AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = Provider.of<AudioService>(context, listen: false);

    // Load and parse on startup
    final track = _audioService.currentTrack;
    if (track != null) _loadAndParseLrc(track.lyrics);

    // Listen to position updates
    _audioService.audioPlayer.positionStream.listen(_onPositionUpdate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to AudioService changes
    final audioService = Provider.of<AudioService>(context, listen: true);
    final currentTrack = audioService.currentTrack;
    // Load lyrics if track exists and has a lyrics path
    if (currentTrack != null && currentTrack.lyrics.isNotEmpty) {
      _loadAndParseLrc(currentTrack.lyrics);
    } else {
      setState(() {});
    }
  }

  Future<void> _loadAndParseLrc(String path) async {
    try {
      final content = await rootBundle.loadString(path);
      final lrc = Lrc.parse(content);
      setState(() {
        _parsedLyrics = lrc.lyrics;
      });
    } catch (e) {
      // handle error...
    }
  }

  void _onPositionUpdate(Duration position) {
    if (_parsedLyrics.isEmpty) return;

    // Find the index of the last line whose time <= position
    int newIndex = 0;
    for (int i = 0; i < _parsedLyrics.length; i++) {
      if (position >= _parsedLyrics[i].timestamp) {
        newIndex = i;
      } else {
        break;
      }
    }

    if (newIndex != _currentIndex) {
      setState(() => _currentIndex = newIndex);
      _scrollToCurrentLine();
    }
  }

  void _scrollToCurrentLine() {
    // Estimate each item height (or use exact with GlobalKey)
    const lineHeight = 60.0;
    final targetOffset = _currentIndex * lineHeight;
    // adjust 200 to roughly center the line, or use 0 for top alignment

    _scrollController.animateTo(
      targetOffset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = Provider.of<AudioService>(context).currentTrack;
    final hasLyrics = track != null && _parsedLyrics.isNotEmpty;

    if (!hasLyrics) {
      return Center(
        child: Text(
          'No Lyrics Available',
          style: TextStyle(color: AppColors.subtext, fontSize: 20),
        ),
      );
    }

    return SizedBox(
      height: 600,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 600.0),
        itemCount: _parsedLyrics.length,
        itemBuilder: (context, index) {
          final line = _parsedLyrics[index].lyrics;
          final isCurrent = index == _currentIndex;
          return SizedBox(
            height: 60, // must match lineHeight in scroll logic
            child: Text(
              line,
              style: TextStyle(
                color: isCurrent ? AppColors.text : AppColors.subtext,
                fontSize: 20,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
