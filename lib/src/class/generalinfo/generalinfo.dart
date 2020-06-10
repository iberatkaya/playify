import 'package:flutter/material.dart';
import 'package:playify/src/class/album/album.dart';
import 'package:playify/src/class/artist/artist.dart';
import 'package:playify/src/class/song/song.dart';

class GeneralInfo {
  GeneralInfo(
      {@required Album album, @required Song song, @required Artist artist}) {
    this.album = album;
    this.song = song;
    this.artist = artist;
  }
  Album album;
  Song song;
  Artist artist;
}
