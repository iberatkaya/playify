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
      @required this.isExplicit});

  String albumTitle;
  String artistName;
  DateTime releaseDate;
  String genre;
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
