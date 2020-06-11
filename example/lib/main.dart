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
  bool fetchingAllSong = false;
  bool playing = false;
  SongInfo data;
  Shuffle shufflemode = Shuffle.off;
  Repeat repeatmode = Repeat.none;
  var myplayer = Playify();
  List<Artist> artists = [];
  double time = 0.0;

  updateInfo() async {
    SongInfo res = await myplayer.nowPlaying();
    setState(() {
      data = res;
    });
  }

  @override
  void initState() {
    super.initState();
    updateInfo();
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
            ignoring: fetchingAllSong,
            child: Column(
              children: <Widget>[
                if (data != null)
                  Container(
                    child: Column(
                      children: <Widget>[
                        if (data.album.coverArt != null)
                          Image(
                            image: data.album.coverArt.image,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        Slider(
                          divisions: data.song.duration.toInt(),
                          value: time,
                          min: 0,
                          max: data.song.duration,
                          onChanged: (val) async {
                            print(val);
                            setState(() {
                              time = val;
                            });
                            await myplayer.setPlaybackTime(val);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () async {
                                await myplayer.previous();
                                await updateInfo();
                              },
                            ),
                            Column(
                              children: <Widget>[
                                Text(data.artist.name),
                                Text(data.album.title),
                                Text(data.song.title),
                                Text(data.song.trackNumber.toString() +
                                    "/" +
                                    data.album.albumTrackCount.toString()),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () async {
                                await myplayer.next();
                                await updateInfo();
                              },
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
                      var res = await myplayer.play();
                      setState(() {
                        playing = true;
                      });
                    },
                  )
                else
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () async {
                      var res = await myplayer.pause();
                      setState(() {
                        playing = false;
                      });
                    },
                  ),
                FlatButton(
                  child: Text("Get Now Playing Info"),
                  onPressed: () async {
                    await updateInfo();
                  },
                ),
                FlatButton(
                  child: Text("All Songs"),
                  onPressed: () async {
                    setState(() {
                      fetchingAllSong = true;
                    });
                    var res = await myplayer.getAllSongs(sort: true);
                    setState(() {
                      artists = res;
                      fetchingAllSong = false;
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
                                  artists: artists,
                                )));
                  },
                ),
                FlatButton(
                  child: Text("Get Playback Time"),
                  onPressed: () async {
                    var res = await myplayer.getPlaybackTime();
                    print(res);
                  },
                ),
                FlatButton(
                  child: Text("Seek Forward"),
                  onPressed: () async {
                    var res = await myplayer.seekForward();
                  },
                ),
                FlatButton(
                  child: Text("Seek Backward"),
                  onPressed: () async {
                    var res = await myplayer.seekBackward();
                  },
                ),
                FlatButton(
                  child: Text("End Seek"),
                  onPressed: () async {
                    var res = await myplayer.endSeeking();
                  },
                ),
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
                    DropdownMenuItem(
                      value: Shuffle.albums,
                      child: Text("Albums"),
                    )
                  ],
                ),
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
                      child: Text("Songs"),
                    ),
                    DropdownMenuItem(
                      value: Repeat.all,
                      child: Text("Albums"),
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
