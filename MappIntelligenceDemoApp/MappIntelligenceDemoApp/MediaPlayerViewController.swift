//
//  MediaPlayerViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 30/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class MediaPlayerViewController: UIViewController {

    var streamUrl: URL? = nil
    @IBOutlet weak var videoView: UIView!
    var player:AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isVideoPlaying = false
    var bitrate:NSNumber? = nil
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var postitionLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = streamUrl {
            player = AVPlayer(url: url)
        } else {
            let videoURL: URL = Bundle.main.url(forResource: "wt", withExtension: "mp4")!
            player = AVPlayer(url: videoURL)
        }

        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        player.currentItem?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        addTimeObserver()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        videoView.layer.addSublayer(playerLayer!)
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
        
        trackMedia()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
        trackMedia()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0 {
            self.durationLabel.text = getTimeString(from: player.currentItem!.duration)
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
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
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
            self?.timeSlider.maximumValue = maximumValue
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.postitionLabel.text = self?.getTimeString(from: currentItem.currentTime())
            if let bps = self?.player.currentItem?.accessLog()?.events.last?.observedBitrate {
                self?.bitrate = NSNumber(value: bps)
            }
            
        })
        
    }
    
    func trackMedia() {
        let action = isVideoPlaying ? "play" : "pause"
        guard let position = player.currentItem?.currentTime().seconds else { return }
        guard let duration = player.currentItem?.duration.seconds else { return }

        let mediaProperties = MIMediaProperties("TestVideoExample", action: action, postion: position, duration: duration)
        mediaProperties.soundVolume = NSNumber(value: (AVAudioSession.sharedInstance().outputVolume) * 255.0)
        mediaProperties.soundIsMuted = AVAudioSession.sharedInstance().outputVolume == 0.0 ? "1" : "0"
        if bitrate != nil {
            mediaProperties.bandwith = bitrate
        }
            
        let event = MIMediaEvent(pageName: "MediaViewController", properties: mediaProperties)
        MappIntelligence.shared()?.trackMedia(event)
    }
}
