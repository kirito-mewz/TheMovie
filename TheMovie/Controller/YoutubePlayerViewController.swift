//
//  YoutubePlayerViewController.swift
//  TheMovie
//
//  Created by Kiyotaka Kirito on 09/11/2025.
//

import UIKit
import youtube_ios_player_helper

class YoutubePlayerViewController: UIViewController, Storyboarded {
    
    // MARK: - IBOutlet
    @IBOutlet weak var youtubePlayerView: YTPlayerView!
    
    // MARK: - Properties
    var keyPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let data = keyPath else { return }
        
        youtubePlayerView.load(withVideoId: data)
        youtubePlayerView.playVideo()

    }
    

}
