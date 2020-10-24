# Playify

![](https://badgen.net/pub/v/playify) ![](https://badgen.net/pub/flutter-platform/playify)

<b>Playify</b> is a Flutter plugin for play/pause/seek songs, fetching music metadata, and browsing music library. Playify was built using iOS's Media Player Framework to fetch and play music from iOS's Music Library. Currently supports only iOS.

Requirements:

- iOS: >= iOS 10.1 (Due to [MPMusicPlayerMediaItemQueueDescriptor](https://developer.apple.com/documentation/mediaplayer/mpmusicplayermediaitemqueuedescriptor))

## Usage

```dart
import 'package:playify/playify.dart';

//Create an instance
Playify myplayer = Playify();

//Play from the latest queue.
Future<void> play() async {
	await myplayer.play();
}

//Fetch all songs from iOS's Apple Music.
Future<List<Artist>> getAllSongs() async {
	var artists = await myplayer.getAllSongs(sort: true);
	return artists;
}

//Fetch song information about the currently playing song in the queue.
Future<SongInfo> nowPlaying() async {
	var songinfo = await myplayer.nowPlaying();
	return songinfo;
}

//Set the queue using songIDs for iOS.
Future<void> setQueue(List<String> songs) async {
	await myplayer.setQueue(songIDs: songs);
}

//Skip to the next song in the queue.
Future<void> next() async {
	await myplayer.next();
}

//Skip to the previous song in the queue.
Future<void> previous() async {
	await myplayer.previous();
}

//Set the playback time of the song.
Future<void> setPlaybackTime(double time) async {
	await myplayer.setPlaybackTime(time);
}

//Set the shuffle mode.
Future<void> setShuffleMode(Shuffle mode) async {
	await myplayer.setShuffleMode(mode);
}
```

## iOS

- For iOS, Playify uses iOS's Media Player framework. This makes Playify available only on iOS >= 10.1. Make sure to specify the minimum version of the supported iOS version in your app from XCode.

- <b>Getting All Songs:</b> For geting all songs from the Apple Music library of the iPhone, you can specify whether to sort the artists. The songs are sorted by their track number, and the albums are sorted alphabetically. The cover art of each album is fetched individually, and you can specify the size of the cover art. The larger the cover art, the more amount of RAM it consumes and longer it takes to fetch. The default value takes about 1-2 seconds with 800+ songs.

## Android

- For Android, I plan to use a popular audio playing library such as [audioplayers](https://pub.dev/packages/audioplayers). Feel free to suggest better implementation plans by creating an [issue](https://github.com/iberatkaya/playify/issues) or by contributing.

## Screenshots

<p align="center">
    <img alt="Screenshot" style="margin-top: 4px;" alt="Screenshot" src="https://raw.githubusercontent.com/iberatkaya/playify/master/example/screenshots/1.png" width="220" height="400">
    <img alt="Screenshot" style="margin-top: 4px;" alt="Screenshot" src="https://raw.githubusercontent.com/iberatkaya/playify/master/example/screenshots/2.png" width="220" height="400">
    <img alt="Screenshot" style="margin-top: 4px;" alt="Screenshot" src="https://raw.githubusercontent.com/iberatkaya/playify/master/example/screenshots/3.png" width="220" height="400">
	<img alt="Screenshot" style="margin-top: 4px;" alt="Screenshot" src="https://raw.githubusercontent.com/iberatkaya/playify/master/example/screenshots/4.png" width="220" height="400">
</p>
