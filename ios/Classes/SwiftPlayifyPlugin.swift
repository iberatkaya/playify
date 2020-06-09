import Flutter
import UIKit
import MediaPlayer

public class SwiftPlayifyPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
    print("Registering")
    let channel = FlutterMethodChannel(name: "com.kaya.playify/playify", binaryMessenger: registrar.messenger())
    print("Registered")
    let instance = SwiftPlayifyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    @available(iOS 10.3, *)
    private lazy var player = Player()

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if #available(iOS 10.3, *) {
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
            else if(call.method == "nowPlaying") {
                let metadata = self.nowPlaying()
                let image = metadata?.artwork?.image(at: CGSize(width: 1000, height: 1000))
                //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)
                guard let imgdata = image?.jpegData(compressionQuality: 1.0) else { return }
                
                let data: [String: Any] = [
                    "artist": metadata?.artist ?? "",
                    "songTitle": metadata?.title ?? "",
                    "albumTitle": metadata?.albumTitle ?? "",
                    "albumArtist": metadata?.albumArtist ?? "",
                    "trackNumber": metadata?.albumTrackNumber ?? -1,
                    "albumTrackNumber": metadata?.albumTrackNumber ?? -1,
                    "albumTrackCount": metadata?.albumTrackCount ?? -1,
                    "playCount": metadata?.playCount ?? -1,
                    "discCount": metadata?.discCount ?? -1,
                    "discNumber": metadata?.discNumber ?? -1,
                    "isExplicitItem": metadata?.isExplicitItem ?? "",
                    "image": imgdata
                ]
                result(data)
            }
            else if(call.method == "getAllSongs"){
                let allsongs = self.getAllSongs()
                var mysongs: [[String: Any]] = []
                print("All collection count: ")
                print(allsongs.count)
                var ctr = 0
                for metadata in allsongs {
                    ctr += 1
                    print(ctr, terminator: ", ")
                    let image = metadata.artwork?.image(at: CGSize(width: 50, height: 50))
                    //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)

                    var imgdata = image?.jpegData(compressionQuality: 0.3)
                    
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

                    let song: [String: Any] = [
                        "artist": artist,
                        "songTitle": songTitle,
                        "albumTitle": albumTitle,
                        "albumArtist": albumArtist,
                        "trackNumber": albumTrackNumber,
                        "albumTrackNumber": albumTrackNumber,
                        "albumTrackCount": albumTrackCount,
                        "playCount": playCount,
                        "discCount": discCount,
                        "discNumber": discNumber,
                        "isExplicitItem": isExplicitItem,
                        "image": imgdata
                    ];
                    mysongs.append(song)
                }
                print("finished")
                result(mysongs)
            }
        }
        else {
            print("Requires min iOS 10.3")
         }
    }

    @available(iOS 10.3, *)
    public func play(){
        player.play()
    }
    
    @available(iOS 10.3, *)
    public func pause(){
        player.pause()
    }
    
    @available(iOS 10.3, *)
    public func next(){
        player.next()
    }
    
    @available(iOS 10.3, *)
    public func previous(){
        player.previous()
    }

    @available(iOS 10.3, *)
    public func nowPlaying() -> MPMediaItem? {
        return player.nowPlaying()
    }

    @available(iOS 10.3, *)
    public func getAllSongs() -> [MPMediaItem] {
        return player.getAllSongs()
    }
}
