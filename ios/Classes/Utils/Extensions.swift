import MediaPlayer

@available(iOS 10.0, *)
extension MPMediaItem {
    ///Returns a dicationary without the image data set.
    func toDict() -> [String: Any] {
        return [
            "artist": artist ?? "",
            "songTitle": title ?? "",
            "albumTitle": albumTitle ?? "",
            "albumArtist": albumArtist ?? "",
            "trackNumber": albumTrackNumber,
            "albumTrackNumber": albumTrackNumber,
            "albumTrackCount": albumTrackCount,
            "genre": genre ?? "",
            "releaseDate": Int64((releaseDate?.timeIntervalSince1970 ?? 0) * 1000),
            "playCount": playCount,
            "discCount": discCount,
            "discNumber": discNumber,
            "isExplicitItem": isExplicitItem,
            "songID": persistentID,
            "playbackDuration": playbackDuration
        ]
    }
}
