import Foundation
import MediaPlayer

@available(iOS 10.3, *)
public class Player {
    var player: MPMusicPlayerController = MPMusicPlayerApplicationController.systemMusicPlayer
    
    //Requires 2 plays due to this bug: https://stackoverflow.com/a/61697108
    func play(){
        player.play()
        player.play()
    }
    
    func pause(){
        player.pause()
    }
    
    func next(){
        player.skipToNextItem()
    }
    
    func previous(){
        player.skipToPreviousItem()
    }
    
    func nowPlaying() -> MPMediaItem? {
        return player.nowPlayingItem
    }
    
    func getAllSongs() -> [MPMediaItem] {
        let songsQuery = MPMediaQuery.songs()
        let songs = songsQuery.items ?? []
        return songs
    }
}
