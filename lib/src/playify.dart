import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playify/src/class/album/album.dart';
import 'package:playify/src/class/artist/artist.dart';
import 'package:playify/src/class/songinfo/songinfo.dart';
import 'package:playify/src/class/song/song.dart';

class Playify {
  static const MethodChannel playerChannel =
      const MethodChannel('com.kaya.playify/playify');

  ///Set the queue by giving the songIDs desired to be added to the queue.
  ///Does not require the play function to be called after setting the queue. It will autoplay

  Future<bool> setQueue({List<String> songIDs, int startIndex = 0}) async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('setQueue',
          <String, dynamic>{"songIDs": songIDs, "startIndex": startIndex});
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Play the most recent queue.
  Future<bool> play() async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('play');
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Pause playing.
  Future<bool> pause() async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('pause');
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Skip to the next song in the queue.
  Future<bool> next() async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('next');
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Skip to the previous song in the queue.
  Future<bool> previous() async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('previous');
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Seek forward in the song currently playing in the queue.
  ///Must call endSeeking() or will not stop seeking.
  Future<bool> seekForward() async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('seekForward');
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Seek backward in the song currently playing in the queue.
  ///Must call endSeeking() or will not stop seeking.
  Future<bool> seekBackward() async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('seekBackward');
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Stop seeking.
  Future<bool> endSeeking() async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('endSeeking');
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Get the playback time of the current song in the queue.
  Future<double> getPlaybackTime() async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('getPlaybackTime');
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Set the playback time of the current song in the queue.
  Future<bool> setPlaybackTime(double time) async {
    if (Platform.isIOS) {
      bool result = await playerChannel
          .invokeMethod('setPlaybackTime', <String, dynamic>{"time": time});
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Set the shuffle mode.
  Future<bool> setShuffleMode(Shuffle mode) async {
    if (Platform.isIOS) {
      String mymode = "";
      switch (mode.index) {
        case 0:
          mymode = "off";
          break;
        case 1:
          mymode = "songs";
          break;
        case 2:
          mymode = "albums";
          break;
        default:
          throw "Incorrent mode!";
      }
      bool result = await playerChannel
          .invokeMethod('setShuffleMode', <String, dynamic>{"mode": mymode});
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Set the repeat mode.
  Future<bool> setRepeatMode(Repeat mode) async {
    if (Platform.isIOS) {
      String mymode = "";
      switch (mode.index) {
        case 0:
          mymode = "none";
          break;
        case 1:
          mymode = "one";
          break;
        case 2:
          mymode = "all";
          break;
        default:
          throw "Incorrent mode!";
      }
      bool result = await playerChannel
          .invokeMethod('setRepeatMode', <String, dynamic>{"mode": mymode});
      return result;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Fetch all songs in the Apple Music library.
  ///This method may take up significant time due to the amount of songs available on the phone.
  ///Make sure to display a waiting animation while this is fetching.
  ///All cover art for each album is fetched when using this function. Due the amount of songs, the app may crash if the device does not have enough memory. In this case, the size of the cover art should be reduced.
  Future<List<Artist>> getAllSongs(
      {bool sort = false, int coverArtSize = 500}) async {
    if (Platform.isIOS) {
      List<Artist> artists = [];
      var result = await playerChannel
          .invokeMethod('getAllSongs', <String, dynamic>{"size": coverArtSize});
      for (int a = 0; a < result.length; a++) {
//          stdout.write(a.toString() + ", ");
        var resobj = new Map<String, dynamic>.from(result[a]);
        Artist artist = Artist(albums: [], name: resobj["artist"]);
        dynamic image =
            resobj["image"] != null ? Image.memory(resobj["image"]) : null;
        Album album = Album(
            songs: [],
            title: resobj["albumTitle"],
            albumTrackCount: resobj["albumTrackCount"],
            coverArt: image,
            diskCount: resobj["diskCount"],
            artistName: artist.name);
        Song song = Song(
            albumTitle: album.title,
            title: resobj["songTitle"],
            duration: resobj["playbackDuration"],
            trackNumber: resobj["albumTrackNumber"],
            discNumber: resobj["discNumber"],
            isExplicit: resobj["isExplicitItem"],
            playCount: resobj["playCount"],
            iOSSongID: resobj["songID"].toString(),
            artistName: artist.name);
        album.songs.add(song);
        artist.albums.add(album);
        album.artistName = artist.name;
        bool foundArtist = false;
        for (int i = 0; i < artists.length; i++) {
          if (artist.name == artists[i].name) {
            foundArtist = true;
            bool foundAlbum = false;
            for (int j = 0; j < artists[i].albums.length; j++) {
              if (artists[i].albums[j].title == album.title) {
                //If the album does not have a cover art
                if (artists[i].albums[j].coverArt == null &&
                    album.coverArt != null) {
                  artists[i].albums[j].coverArt = album.coverArt;
                }
                artists[i].albums[j].songs.add(song);
                artists[i]
                    .albums[j]
                    .songs
                    .sort((a, b) => a.trackNumber - b.trackNumber);
                foundAlbum = true;
                break;
              }
            }
            if (!foundAlbum) {
              artists[i].albums.add(album);
              artists[i].albums.sort((a, b) => a.title.compareTo(b.title));
            }
          }
        }
        if (!foundArtist) {
          artists.add(artist);
        }
      }
      if (sort) artists.sort((a, b) => a.name.compareTo(b.name));
      return artists;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }

  ///Retrieve information about the current playing song on the queue.
  Future<SongInfo> nowPlaying() async {
    if (Platform.isIOS) {
      var result = await playerChannel.invokeMethod('nowPlaying');
      var resobj = new Map<String, dynamic>.from(result);
      Artist artist = Artist(albums: [], name: resobj["artist"]);
      print(resobj["albumTrackCount"]);
      Album album = Album(
          songs: [],
          title: resobj["albumTitle"],
          albumTrackCount: resobj["albumTrackCount"],
          coverArt: Image.memory(resobj["image"]),
          diskCount: resobj["diskCount"],
          artistName: artist.name);
      Song song = Song(
          albumTitle: album.title,
          duration: resobj["playbackDuration"],
          title: resobj["songTitle"],
          trackNumber: resobj["trackNumber"],
          discNumber: resobj["discNumber"],
          isExplicit: resobj["isExplicitItem"],
          playCount: resobj["playCount"],
          artistName: artist.name,
          iOSSongID: resobj["songID"].toString());
      album.songs.add(song);
      artist.albums.add(album);
      album.artistName = artist.name;
      SongInfo info = SongInfo(album: album, artist: artist, song: song);
      return info;
    } else {
      throw PlatformException(
          code: "Device is not iOS!",
          message:
              "Currently only iOS is supported. Feel free to contribute to Playify to help support Android.");
    }
  }
}

enum Shuffle { off, songs, albums }

enum Repeat { none, one, all }
