import 'package:flutter/material.dart';
import 'package:playify/src/class/song/song.dart';

class Album {
  Album(
      {@required String title,
      @required List<Song> songs,
      @required int albumTrackCount,
      @required String artistName,
      @required Image coverArt,
      @required int diskCount}) {
    this.title = title;
    this.songs = songs;
    this.albumTrackCount = albumTrackCount;
    this.artistName = artistName;
    this.coverArt = coverArt;
    this.diskCount = diskCount;
  }
  String title;
  List<Song> songs;
  String artistName;
  int albumTrackCount;
  Image coverArt;
  int diskCount;

  @override
  String toString() {
    return "Title: " +
        this.title +
        " has " +
        songs.length.toString() +
        " songs and artist is " +
        this.artistName +
        "\n";
  }
}
