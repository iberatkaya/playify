import Flutter
import UIKit
import MediaPlayer

public class SwiftPlayifyPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.kaya.playify/playify", binaryMessenger: registrar.messenger())
        let instance = SwiftPlayifyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    @available(iOS 10.3, *)
    private lazy var player = Player()

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if #available(iOS 10.3, *) {
            if(call.method == "play"){
                player.play()
                result(nil)
            }
            else if(call.method == "playItem"){
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let songID = args["songID"] as? String else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter songID was not provided!"))
                    return
                }
                player.playItem(songID: songID)
                result(nil)
            }
            else if(call.method == "pause") {
                player.pause()
                result(nil)
            }
            else if(call.method == "next") {
                player.next()
                result(nil)
            }
            else if(call.method == "previous") {
                player.previous()
                result(nil)
            }
            else if(call.method == "seekForward") {
                player.seekForward()
                result(nil)
            }
            else if(call.method == "seekBackward") {
                player.seekBackward()
                result(nil)
            }
            else if(call.method == "endSeeking") {
                player.endSeeking()
                result(nil)
            }
            else if(call.method == "isPlaying"){
                let isplaying = player.isPlaying()
                result(Bool(isplaying))
            }
            else if(call.method == "setShuffleMode") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let mode = args["mode"] as? String else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter mode was not provided!"))
                    return
                }
                player.setShuffleMode(mode: mode)
                result(nil)
            }
            else if(call.method == "setRepeatMode") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let mode = args["mode"] as? String else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter mode was not provided!"))
                    return
                }
                player.setRepeatMode(mode: mode)
                result(nil)
            }
            else if(call.method == "getPlaybackTime") {
                let time = player.getPlaybackTime()
                result(Float(time))
            }
            else if(call.method == "skipToBeginning") {
                player.skipToBeginning()
                result(nil)
            }
            else if(call.method == "prepend") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let songIDs = args["songIDs"] as? [String] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter songIDs was not provided!"))
                    return
                }
                player.prepend(songIDs: songIDs)
                result(nil)
            }
            else if(call.method == "append") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let songIDs = args["songIDs"] as? [String] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter songIDs was not provided!"))
                    return
                }
                player.append(songIDs: songIDs)
                result(nil)
            }
            else if(call.method == "setPlaybackTime") {
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let time = args["time"] as? NSNumber else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter time was not provided!"))
                    return
                }
                player.setPlaybackTime(time: time.floatValue)
                result(nil)
            }
            else if(call.method == "setQueue"){
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The arguments were not provided!"))
                    return
                }
                guard let songIDs = args["songIDs"] as? [String] else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter songIDs was not provided!"))
                    return
                }
                guard let startPlaying = args["startPlaying"] as? Bool else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter startPlaying was not provided!"))
                    return
                }
                let startID = args["startID"] as? String
                do {
                    try player.setQueue(songIDs: songIDs, startPlaying: startPlaying, startID: startID)
                    result(nil)
                } catch PlayifyError.runtimeError(let errorMessage) {
                    result(FlutterError(code: "setQueueError", message: "Set Queue Error", details: errorMessage))
                } catch {
                    result(FlutterError(code: "setQueueError", message: "Set Queue Error", details: error.localizedDescription))
                }
                
            }
            else if(call.method == "nowPlaying") {
                guard let args = call.arguments as? [String: Any] else {
                    print("Param is empty")
                    return
                }
                guard let size = args["size"] as? NSNumber else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter size was not provided!"))
                    return
                }
                guard let metadata = player.nowPlaying() else {
                    result(FlutterError(code: "songError", message: "Current Song Error", details: "An error occured while getting the current song playing!"))
                    return
                }
                
                let image = metadata.artwork?.image(at: CGSize(width: size.intValue, height: size.intValue))
                
                //Resize image since there is an issue with getting the album cover with the desired size
                let resizedImage = (image != nil) ? resizeImage(image: image!, targetSize: CGSize(width: size.intValue, height: size.intValue)) : nil
                
                //Convert image to Uint8 Array to send to Flutter (Taken from https://stackoverflow.com/a/29734526)
                guard let imgdata = resizedImage?.jpegData(compressionQuality: 1.0) else {
                    result(FlutterError(code: "resizeError", message: "Resizing Artwork Error", details: "An error occured while resizing \(metadata.title ?? "")'s artwork!"))
                    return
                }

                let duration = metadata.playbackDuration
                
                let data: [String: Any] = [
                    "artist": metadata.artist ?? "",
                    "songTitle": metadata.title ?? "",
                    "albumTitle": metadata.albumTitle ?? "",
                    "albumArtist": metadata.albumArtist ?? "",
                    "trackNumber": metadata.albumTrackNumber,
                    "albumTrackCount": metadata.albumTrackCount,
                    "playCount": metadata.playCount,
                    "discCount": metadata.discCount,
                    "discNumber": metadata.discNumber,
                    "genre": metadata.genre ?? "",
                    "releaseDate": Int64((metadata.releaseDate?.timeIntervalSince1970 ?? 0) * 1000),
                    "isExplicitItem": metadata.isExplicitItem,
                    "songID": metadata.persistentID,
                    "playbackDuration": Float(duration),
                    "image": imgdata
                ]
                result(data)
            }
            else if(call.method == "getAllSongs"){
                let allsongs = player.getAllSongs()
                var mysongs: [[String: Any]] = []
                guard let args = call.arguments as? [String: Any] else {
                    print("Param is empty")
                    return
                }
                guard let size = args["size"] as? NSNumber else {
                    result(FlutterError(code: "invalidArgs", message: "Invalid Arguments", details: "The parameter size was not provided!"))
                    return
                }
                var albums: [[String: String]] = []
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
                    var albumExistsArtistName = ""

                    for album in albums {
                        let myalbumTitle = album["albumTitle"]
                        if myalbumTitle == albumTitle {
                            albumExists = true
                            albumExistsArtistName = album["artistName"] ?? ""
                        }
                    }
                    if(!albumExists || (albumExists && albumExistsArtistName != artist)){
                        let image = metadata.artwork?.image(at: CGSize(width: size.intValue, height: size.intValue))
                        
                        //Resize image since there is an issue with getting the album cover with the desired size
                        let resizedImage = (image != nil) ? resizeImage(image: image!, targetSize: CGSize(width: size.intValue, height: size.intValue)) : nil

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
                        albums.append(["albumTitle": albumTitle!, "artistName": artist!])
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
}
