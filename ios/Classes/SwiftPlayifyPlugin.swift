import Flutter
import UIKit
import MediaPlayer

public class SwiftPlayifyPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.kaya.playify/playify", binaryMessenger: registrar.messenger())
        let instance = SwiftPlayifyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    @available(iOS 10.1, *)
    private lazy var player = Player()

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if #available(iOS 10.1, *) {
            if(call.method == "play"){
                self.play()
                result(Bool(true))
            }
            else if(call.method == "pause") {
                self.pause()
                result(Bool(true))
            }
            else if(call.method == "next") {
                self.next()
                result(Bool(true))
            }
            else if(call.method == "previous") {
                self.previous()
                result(Bool(true))
            }
            else if(call.method == "seekForward") {
                self.seekForward()
                result(Bool(true))
            }
            else if(call.method == "seekBackward") {
                self.seekBackward()
                result(Bool(true))
            }
            else if(call.method == "endSeeking") {
                self.endSeeking()
                result(Bool(true))
            }
            else if(call.method == "isPlaying"){
                let isplaying = self.isPlaying();
                result(Bool(isplaying))
            }
            else if(call.method == "setShuffleMode") {
                guard let args = call.arguments as? [String: Any] else {
                    print("Param is empty")
                    result(Bool(false))
                    return
                }
                let mode = args["mode"] as! String
                self.setShuffleMode(mode: mode)
                result(Bool(true))
            }
            else if(call.method == "setRepeatMode") {
                guard let args = call.arguments as? [String: Any] else {
                    print("Param is empty")
                    result(Bool(false))
                    return
                }
                let mode = args["mode"] as! String
                self.setRepeatMode(mode: mode)
                result(Bool(true))
            }
            else if(call.method == "getPlaybackTime") {
                let time = self.getPlaybackTime()
                result(Float(time))
            }
            else if(call.method == "setPlaybackTime") {
                guard let args = call.arguments as? [String: Any] else {
                    print("Param is empty")
                    result(Bool(false))
                    return
                }
                let time = (args["time"] as! NSNumber).floatValue
                self.setPlaybackTime(time: time)
                result(Bool(true))
            }
            else if(call.method == "setQueue"){
                guard let args = call.arguments as? [String: Any] else {
                    print("Param is empty")
                    result(Bool(false))
                    return
                }
                let songIDs = args["songIDs"] as! [String]
                let startIndex = (args["startIndex"] as! NSNumber).intValue
                self.setQueue(songIDs: songIDs, startIndex: startIndex)
                result(Bool(true))
            }
            else if(call.method == "nowPlaying") {
                let metadata = self.nowPlaying()
                if(metadata == nil){
                    result(nil)
                    return
                }
                
                let image = metadata?.artwork?.image(at: CGSize(width: 800, height: 800))
                //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)
                guard let imgdata = image?.jpegData(compressionQuality: 1.0) else {
                    return
                }
                
                guard let duration = metadata?.playbackDuration else {
                    return
                }
                
                let data: [String: Any] = [
                    "artist": metadata?.artist ?? "",
                    "songTitle": metadata?.title ?? "",
                    "albumTitle": metadata?.albumTitle ?? "",
                    "albumArtist": metadata?.albumArtist ?? "",
                    "trackNumber": metadata?.albumTrackNumber ?? -1,
                    "albumTrackCount": metadata?.albumTrackCount ?? -1,
                    "playCount": metadata?.playCount ?? -1,
                    "discCount": metadata?.discCount ?? -1,
                    "discNumber": metadata?.discNumber ?? -1,
                    "isExplicitItem": metadata?.isExplicitItem ?? "",
                    "songID": metadata?.persistentID ?? "",
                    "playbackDuration": Float(duration),
                    "image": imgdata
                ]
                result(data)
            }
            else if(call.method == "getAllSongs"){
                let allsongs = self.getAllSongs()
                var mysongs: [[String: Any]] = []
                guard let args = call.arguments as? [String: Any] else {
                    print("Param is empty")
                    return
                }
                //var ctr = 0
                var albums: [String] = []
                for metadata in allsongs {
                    //ctr += 1
                    //print(ctr, terminator: ", ")
    
                    let artist = metadata.artist
                    let songTitle = metadata.title
                    let albumTitle = metadata.albumTitle
                    let albumArtist = metadata.albumArtist
                    let albumTrackNumber = metadata.albumTrackNumber
                    let albumTrackCount = metadata.albumTrackCount
                    let playCount = metadata.playCount
                    let discCount = metadata.discCount
                    let discNumber = metadata.discNumber
                    let isExplicitItem = metadata.isExplicitItem
                    let songID = metadata.persistentID
                    let playbackDuration = Float(metadata.playbackDuration)

                    var albumExists = false

                    for album in albums {
                        let myalbumTitle = album
                        if myalbumTitle == albumTitle {
                            albumExists = true
                        }
                    }
                    if(!albumExists){
                        let image = metadata.artwork?.image(at: CGSize(width: (args["size"]! as! NSNumber).intValue, height: (args["size"]!  as! NSNumber).intValue))
                        //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)

                        let imgdata = image?.jpegData(compressionQuality: 0.85)
                        
                        let song: [String: Any] = [
                            "artist": artist ?? "",
                            "songTitle": songTitle ?? "",
                            "albumTitle": albumTitle ?? "",
                            "albumArtist": albumArtist ?? "",
                            "trackNumber": albumTrackNumber,
                            "albumTrackNumber": albumTrackNumber,
                            "albumTrackCount": albumTrackCount,
                            "playCount": playCount,
                            "discCount": discCount,
                            "discNumber": discNumber,
                            "isExplicitItem": isExplicitItem,
                            "songID": songID,
                            "playbackDuration": playbackDuration,
                            "image": imgdata
                        ];
                        mysongs.append(song)
                        albums.append(albumTitle!)
                    }
                    else {
                        let song: [String: Any] = [
                            "artist": artist ?? "",
                            "songTitle": songTitle ?? "",
                            "albumTitle": albumTitle ?? "",
                            "albumArtist": albumArtist ?? "",
                            "trackNumber": albumTrackNumber,
                            "albumTrackNumber": albumTrackNumber,
                            "albumTrackCount": albumTrackCount,
                            "playCount": playCount,
                            "discCount": discCount,
                            "discNumber": discNumber,
                            "isExplicitItem": isExplicitItem,
                            "songID": songID
                        ];
                        mysongs.append(song)
                    }
                }
                result(mysongs)
            }
        }
        else {
            print("Requires min iOS 10.3")
         }
    }
    
    @available(iOS 10.1, *)
    public func setQueue(songIDs: [String], startIndex: Int){
        player.setQueue(songIDs: songIDs, startIndex: startIndex)
    }

    @available(iOS 10.1, *)
    public func play(){
        player.play()
    }
    
    @available(iOS 10.1, *)
    public func seekForward(){
        player.seekForward()
    }
    
    @available(iOS 10.1, *)
    public func seekBackward(){
        player.seekBackward()
    }
    
    @available(iOS 10.1, *)
    public func endSeeking(){
        player.endSeeking()
    }
    
    @available(iOS 10.1, *)
    public func isPlaying() -> Bool{
        return player.isPlaying()
    }
    
    @available(iOS 10.1, *)
    public func getPlaybackTime() -> Float{
        return player.getPlaybackTime()
    }
    
    @available(iOS 10.1, *)
    public func setPlaybackTime(time: Float){
        player.setPlaybackTime(time: time)
    }
    
    @available(iOS 10.1, *)
    public func setShuffleMode(mode: String){
        player.setShuffleMode(mode: mode)
    }

    @available(iOS 10.1, *)
    public func setRepeatMode(mode: String){
        player.setRepeatMode(mode: mode)
    }

    @available(iOS 10.1, *)
    public func pause(){
        player.pause()
    }
    
    @available(iOS 10.1, *)
    public func next(){
        player.next()
    }
    
    @available(iOS 10.1, *)
    public func previous(){
        player.previous()
    }

    @available(iOS 10.1, *)
    public func nowPlaying() -> MPMediaItem? {
        return player.nowPlaying()
    }

    @available(iOS 10.1, *)
    public func getAllSongs() -> [MPMediaItem] {
        return player.getAllSongs()
    }
}
