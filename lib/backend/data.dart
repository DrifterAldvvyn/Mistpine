class MusicTrack {
  final String trackName;
  final String artist;
  final String album;
  final String audio;
  final String cover;
  final String coverUri;
  final String lyrics;
  final String bitDepth;
  final String sampleRate;

  const MusicTrack({
    required this.trackName,
    required this.artist,
    required this.album,
    required this.audio,
    required this.cover,
    required this.coverUri,
    required this.lyrics,
    required this.bitDepth,
    required this.sampleRate,
  });
}

class MusicAlbum {
  final String albumName;
  final String cover;

  const MusicAlbum({required this.albumName, required this.cover});
}

class MusicArtist {
  final String artistName;
  final String profile;

  const MusicArtist({required this.artistName, required this.profile});
}

const List<MusicTrack> tracks = [
  MusicTrack(
    trackName: 'Featherweight',
    artist: 'Fleet Foxes',
    album: 'Shore',
    audio: 'assets/audios/Fleet Foxes - Shore/05 Featherweight.flac',
    cover: 'assets/images/covers/shore.png',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Music125/v4/29/1a/72/291a72d8-d951-2de7-eec4-1492f718c4e7/0045778844463.png',
    lyrics: 'assets/lyrics/Featherweight.lrc',
    bitDepth: '24',
    sampleRate: '48',
  ),
  MusicTrack(
    trackName: 'The Dead Flag Blues',
    artist: 'Godspeed You! Black Emperor',
    album: 'F♯ A♯ ∞',
    audio:
        'assets/audios/Godspeed You! Black Emperor - F♯ A♯ ∞/01 The Dead Flag Blues.flac',
    cover: 'assets/images/covers/F♯ A♯ ∞.jpg',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Features125/v4/8f/0d/83/8f0d83b5-2079-ad5c-1b8f-e29884205730/dj.fozymuwn.jpg',
    lyrics: 'assets/lyrics/The Dead Flag Blues.lrc',
    bitDepth: '16',
    sampleRate: '44.1',
  ),
  MusicTrack(
    trackName: 'East Hastings',
    artist: 'Godspeed You! Black Emperor',
    album: 'F♯ A♯ ∞',
    audio:
        'assets/audios/Godspeed You! Black Emperor - F♯ A♯ ∞/02 East Hastings.flac',
    cover: 'assets/images/covers/F♯ A♯ ∞.jpg',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Features125/v4/8f/0d/83/8f0d83b5-2079-ad5c-1b8f-e29884205730/dj.fozymuwn.jpg',
    lyrics: 'assets/lyrics/East Hastings.lrc',
    bitDepth: '16',
    sampleRate: '44.1',
  ),
  MusicTrack(
    trackName: 'Providence',
    artist: 'Godspeed You! Black Emperor',
    album: 'F♯ A♯ ∞',
    audio:
        'assets/audios/Godspeed You! Black Emperor - F♯ A♯ ∞/03 Providence.flac',
    cover: 'assets/images/covers/F♯ A♯ ∞.jpg',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Features125/v4/8f/0d/83/8f0d83b5-2079-ad5c-1b8f-e29884205730/dj.fozymuwn.jpg',
    lyrics: 'assets/lyrics/Providence.lrc',
    bitDepth: '16',
    sampleRate: '44.1',
  ),
  MusicTrack(
    trackName: 'Jigsaw Falling Into Place',
    artist: 'Radiohead',
    album: 'In Rainbows',
    audio: 'assets/audios/Radiohead - In Rainbows/09 Jigsaw Falling Into Place.flac',
    cover: 'assets/images/covers/in_rainbows.png',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Music126/v4/dd/50/c7/dd50c790-99ac-d3d0-5ab8-e3891fb8fd52/634904032463.png',
    lyrics: 'assets/lyrics/Jigsaw Falling Into Place.lrc',
    bitDepth: '16',
    sampleRate: '44.1',
  ),
  MusicTrack(
    trackName: 'Souvlaki Space Station',
    artist: 'Slowdive',
    album: 'Souvlaki',
    audio: 'assets/audios/Slowdive - Souvlaki/06 Souvlaki Space Station.flac',
    cover: 'assets/images/covers/souvlaki.jpg',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Music125/v4/c2/a0/a4/c2a0a495-ec33-27f1-c6db-0dff1c3ba15d/dj.pzrqoswp.jpg',
    lyrics: 'assets/lyrics/Souvlaki Space Station.lrc',
    bitDepth: '16',
    sampleRate: '44.1',
  ),
  MusicTrack(
    trackName: '缸',
    artist: '草東沒有派對',
    album: '瓦合',
    audio: 'assets/audios/草東沒有派對 - 瓦合/02 缸.flac',
    cover: 'assets/images/covers/瓦合.jpg',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Music126/v4/b0/f9/38/b0f9387d-f9cb-a50f-e17b-7b2f594f49ae/197188439798.jpg',
    lyrics: 'assets/lyrics/缸.lrc',
    bitDepth: '24',
    sampleRate: '48',
  ),
];

const List<MusicAlbum> albums = [
  MusicAlbum(albumName: 'F♯ A♯ ∞', cover: 'assets/images/covers/F♯ A♯ ∞.jpg'),
  MusicAlbum(
    albumName: 'In Rainbows',
    cover: 'assets/images/covers/in_rainbows.png',
  ),
  MusicAlbum(albumName: 'Shore', cover: 'assets/images/covers/shore.png'),
  MusicAlbum(albumName: 'Souvlaki', cover: 'assets/images/covers/souvlaki.jpg'),
  MusicAlbum(albumName: '瓦合', cover: 'assets/images/covers/瓦合.jpg'),
];

const List<MusicArtist> artists = [
  MusicArtist(
    artistName: 'Fleet Foxes',
    profile: 'assets/images/artists/fleet_foxes.jpg',
  ),
  MusicArtist(
    artistName: 'Godspeed You! Black Emperor',
    profile: 'assets/images/artists/gybe.jpg',
  ),
  MusicArtist(
    artistName: 'Radiohead',
    profile: 'assets/images/artists/radiohead.jpg',
  ),
  MusicArtist(
    artistName: 'Slowdive',
    profile: 'assets/images/artists/slowdive.jpg',
  ),
  MusicArtist(
    artistName: '草東沒有派對',
    profile: 'assets/images/artists/草東沒有派對.jpg',
  ),
];

List<MusicTrack> queue = [
  MusicTrack(
    trackName: 'Featherweight',
    artist: 'Fleet Foxes',
    album: 'Shore',
    audio: 'assets/audios/Fleet Foxes - Shore/05 Featherweight.flac',
    cover: 'assets/images/covers/shore.png',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Music125/v4/29/1a/72/291a72d8-d951-2de7-eec4-1492f718c4e7/0045778844463.png',
    lyrics: 'assets/lyrics/Featherweight.lrc',
    bitDepth: '24',
    sampleRate: '48',
  ),
  MusicTrack(
    trackName: '缸',
    artist: '草東沒有派對',
    album: '瓦合',
    audio: 'assets/audios/草東沒有派對 - 瓦合/02 缸.flac',
    cover: 'assets/images/covers/瓦合.jpg',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Music126/v4/b0/f9/38/b0f9387d-f9cb-a50f-e17b-7b2f594f49ae/197188439798.jpg',
    lyrics: 'assets/lyrics/缸.lrc',
    bitDepth: '24',
    sampleRate: '48',
  ),
  MusicTrack(
    trackName: 'Jigsaw Falling Into Place',
    artist: 'Radiohead',
    album: 'In Rainbows',
    audio: 'assets/audios/Radiohead - In Rainbows/09 Jigsaw Falling Into Place.flac',
    cover: 'assets/images/covers/in_rainbows.png',
    coverUri: 'https://a5.mzstatic.com/us/r1000/0/Music126/v4/dd/50/c7/dd50c790-99ac-d3d0-5ab8-e3891fb8fd52/634904032463.png',
    lyrics: 'assets/lyrics/Jigsaw Falling Into Place.lrc',
    bitDepth: '16',
    sampleRate: '44.1',
  ),
];
