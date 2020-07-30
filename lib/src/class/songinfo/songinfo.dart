import 'package:flutter/material.dart';
import 'package:playify/src/class/album/album.dart';
import 'package:playify/src/class/artist/artist.dart';
import 'package:playify/src/class/song/song.dart';

class SongInfo {
  SongInfo({@required Album album, @required Song song, @required Artist artist}) {
    this.album = album;
    this.song = song;
    this.artist = artist;
  }
  Album album;
  Song song;
  Artist artist;

  @override
  String toString() {
    return "Artist: " +
        this.artist.toString() +
        "Album: " +
        this.album.toString() +
        "Song: " +
        this.song.toString();
  }
}
