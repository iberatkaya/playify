import 'package:flutter/material.dart';
import 'package:playify/playify.dart';

class Songs extends StatefulWidget {
  List<Song> songs;
  Songs({List<Song> songs}) {
    this.songs = songs;
  }

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Playify'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: ListView.builder(
                      itemCount: widget.songs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            FlatButton(
                              onPressed: () async {
                                List<String> songs = [];
                                for (int i = index; i < widget.songs.length; i++) {
                                  songs.add(widget.songs[i].iOSSongID);
                                }
                                Playify myplayer = Playify();
                                await myplayer.setQueue(songIDs: songs);
                              },
                              color: Colors.blueGrey[50],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      widget.songs[index].trackNumber.toString() +
                                          ". " +
                                          widget.songs[index].title,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Color.fromRGBO(220, 220, 220, 1),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
