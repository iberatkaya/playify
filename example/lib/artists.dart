import 'package:flutter/material.dart';
import 'package:playify_example/albums.dart';
import 'package:playify/playify.dart';

class Artists extends StatefulWidget {
  List<Artist> artists;
  Artists({List<Artist> artists}) {
    this.artists = artists;
  }

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
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
                        itemCount: widget.artists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Albums(
                                              albums: widget
                                                  .artists[index].albums)));
                                },
                                color: Colors.blueGrey[50],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(widget.artists[index].name,
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                              Divider(
                                color: Color.fromRGBO(220, 220, 220, 1),
                              )
                            ],
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
