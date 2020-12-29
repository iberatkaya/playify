import 'package:flutter/foundation.dart';
import 'package:playify/playify.dart';

class Playlist {
  Playlist({
    @required this.title,
    @required this.playlistID,
    @required this.songs,
  })  : assert(title != null),
        assert(playlistID != null),
        assert(songs != null);

  ///The title of the playlist.
  String title;

  ///The songs in that playlist.
  List<Song> songs;

  ///The ID of the playlist.
  String playlistID;

  @override
  String toString() =>
      'Playlist title: $title, playlistID: $playlistID, songs: $songs';
}
