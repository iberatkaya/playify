import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:playify/playify.dart';
import 'package:playify/class/generalinfo/generalinfo.dart';

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
        primarySwatch: Colors.red,
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

  GeneralInfo data;
    var myplayer = Playify();

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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Center(
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
                FlatButton(
                  child: Text("play"),
                  onPressed: () async {
                    var res = await myplayer.play();
                  },
                ),
                FlatButton(
                  child: Text("pause"),
                  onPressed: () async {
                    var res = await myplayer.pause();
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
                    await myplayer.getAllSongs();
                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
