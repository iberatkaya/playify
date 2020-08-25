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
                guard let args = call.arguments as? [String: Any] else {
                    print("Param is empty")
                    return
                }
                let metadata = self.nowPlaying()
                if(metadata == nil){
                    result(nil)
                    return
                }
                
                let image = metadata?.artwork?.image(at: CGSize(width: (args["size"]! as! NSNumber).intValue, height: (args["size"]! as! NSNumber).intValue))
                
                //Resize image since there is an issue with getting the album cover with the desired size
                let resizedImage = (image != nil) ? resizeImage(image: image!, targetSize: CGSize(width: (args["size"]! as! NSNumber).intValue, height: (args["size"]! as! NSNumber).intValue)) : nil
                
                //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)
                guard let imgdata = resizedImage?.jpegData(compressionQuality: 1.0) else {
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
                    "genre": metadata?.genre ?? "",
                    "releaseDate": Int64((metadata?.releaseDate?.timeIntervalSince1970 ?? 0) * 1000),
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
                var albums: [String] = []
                for metadata in allsongs {
                    let artist = metadata.artist
                    let songTitle = metadata.title
                    let albumTitle = metadata.albumTitle
                    let albumArtist = metadata.albumArtist
                    let albumTrackNumber = metadata.albumTrackNumber
                    let albumTrackCount = metadata.albumTrackCount
                    let genre = metadata.genre
                    let playCount = metadata.playCount
                    let discCount = metadata.discCount
                    let discNumber = metadata.discNumber
                    let isExplicitItem = metadata.isExplicitItem
                    let songID = metadata.persistentID
                    let playbackDuration = Float(metadata.playbackDuration)
                    let releaseDate = Int64((metadata.releaseDate?.timeIntervalSince1970 ?? 0) * 1000)
                
                    
                    var albumExists = false

                    for album in albums {
                        let myalbumTitle = album
                        if myalbumTitle == albumTitle {
                            albumExists = true
                        }
                    }
                    if(!albumExists){
                        let image = metadata.artwork?.image(at: CGSize(width: (args["size"]! as! NSNumber).intValue, height: (args["size"]!  as! NSNumber).intValue))
                        
                        //Resize image since there is an issue with getting the album cover with the desired size
                        let resizedImage = (image != nil) ? resizeImage(image: image!, targetSize: CGSize(width: (args["size"]! as! NSNumber).intValue, height: (args["size"]! as! NSNumber).intValue)) : nil

                        //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)
                        let imgdata = resizedImage?.jpegData(compressionQuality: 0.85)
                        
                        let song: [String: Any] = [
                            "artist": artist ?? "",
                            "songTitle": songTitle ?? "",
                            "albumTitle": albumTitle ?? "",
                            "albumArtist": albumArtist ?? "",
                            "trackNumber": albumTrackNumber,
                            "albumTrackNumber": albumTrackNumber,
                            "albumTrackCount": albumTrackCount,
                            "genre": genre ?? "",
                            "releaseDate": releaseDate,
                            "playCount": playCount,
                            "discCount": discCount,
                            "discNumber": discNumber,
                            "isExplicitItem": isExplicitItem,
                            "songID": songID,
                            "playbackDuration": playbackDuration,
                            "image": imgdata ?? []
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
                            "genre": genre ?? "",
                            "releaseDate": releaseDate,
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
    
    
    //Taken from https://stackoverflow.com/a/39681316/11701504
    public func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
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
