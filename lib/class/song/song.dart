class Song {
  Song({String title, String artistName, String albumTitle, int trackNumber, int playCount, int discNumber, bool isExplicit}){
    this.title = title;
    this.trackNumber = trackNumber;
    this.albumTitle = albumTitle;
    this.artistName = artistName;
    this.trackNumber = playCount;
    this.trackNumber = discNumber;
    this.isExplicit = isExplicit;
  }
  String albumTitle;
  String artistName;
  String title;
  int trackNumber;
  int playCount;
  int discNumber;
  bool isExplicit;
}