//
//  PlayVideoVC.swift
//  Moviesta
//
//  Created by Ridoan Wibisono on 14/11/19.
//  Copyright © 2019 Ridoan Wibisono. All rights reserved.
//

import UIKit
import AVKit




class PlayVideoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func playVideos(){
      
        guard let url = URL(string: "https://www.themoviedb.org/video/play?key=VVN82P8dN7I") else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)

        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player

        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
            
            
        }
    }
    @IBAction func play(_ sender: Any) {
        
        let videoURL = URL(string: "https://www.youtube.com/embed/xRjvmVaFHkk")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
