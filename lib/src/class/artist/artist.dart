import 'package:flutter/material.dart';
import 'package:playify/src/class/album/album.dart';

class Artist {
  Artist({@required String name, @required List<Album> albums}) {
    this.name = name;
    this.albums = albums;
  }
  String name;
  List<Album> albums;
}
