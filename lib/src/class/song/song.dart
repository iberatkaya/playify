import 'package:flutter/material.dart';

class Song {
  Song(
      {@required this.iOSSongID,
      @required this.title,
      @required this.artistName,
      @required this.albumTitle,
      @required this.trackNumber,
      @required this.playCount,
      @required this.discNumber,
      @required this.genre,
      @required this.releaseDate,
      @required this.duration,
      @required this.isExplicit})
      : assert(iOSSongID != null),
        assert(title != null),
        assert(artistName != null),
        assert(albumTitle != null),
        assert(trackNumber != null),
        assert(playCount != null),
        assert(discNumber != null),
        assert(genre != null),
        assert(releaseDate != null),
        assert(duration != null),
        assert(isExplicit != null);

  ///The title of the album.
  String albumTitle;

  ///The name of the song artist.
  String artistName;

  ///The release date of the song.
  DateTime releaseDate;

  ///The genre of the song.
  String genre;

  ///The title of the song.
  String title;

  ///The Persistent Song ID of the song. Used to play or enqueue a song.
  String iOSSongID;

  ///The track number of the song in an album.
  int trackNumber;

  ///The amount of times the song has been played.
  int playCount;

  ///The disc number the song belongs to in an album.
  int discNumber;

  ///The total duration of the song.
  double duration;

  ///Shows if the song is explicit.
  bool isExplicit;

  static Song fromJson(Map<String, dynamic> map) => Song(
      albumTitle: map['albumTitle'],
      duration: map['playbackDuration'],
      title: map['songTitle'],
      trackNumber: map['trackNumber'],
      discNumber: map['discNumber'],
      isExplicit: map['isExplicitItem'],
      genre: map['genre'],
      releaseDate: DateTime.fromMillisecondsSinceEpoch(map['releaseDate']),
      playCount: map['playCount'],
      artistName: map['albumArtist'],
      iOSSongID: map['songID'].toString());

  @override
  String toString() {
    return 'Song Title: ' +
        title +
        ', Album Title: ' +
        albumTitle +
        ', Artist Name: ' +
        artistName +
        ', Duration: ' +
        duration.toString() +
        ', SongID: ' +
        iOSSongID +
        '\n';
  }
}
