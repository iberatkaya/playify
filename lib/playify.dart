import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playify/class/album/album.dart';
import 'package:playify/class/artist/artist.dart';
import 'package:playify/class/generalinfo/generalinfo.dart';
import 'package:playify/class/song/song.dart';

class Playify {
  
  static const MethodChannel playerChannel = const MethodChannel('com.kaya.playify/playify');

  List<Artist> artists = [];
  
  Future<bool> play() async {
    try{
      var result = await playerChannel.invokeMethod('play');
      return result;
    } catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> pause() async {
    try{
      var result = await playerChannel.invokeMethod('pause');
      return result;
    } catch(e){
      print(e);
      return false;
     }
  }
  
  Future<bool> next() async {
    try{
      var result = await playerChannel.invokeMethod('next');
      return result;
    } catch(e){
      print(e);
      return false;
     }
  }

  Future<bool> previous() async {
    try{
      var result = await playerChannel.invokeMethod('previous');
      return result;
    } catch(e){
      print(e);
      return false;
     }
  }

  Future<bool> getAllSongs() async {
    try{
      print("Getting all songs");
      var result = await playerChannel.invokeMethod('getAllSongs');
      print("Got and converting");
      print(result.length);
      for(int a=0; a<result.length; a++) {
        stdout.write(a.toString() + ", ");
        var resobj = new Map<String, dynamic>.from(result[a]);
        Artist artist = Artist(albums: [], name: resobj["artist"]);
        Image image = resobj["image"] != null ? Image.memory(resobj["image"]) : null;
        Album album = Album(songs: [], title: resobj["albumTitle"], albumTrackCount: resobj["albumTrackCount"], coverArt: image, diskCount: resobj["diskCount"]);
        Song song = Song(albumTitle: album.title, title: resobj["songTitle"], trackNumber: resobj["albumTrackNumber"], discNumber: resobj["discNumber"], isExplicit: resobj["isExplicitItem"], playCount: resobj["playCount"]); 
        album.songs.add(song);
        artist.albums.add(album);
        album.artistName = artist.name;
        bool foundArtist = false;
        for(int i=0; i<artists.length; i++){
          if(artist.name == artists[i].name){
            foundArtist = true;
            bool foundAlbum = false;
            for(int j=0; j<artists[i].albums.length; j++){
              if(artists[i].albums[j].title == album.title){
                artists[i].albums[j].songs.add(song);
                foundAlbum = true;
                break;
              }
            }
            if(!foundAlbum){
              artists[i].albums.add(album);
            }
          }
        }
        if(!foundArtist){
          artists.add(artist);
        }
      }
      print(artists.length);
      for(int i=0; i<artists.length; i++){
        print(artists[i].name + " has " + artists[i].albums.length.toString() + " albums.");
      }
      return true;
    } catch(e){
      print(e);
      return false;
     }
  }

  Future<GeneralInfo> nowPlaying() async {
    try {
      var result = await playerChannel.invokeMethod('nowPlaying');
      var resobj = new Map<String, dynamic>.from(result);
      Artist artist = Artist(albums: [], name: resobj["artist"]);
      Album album = Album(songs: [], title: resobj["albumTitle"], albumTrackCount: resobj["albumTrackCount"], coverArt: Image.memory(resobj["image"]), diskCount: resobj["diskCount"]);
      Song song = Song(albumTitle: album.title, title: resobj["songTitle"], trackNumber: resobj["albumTrackNumber"], discNumber: resobj["discNumber"], isExplicit: resobj["isExplicitItem"], playCount: resobj["playCount"]); 
      album.songs.add(song);
      artist.albums.add(album);
      album.artistName = artist.name;
      GeneralInfo info = GeneralInfo(album: album, artist: artist, song: song);
      return info;
    } catch(e){
      print(e);
      return null;
    }
  }
}
