import Foundation
import MediaPlayer

public class Player {
    var player: MPMusicPlayerController = MPMusicPlayerApplicationController.applicationMusicPlayer
    func play(){
        player.play()
    }
}
