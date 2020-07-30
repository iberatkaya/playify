import 'package:flutter/material.dart';

class Song {
  Song(
      {@required String iOSSongID,
      @required String title,
      @required String artistName,
      @required String albumTitle,
      @required int trackNumber,
      @required int playCount,
      @required int discNumber,
      @required double duration,
      @required bool isExplicit}) {
    this.title = title;
    this.duration = duration;
    this.trackNumber = trackNumber;
    this.albumTitle = albumTitle;
    this.artistName = artistName;
    this.playCount = playCount;
    this.discNumber = discNumber;
    this.isExplicit = isExplicit;
    this.iOSSongID = iOSSongID;
  }
  String albumTitle;
  String artistName;
  String title;
  String iOSSongID;
  int trackNumber;
  int playCount;
  int discNumber;
  double duration;
  bool isExplicit;

  @override
  String toString() {
    return "Album Title: " +
        this.albumTitle +
        ", Artist Name: " +
        this.artistName +
        ", title: " +
        this.title +
        ", Duration: " +
        this.duration.toString() +
        "\n";
  }
}
