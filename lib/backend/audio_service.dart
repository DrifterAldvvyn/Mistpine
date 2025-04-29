import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:mistpine/backend/data.dart';

class AudioService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration? _position;
  Duration? _duration;
  bool _isPlaying = false;
  List<MusicTrack> _playlist = [];
  int? _currentTrackIndex;
  bool _isShuffleEnabled = false;
  LoopMode _loopMode = LoopMode.off;

  AudioService() {
    _initStreams();
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  Duration? get position => _position;
  Duration? get duration => _duration;
  bool get isPlaying => _isPlaying;
  List<MusicTrack> get playlist => _playlist;
  int? get currentTrackIndex => _currentTrackIndex;
  bool get isShuffleEnabled => _isShuffleEnabled;
  LoopMode get loopMode => _loopMode;

  // Getter for the current track
  MusicTrack? get currentTrack {
    if (_currentTrackIndex != null &&
        _currentTrackIndex! >= 0 &&
        _currentTrackIndex! < _playlist.length) {
      return _playlist[_currentTrackIndex!];
    }
    return null;
  }

  void _initStreams() {
    _audioPlayer.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });
    _audioPlayer.durationStream.listen((dur) {
      _duration = dur;
      notifyListeners();
    });
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });
    _audioPlayer.currentIndexStream.listen((index) {
      _currentTrackIndex = index;
      notifyListeners();
    });
    _audioPlayer.playbackEventStream.listen(
      (event) {},
      onError: (e, st) => print('Playback error: $e\nStackTrace: $st'),
    );
    _audioPlayer.shuffleModeEnabledStream.listen((enabled) {
      _isShuffleEnabled = enabled;
      notifyListeners();
    });
    _audioPlayer.loopModeStream.listen((mode) {
      _loopMode = mode;
      notifyListeners();
    });
  }


  // Initialize playlist with MusicTrack objects
  Future<void> setPlaylist(List<MusicTrack> tracks) async {
  _playlist = tracks;
  if (tracks.isEmpty) {
    _playlist = [];
    _currentTrackIndex = null;
    await _audioPlayer.setAudioSources([]);
    notifyListeners();
    return;
  }

  final sources = tracks.asMap().entries.map((entry) {
    final index = entry.key;
    final track = entry.value;
    print('Loading asset: ${track.audio}');
    return AudioSource.uri(
      Uri.parse('asset:///${track.audio}'),
      tag: MediaItem(
        id: '$index', // Unique ID for the track
        title: track.trackName,
        artist: track.artist,
        album: track.album,
        artUri: Uri.parse(track.coverUri),
      ),
    );
  }).toList();

  try {
    await _audioPlayer.setAudioSources(sources);
    _currentTrackIndex = 0;
    print('Playlist set successfully');
    notifyListeners();
  } catch (e, stackTrace) {
    print('Error setting playlist: $e\nStackTrace: $stackTrace');
    rethrow;
  }
}

  // Toggle shuffle mode
  Future<void> toggleShuffle() async {
    try {
      await _audioPlayer.setShuffleModeEnabled(!_isShuffleEnabled);
      print('Shuffle ${!_isShuffleEnabled ? 'enabled' : 'disabled'}');
    } catch (e, stackTrace) {
      print('Error toggling shuffle: $e\nStackTrace: $stackTrace');
    }
  }

  // Cycle through loop modes (off -> all -> one -> off)
  Future<void> cycleLoopMode() async {
    try {
      LoopMode nextMode;
      switch (_loopMode) {
        case LoopMode.off:
          nextMode = LoopMode.all;
          break;
        case LoopMode.all:
          nextMode = LoopMode.one;
          break;
        case LoopMode.one:
          nextMode = LoopMode.off;
          break;
      }
      await _audioPlayer.setLoopMode(nextMode);
      print('Loop mode set to $nextMode');
    } catch (e, stackTrace) {
      print('Error setting loop mode: $e\nStackTrace: $stackTrace');
    }
  }

  // Test single asset for debugging
  Future<void> testSingleAsset(String assetPath) async {
    try {
      print('Testing asset: $assetPath');
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();
      print('Successfully loaded and played $assetPath');
    } catch (e, stackTrace) {
      print('Error loading single asset: $e\nStackTrace: $stackTrace');
    }
  }

  // Playback controls
  Future<void> play() async => await _audioPlayer.play();
  Future<void> pause() async => await _audioPlayer.pause();
  Future<void> stop() async => await _audioPlayer.stop();
  Future<void> seek(Duration position) async =>
      await _audioPlayer.seek(position);
  Future<void> playTrackAt(int index) async {
    if (index >= 0 && index < _playlist.length) {
      await _audioPlayer.seek(Duration.zero, index: index);
      await play();
    }
  }

  Future<void> nextTrack() async => await _audioPlayer.seekToNext();
  Future<void> previousTrack() async => await _audioPlayer.seekToPrevious();
  Future<void> setVolume(double volume) async =>
      await _audioPlayer.setVolume(volume);

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
