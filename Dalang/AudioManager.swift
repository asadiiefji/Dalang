//
//  AudioManager.swift
//  Dalang
//
//  Created by Mukhammad Miftakhul As'Adi on 25/05/23.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playMusic(sound: String, type: String)
{
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
            audioPlayer?.numberOfLoops = -1
        }
        catch {
            print("player gabisa ya")
        }
    }
}

