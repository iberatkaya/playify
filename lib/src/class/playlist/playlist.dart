import 'package:flutter/foundation.dart';

class Playlist {
  Playlist({
    @required this.title,
    @required this.songIDs,
  })  : assert(title != null),
        assert(songIDs != null);

  ///The title of the playlist.
  String title;

  ///The songIDs in that playlist.
  List<String> songIDs;

  @override
  String toString() => 'Playlist title: $title, songIDs: $songIDs';
}
