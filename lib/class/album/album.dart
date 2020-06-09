
import 'package:flutter/material.dart';
import 'package:playify/class/song/song.dart';

class Album {
  Album({String title, List<Song> songs, int albumTrackCount, String artistName, Image coverArt, int diskCount}) {
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
}