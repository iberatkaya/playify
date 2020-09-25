import Foundation
import MediaPlayer

@available(iOS 10.1, *)
public class Player {
    var player: MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer
    //Set the queue with unique store song ids
    func setQueue(songIDs: [String], startPlaying: Bool) {
        var songs: [MPMediaItem] = []
        for songID in songIDs {
            let songFilter = MPMediaPropertyPredicate(value: songID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
            let query = MPMediaQuery(filterPredicates: Set([songFilter]))
            if(query.items != nil && query.items!.capacity > 0){
                songs.append(query.items![0])
            }
        }
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: songs))
        
        
        player.setQueue(with: descriptor)
        
        if(startPlaying){
            player.prepareToPlay(completionHandler: {error in
                if error == nil {
                    self.play()
                }
            })
        }
        else {
            player.prepareToPlay()
        }
            
    }
        
    func seekForward(){
        player.beginSeekingForward()
    }
    
    func seekBackward(){
        player.beginSeekingBackward()
    }
    
    func endSeeking(){
        player.endSeeking()
    }
    
    func getPlaybackTime() -> Float{
        return Float(player.currentPlaybackTime)
    }
    
    func setPlaybackTime(time: Float){
        player.currentPlaybackTime = TimeInterval(time)
    }
    
    func setShuffleMode(mode: String){
        if(mode == "off"){
            player.shuffleMode =  MPMusicShuffleMode.off
        }
        else if(mode == "songs"){
            player.shuffleMode =  MPMusicShuffleMode.songs
        }
        else if(mode == "albums"){
            player.shuffleMode = MPMusicShuffleMode.albums
        }
    }
    
    func setRepeatMode(mode: String){
        if(mode == "none"){
            player.repeatMode =  MPMusicRepeatMode.none
        }
        else if(mode == "one"){
            player.repeatMode =  MPMusicRepeatMode.one
        }
        else if(mode == "all"){
            player.repeatMode = MPMusicRepeatMode.all
        }
    }
    
    func playItem(songID: String){
        var songs: [MPMediaItem] = []
        let songFilter = MPMediaPropertyPredicate(value: songID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        var query = MPMediaQuery(filterPredicates: Set([songFilter]))
        if(query.items != nil && query.items!.capacity > 0){
            songs.append(query.items![0])
        }
        
        var descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: songs))
        
        player.setQueue(with: descriptor)
        player.prepareToPlay(completionHandler: {error in
            if error == nil {
                self.player.play()
            }
        })
    }
    
    //Play the current queue
    func play(){
        player.play()
    }
    
    //Pause the current playing song
    func pause(){
        player.pause()
    }
    
    //Skip to the next song in the queue
    func next(){
        player.skipToNextItem()
    }
    
    //Skip to the previous song in the queue
    func previous(){
        player.skipToPreviousItem()
    }
    
    //Get info about the current playing song
    func nowPlaying() -> MPMediaItem? {
        return player.nowPlayingItem
    }
    
    //Retrieve all songs in the library
    func getAllSongs() -> [MPMediaItem] {
        let songsQuery = MPMediaQuery.songs()
        let songs = songsQuery.items ?? []
        return songs
    }
    
    func isPlaying() -> Bool {
        return player.playbackState == MPMusicPlaybackState.playing
    }
}
