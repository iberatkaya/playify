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
            else if(call.method == "setQueue"){
                guard let args = call.arguments as? [String: Any] else {
                    print("Param is empty")
                    return
                }
                let songIDs = args["songIDs"] as! [String]
                let startIndex = args["startIndex"] as! Int
                self.setQueue(songIDs: songIDs, startIndex: startIndex)
                result(Bool(true))
            }
            else if(call.method == "nowPlaying") {
                let metadata = self.nowPlaying()
                let image = metadata?.artwork?.image(at: CGSize(width: 800, height: 800))
                //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)
                guard let imgdata = image?.jpegData(compressionQuality: 1.0) else { return }
                
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
                    
                    var albumExists = false

                    for album in albums {
                        let myalbumTitle = album
                        if myalbumTitle == albumTitle {
                            albumExists = true
                        }
                    }
                    if(!albumExists){
                        let image = metadata.artwork?.image(at: CGSize(width: args["size"]! as! Int, height: args["size"]! as! Int))
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
