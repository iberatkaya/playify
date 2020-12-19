import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:playify/src/class/album/album.dart';
import 'package:playify/src/class/artist/artist.dart';
import 'package:playify/src/class/playlist/playlist.dart';
import 'package:playify/src/class/song/song.dart';
import 'package:playify/src/class/song_information/song_information.dart';

import '../playify.dart';
import 'class/repeat/repeat.dart';
import 'class/shuffle/shuffle.dart';

class Playify {
  static const MethodChannel playerChannel =
      MethodChannel('com.kaya.playify/playify');

  ///Set the queue by giving the [songIDs] desired to be added to the queue.
  ///If [startPlaying] is false, the queue will not autoplay.
  ///If [startID] is provided, the queue will start from the song with
  ///the id [startID].
  Future<void> setQueue(
      {@required List<String> songIDs,
      bool startPlaying = true,
      String startID}) async {
    assert(songIDs != null);
    if (startID != null && !songIDs.contains(startID)) {
      throw PlatformException(
          code: 'Incorrect Arguments!',
          message: 'songIDs must contain startID if provided.');
    }
    await playerChannel.invokeMethod('setQueue', <String, dynamic>{
      'songIDs': songIDs,
      'startPlaying': startPlaying,
      'startID': startID
    });
  }

  ///Play the most recent queue.
  Future<void> play() async {
    await playerChannel.invokeMethod('play');
  }

  ///Play a single song by giving its [songID].
  Future<void> playItem({@required String songID}) async {
    await playerChannel
        .invokeMethod('playItem', <String, dynamic>{'songID': songID});
  }

  ///Pause playing.
  Future<void> pause() async {
    await playerChannel.invokeMethod('pause');
  }

  ///Skip to the next song in the queue.
  Future<void> next() async {
    await playerChannel.invokeMethod('next');
  }

  ///Check if there is a song currently playing.
  Future<bool> isPlaying() async {
    final isPlaying = await playerChannel.invokeMethod('isPlaying');
    return isPlaying;
  }

  ///Skip to the previous song in the queue.
  Future<void> previous() async {
    await playerChannel.invokeMethod('previous');
  }

  ///Seek forward in the song currently playing in the queue.
  ///Must call `endSeeking()` or will not stop seeking.
  Future<void> seekForward() async {
    await playerChannel.invokeMethod('seekForward');
  }

  ///Seek backward in the song currently playing in the queue.
  ///Must call `endSeeking()` or will not stop seeking.
  Future<void> seekBackward() async {
    await playerChannel.invokeMethod('seekBackward');
  }

  ///Stop seeking.
  Future<void> endSeeking() async {
    await playerChannel.invokeMethod('endSeeking');
  }

  ///Get the playback time of the current song in the queue.
  Future<double> getPlaybackTime() async {
    final result = await playerChannel.invokeMethod('getPlaybackTime');
    return result;
  }

  ///Set the playback [time] of the current song in the queue.
  Future<void> setPlaybackTime(double time) async {
    await playerChannel
        .invokeMethod('setPlaybackTime', <String, dynamic>{'time': time});
  }

  ///Skip to the beginning of the current song.
  Future<void> skipToBeginning() async {
    await playerChannel.invokeMethod('skipToBeginning');
  }

  ///Prepend [songIDs] to the queue.
  Future<void> prepend(List<String> songIDs) async {
    await playerChannel.invokeMethod('prepend', <String, dynamic>{
      'songIDs': songIDs,
    });
  }

  ///Append [songIDs] to the queue.
  Future<void> append(List<String> songIDs) async {
    await playerChannel.invokeMethod('append', <String, dynamic>{
      'songIDs': songIDs,
    });
  }

  ///Set the shuffle [mode].
  Future<void> setShuffleMode(Shuffle mode) async {
    var mymode = '';
    switch (mode.index) {
      case 0:
        mymode = 'off';
        break;
      case 1:
        mymode = 'songs';
        break;
      case 2:
        mymode = 'albums';
        break;
      default:
        throw 'Incorrent mode!';
    }
    await playerChannel
        .invokeMethod('setShuffleMode', <String, dynamic>{'mode': mymode});
  }

  ///Set the repeat [mode].
  Future<void> setRepeatMode(Repeat mode) async {
    var mymode = '';
    switch (mode.index) {
      case 0:
        mymode = 'none';
        break;
      case 1:
        mymode = 'one';
        break;
      case 2:
        mymode = 'all';
        break;
      default:
        throw 'Incorrent mode!';
    }
    await playerChannel
        .invokeMethod('setRepeatMode', <String, dynamic>{'mode': mymode});
  }

  ///Fetch all songs in the Apple Music library.
  ///
  ///This method may take up significant time due to the amount of songs
  ///available on the phone.
  ///
  ///All cover art for each album is fetched when using this function.
  ///Due the amount of songs, the app may crash if the device does not have
  ///enough memory. In this case, the [coverArtSize] should be reduced.
  ///
  ///[sort] can be set to true in order to sort the artists alphabetically.
  Future<List<Artist>> getAllSongs(
      {bool sort = false, int coverArtSize = 500}) async {
    final artists = <Artist>[];
    final result = await playerChannel
        .invokeMethod('getAllSongs', <String, dynamic>{'size': coverArtSize});
    for (var a = 0; a < result.length; a++) {
      final resobj = Map<String, dynamic>.from(result[a]);
      final artist = Artist(albums: [], name: resobj['artist']);
      final image = Uint8List.fromList(List<int>.from(resobj['image'] ?? []));
      final album = Album(
          songs: [],
          title: resobj['albumTitle'],
          albumTrackCount: resobj['albumTrackCount'],
          coverArt: image,
          discCount: resobj['discCount'],
          artistName: artist.name);
      final song = Song(
          albumTitle: album.title,
          title: resobj['songTitle'],
          duration: resobj['playbackDuration'],
          trackNumber: resobj['albumTrackNumber'],
          genre: resobj['genre'],
          releaseDate:
              DateTime.fromMillisecondsSinceEpoch(resobj['releaseDate']),
          discNumber: resobj['discNumber'],
          isExplicit: resobj['isExplicitItem'],
          playCount: resobj['playCount'],
          iOSSongID: resobj['songID'].toString(),
          artistName: artist.name);
      album.songs.add(song);
      artist.albums.add(album);
      album.artistName = artist.name;
      var foundArtist = false;
      for (var i = 0; i < artists.length; i++) {
        if (artist.name == artists[i].name) {
          foundArtist = true;
          var foundAlbum = false;
          for (var j = 0; j < artists[i].albums.length; j++) {
            if (artists[i].albums[j].title == album.title) {
              //If the album does not have a cover art
              if ((artists[i].albums[j].coverArt == null &&
                      album.coverArt != null) ||
                  (artists[i].name != album.artistName)) {
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
  }

  ///Retrieve information about the current playing song on the queue.
  ///
  ///Specify a [coverArtSize] to fetch the current song with the [coverArtSize].
  Future<SongInformation> nowPlaying({int coverArtSize = 800}) async {
    final result = await playerChannel
        .invokeMethod('nowPlaying', <String, dynamic>{'size': coverArtSize});
    if (result == null) {
      return null;
    }
    final resobj = Map<String, dynamic>.from(result);
    final artist = Artist(albums: [], name: resobj['artist']);
    final album = Album(
        songs: [],
        title: resobj['albumTitle'],
        albumTrackCount: resobj['albumTrackCount'],
        coverArt: resobj['image'],
        discCount: resobj['discCount'],
        artistName: artist.name);
    final song = Song(
        albumTitle: album.title,
        duration: resobj['playbackDuration'],
        title: resobj['songTitle'],
        trackNumber: resobj['trackNumber'],
        discNumber: resobj['discNumber'],
        isExplicit: resobj['isExplicitItem'],
        genre: resobj['genre'],
        releaseDate: DateTime.fromMillisecondsSinceEpoch(resobj['releaseDate']),
        playCount: resobj['playCount'],
        artistName: artist.name,
        iOSSongID: resobj['songID'].toString());
    album.songs.add(song);
    artist.albums.add(album);
    album.artistName = artist.name;
    final info = SongInformation(album: album, artist: artist, song: song);
    return info;
  }

  ///Get all the playlists.
  Future<List<Playlist>> getPlaylists() async {
    final result =
        await playerChannel.invokeMethod<List<dynamic>>('getPlaylists');
    final playlistMaps =
        result.map((i) => Map<String, dynamic>.from(i)).toList();
    final playlists = playlistMaps
        .map<Playlist>((i) => Playlist(
              songIDs: List<String>.from(i['songIDs'].map((j) => j.toString())),
              title: i['title'],
              playlistID: i['playlistID'],
            ))
        .toList();
    return playlists;
  }
}
