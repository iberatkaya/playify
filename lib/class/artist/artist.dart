
import 'package:playify/class/album/album.dart';

class Artist {
  Artist({String name, List<Album> albums}) {
    this.name = name;
    this.albums = albums;
  }
  String name;
  List<Album> albums;
}