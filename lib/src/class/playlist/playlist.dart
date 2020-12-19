import 'package:flutter/foundation.dart';

class Playlist {
  Playlist({
    @required this.title,
    @required this.playlistID,
    @required this.songIDs,
  })  : assert(title != null),
        assert(playlistID != null),
        assert(songIDs != null);

  ///The title of the playlist.
  String title;

  ///The songIDs in that playlist.
  List<String> songIDs;

  ///The ID of the playlist.
  List<String> playlistID;

  @override
  String toString() =>
      'Playlist title: $title, playlistID: $playlistID, songIDs: $songIDs';
}
