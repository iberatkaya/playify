import 'package:flutter/material.dart';
import 'package:playify/playify.dart';
import 'package:playify_example/artists.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  bool fetchingAllSongs = false;
  bool playing = false;
  SongInformation data;
  Shuffle shufflemode = Shuffle.off;
  Repeat repeatmode = Repeat.none;
  var myplayer = Playify();
  List<Artist> artists = [];
  double time = 0.0;
  double volume = 0.0;

  Future<void> getNowPlaying() async {
    try {
      SongInformation res = await myplayer.nowPlaying();
      setState(() {
        data = res;
      });
    } catch (e) {
      setState(() {
        fetchingAllSongs = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getNowPlaying().then((value) async {
      final myVolume = await myplayer.getVolume();
      setState(() {
        volume = myVolume;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playify'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: IgnorePointer(
            ignoring: fetchingAllSongs,
            child: Column(
              children: <Widget>[
                if (data != null)
                  Container(
                    child: Column(
                      children: <Widget>[
                        if (data.album.coverArt != null)
                          Image(
                            image: Image.memory(
                              data.album.coverArt,
                              width: 800,
                            ).image,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        Slider(
                          divisions: data.song.duration.toInt(),
                          value: time,
                          min: 0,
                          max: data.song.duration,
                          onChanged: (val) async {
                            setState(() {
                              time = val;
                            });
                            await myplayer.setPlaybackTime(val);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () async {
                                  await myplayer.previous();
                                  await getNowPlaying();
                                },
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Column(
                                children: <Widget>[
                                  Text(data.artist.name),
                                  Text(data.album.title),
                                  Text(data.song.title),
                                  Text(data.song.trackNumber.toString() +
                                      "/" +
                                      data.album.albumTrackCount.toString()),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () async {
                                  await myplayer.next();
                                  await getNowPlaying();
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                if (!playing)
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () async {
                      await myplayer.play();
                      await myplayer.isPlaying();
                      setState(() {
                        playing = true;
                      });
                    },
                  )
                else
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () async {
                      await myplayer.pause();
                      await myplayer.isPlaying();
                      setState(() {
                        playing = false;
                      });
                    },
                  ),
                FlatButton(
                  child: Text("Get Now Playing Info"),
                  onPressed: () async {
                    await getNowPlaying();
                  },
                ),
                FlatButton(
                  child: Text("All Songs"),
                  onPressed: () async {
                    setState(() {
                      fetchingAllSongs = true;
                    });

                    var res = await myplayer.getAllSongs(sort: true);
                    print(res);
                    setState(() {
                      artists = res;
                      fetchingAllSongs = false;
                    });
                  },
                ),
                FlatButton(
                  child: Text("Artists"),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Artists(
                                  artists,
                                )));
                  },
                ),
                Slider(
                  label: volume.toStringAsFixed(2),
                  divisions: 20,
                  value: volume,
                  min: 0,
                  max: 1,
                  onChanged: (val) async {
                    setState(() {
                      volume = val;
                    });
                    await myplayer.setVolume(val);
                  },
                ),
                FlatButton(
                  child: Text("Get Volume"),
                  onPressed: () async {
                    final myVolume = await myplayer.getVolume();
                    setState(() {
                      volume = myVolume;
                    });
                  },
                ),
                FlatButton(
                  child: Text("Get Playback Time"),
                  onPressed: () async {
                    final playbackTime = await myplayer.getPlaybackTime();
                    print(playbackTime);
                  },
                ),
                FlatButton(
                  child: Text("Seek Forward"),
                  onPressed: () async {
                    await myplayer.seekForward();
                  },
                ),
                FlatButton(
                  child: Text("Seek Backward"),
                  onPressed: () async {
                    await myplayer.seekBackward();
                  },
                ),
                FlatButton(
                  child: Text("End Seek"),
                  onPressed: () async {
                    await myplayer.endSeeking();
                  },
                ),
                FlatButton(
                  child: Text("Skip To Beginning"),
                  onPressed: () async {
                    await myplayer.skipToBeginning();
                  },
                ),
                FlatButton(
                  child: Text("Get Playlists"),
                  onPressed: () async {
                    final playlists = await myplayer.getPlaylists();
                    print(playlists);
                  },
                ),
                FlatButton(
                  child: Text("Get Shuffle Mode"),
                  onPressed: () async {
                    final shuffleMode = await myplayer.getShuffleMode();
                    print(shuffleMode);
                  },
                ),
                FlatButton(
                  child: Text("Get Repeat Mode"),
                  onPressed: () async {
                    final repeatMode = await myplayer.getRepeatMode();
                    print(repeatMode);
                  },
                ),
                Text("Shuffle:"),
                DropdownButton<Shuffle>(
                  hint: Text("Shuffle"),
                  onChanged: (mode) async {
                    await myplayer.setShuffleMode(mode);
                    setState(() {
                      shufflemode = mode;
                    });
                  },
                  value: shufflemode,
                  items: [
                    DropdownMenuItem(
                      value: Shuffle.off,
                      child: Text("Off"),
                    ),
                    DropdownMenuItem(
                      value: Shuffle.songs,
                      child: Text("Songs"),
                    ),
                  ],
                ),
                Text("Repeat:"),
                DropdownButton<Repeat>(
                  hint: Text("Repeat"),
                  onChanged: (mode) async {
                    await myplayer.setRepeatMode(mode);
                    setState(() {
                      repeatmode = mode;
                    });
                  },
                  value: repeatmode,
                  items: [
                    DropdownMenuItem(
                      value: Repeat.none,
                      child: Text("None"),
                    ),
                    DropdownMenuItem(
                      value: Repeat.one,
                      child: Text("One"),
                    ),
                    DropdownMenuItem(
                      value: Repeat.all,
                      child: Text("All"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
