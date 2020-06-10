import Foundation
import MediaPlayer

@available(iOS 10.1, *)
public class Player {
    var player: MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer
    //Set the queue with unique store song ids
    func setQueue(songIDs: [String], startIndex: Int) {
        var songs: [MPMediaItem] = []
        for songID in songIDs {
            let songFilter = MPMediaPropertyPredicate(value: songID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
            var query = MPMediaQuery(filterPredicates: Set([songFilter]))
            if(query.items != nil && query.items!.capacity > 0){
                songs.append(query.items![0])
            }
        }
        var descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: songs))
        
        player.setQueue(with: descriptor)
        player.prepareToPlay(completionHandler: {error in
            //Go to the desired song to play
            if error == nil {
                while(self.player.indexOfNowPlayingItem != startIndex){
                    self.player.skipToNextItem()
                }
                self.player.play()
            }
        })
    }
    
    //Play the current queue
    //Requires 2 plays due to this bug: https://stackoverflow.com/a/61697108
    func play(){
        player.play()
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
}
