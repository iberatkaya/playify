import 'package:flutter/material.dart';
import 'package:playify/src/class/album/album.dart';

class Artist {
  Artist({@required this.name, @required this.albums});
  String name;
  List<Album> albums;

  @override
  String toString() {
    return "Name: " +
        this.name +
        " has " +
        albums.length.toString() +
        " albums\n";
  }
}
