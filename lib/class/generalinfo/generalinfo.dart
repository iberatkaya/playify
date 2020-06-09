import 'package:playify/class/album/album.dart';
import 'package:playify/class/artist/artist.dart';
import 'package:playify/class/song/song.dart';

class GeneralInfo {
  GeneralInfo({Album album, Song song, Artist artist}) {
    this.album = album;
    this.song = song;
    this.artist = artist;
  } 
  Album album;
  Song song;
  Artist artist;
}