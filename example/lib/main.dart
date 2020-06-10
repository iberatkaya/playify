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
  GeneralInfo data;
  var myplayer = Playify();
  List<Artist> artists = [];

  updateInfo() async {
    GeneralInfo res = await myplayer.nowPlaying();
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
                if(data != null)
                  Container(
                    child: Column(
                      children: <Widget>[
                        if(data.album.coverArt != null)
                          Image(image: data.album.coverArt.image, height: MediaQuery.of(context).size.height * 0.3,),
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
                                Text(data.song.trackNumber.toString() + "/" + data.album.albumTrackCount.toString()),
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
                if(!playing)
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
                  child: Text("nowPlaying Print"),
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
                    print(res.length);
                    setState(() {
                      artists = res;
                      fetchingAllSong = false;
                    });
                  },
                ),
                FlatButton(
                  child: Text("Artists"),
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Artists(artists: artists,)));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
