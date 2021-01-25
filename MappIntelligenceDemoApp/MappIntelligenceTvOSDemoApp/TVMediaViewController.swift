//
//  TVMediaViewController.swift
//  MappIntelligenceTvOSDemoApp
//
//  Created by Miroljub Stoilkovic on 21/01/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class TVMediaViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var postitionLabel: UILabel!
//    @IBOutlet weak var timeSlider: UISlider!
    
    var player:AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isVideoPlaying = false
    var bitrate:NSNumber? = nil
    var mediaName = "TestVideoExample"
    var initiated = false
    var streamUrl: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = streamUrl {
            player = AVPlayer(url: url)
        } else {
            let videoURL: URL = Bundle.main.url(forResource: "wt", withExtension: "mp4")!
            player = AVPlayer(url: videoURL)
        }

        addTimeObserver()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        videoView.layer.addSublayer(playerLayer!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)

        if(!initiated) {
            trackMediaWithAction(action: "init")
            initiated = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoView.bounds
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if isVideoPlaying {
            player.pause()
            sender.setTitle("Play", for: .normal)
        } else {
            player.play()
            sender.setTitle("Pause", for: .normal)
        }
        isVideoPlaying = !isVideoPlaying
        let action = isVideoPlaying ? "play" : "pause"
        trackMediaWithAction(action: action)
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        player.pause()
        let time = CMTime(value: 0, timescale: 1)
        player.seek(to: time)
        playButton.setTitle("Play", for: .normal)
        isVideoPlaying = false
        trackMediaWithAction(action: "stop")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0 {
        
        }
        if keyPath == "status" {
            print("status")
        }
    }
    
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        var time = "--"
        if hours > 0 {
            time = String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            time = String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
        
        return time
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else {return}
            let maximumValue = Float(currentItem.duration.seconds)
            if (maximumValue != maximumValue) {
                return
            }

            if let bps = self?.player.currentItem?.accessLog()?.events.last?.observedBitrate {
                self?.bitrate = NSNumber(value: bps)
            }
        })
    }
    
    func trackMediaWithAction(action:String) {
        guard let position = player.currentItem?.currentTime().seconds else { return }
        guard let duration = player.currentItem?.duration.seconds, duration == duration else { return }

        let mediaProperties = MIMediaParameters("TestVideoExample", action: action, postion: NSNumber(value: position), duration: NSNumber(value: duration))
        if bitrate != nil {
            mediaProperties.bandwith = bitrate
        }
            
        let event = MIMediaEvent(pageName: "MediaViewController", parameters: mediaProperties)
        MappIntelligencetvOS.shared()?.trackMedia(event)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player.currentItem?.removeObserver(self, forKeyPath: "duration")
        trackMediaWithAction(action: "eof")
    }

}
