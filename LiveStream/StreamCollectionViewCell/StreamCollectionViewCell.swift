//
//  StreamCollectionViewCell.swift
//  LiveStream
//
//  Created by Aamir on 12/21/24.
//

import UIKit
import Foundation
import AVFoundation

class StreamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pauseImage: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var streamHeaderView: StreamHeaderView!
    @IBOutlet weak var footerView: StreamFooterView!

    var togglePlayPause: (() -> ())?
    private var playerLayer: AVPlayerLayer? = AVPlayerLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestures()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.player?.pause()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = contentView.bounds
    }
    
    private func addGestures() {
        let likeGesture = UITapGestureRecognizer(target: self, action: #selector(liked))
        likeGesture.numberOfTapsRequired = 2
        
        let playPauseGesture = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped))
        playPauseGesture.numberOfTapsRequired = 1
        
        playPauseGesture.delegate = self
        likeGesture.delegate = self
        
        videoView.isUserInteractionEnabled = true
        playPauseGesture.require(toFail: likeGesture)

        videoView.addGestureRecognizer(playPauseGesture)
        videoView.addGestureRecognizer(likeGesture)
    }
    
    func configure(videoData: VideoData, shareActionDelegate: ShareActionDelegate) {
        streamHeaderView.videoData = videoData
        footerView.startAnimatingComments()
        footerView.videoData = videoData
        footerView.shareActionDelegate = shareActionDelegate
        footerView.roseActionDelegate = streamHeaderView
    }
    
    func addPlayer(player: AVPlayer) {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.contentView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let layer = playerLayer {
            DispatchQueue.main.async {
                self.videoView.layer.insertSublayer(layer, at: 0)
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(restartVideo),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)

    }
    
    @objc func liked() {
        footerView.animateLike()
        streamHeaderView.addLike()
    }
}


//MARK: Play, Pause & Restart
extension StreamCollectionViewCell {
    @objc func playPauseTapped() {
        
        if pauseImage.isHidden {
            pauseVideo()
            pauseImage.isHidden = false
        } else {
            playVideo()
            pauseImage.isHidden = true
        }
        
    }
    
    func playVideo() {
        if !pauseImage.isHidden {
            pauseImage.isHidden = true
        }
        playerLayer?.player?.play()
    }
    
    func pauseVideo() {
        playerLayer?.player?.pause()
    }
    
    @objc func restartVideo() {
        playerLayer?.player?.seek(to: .zero)
        playerLayer?.player?.play()
    }

}
//MARK: Gesture Delegate
extension StreamCollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
