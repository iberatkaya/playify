//
//  Player.swift
//  Runner
//
//  Created by MACBOOK on 9.06.2020.
//

import Foundation
import MediaPlayer

public class Player {
    var player: MPMusicPlayerController = MPMusicPlayerApplicationController.applicationMusicPlayer
    func play(){
        player.play()
    }
}
