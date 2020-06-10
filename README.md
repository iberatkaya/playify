# Playify

<b>Playify</b> is a Flutter plugin for playing music and fetching music metadata. Supports only iOS. Still in development. A detailed README will be added in the future. Checkout the [Development Log](https://github.com/iberatkaya/playify/blob/master/DEVLOG.md).

Requirements: 
* iOS: >= iOS 10.1 (Due to [MPMusicPlayerMediaItemQueueDescriptor](https://developer.apple.com/documentation/mediaplayer/mpmusicplayermediaitemqueuedescriptor))

## Usage

```dart
import 'package:playify/playify.dart';

//Create an instance
Playify myplayer = Playify();

//Play from the latest queue.
Future<void> play(){
	await myplayer.play();
}

//Fetch all songs from iOS's Apple Music.
Future<List<Artist>> getAllSongs(){
	await myplayer.getAllSongs(sort: true)
}

//Set the queue using songIDs for iOS.
Future<void> setQueue(songs: List<String>, index: int){
	await myplayer.setQueue(songIDs: songs, startIndex: index);
}

//Skip to the next song in the queue.
Future<void> next(){
	await myplayer.next();
}
//Skip to the previous song in the queue.
Future<void> previous(){
	await myplayer.previous();
}
```

## iOS

* For iOS, Playify uses iOS's MusicKit framework. This makes Playify available only on iOS >= 10.1. Make sure to specify the minimum version of the supported iOS version in your app from XCode.

* <b>Getting All Songs:</b> For geting all songs from the Apple Music library of the iPhone, you can specify whether to sort the artists. The songs are sorted by their track number, and the albums are sorted alphabetically. The cover art of each album is fetched individually, and you can specify the size of the cover art. The larger the cover art, the more amount of RAM it consumes and longer it takes to fetch. The default value takes about 1-2 seconds with 800+ songs.   

## Screenshots

<p align="center">
    <img alt="Screenshot" style="margin-top: 4px;" src="https://raw.githubusercontent.com/iberatkaya/playify/master/example/screenshots/1.png" width="220" height="380">
    <img alt="Screenshot" style="margin-top: 4px;" src="https://raw.githubusercontent.com/iberatkaya/playify/master/example/screenshots/2.png" width="220" height="380">
    <img alt="Screenshot" style="margin-top: 4px;" alt="Screenshot" src="https://raw.githubusercontent.com/iberatkaya/playify/master/example/screenshots/3.png" width="220" height="380">
	<img alt="Screenshot" style="margin-top: 4px;" alt="Screenshot" src="https://raw.githubusercontent.com/iberatkaya/playify/master/example/screenshots/4.png" width="220" height="380">
</p>
