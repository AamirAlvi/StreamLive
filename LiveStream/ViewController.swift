//
//  ViewController.swift
//  LiveStream
//
//  Created by Aamir on 12/21/24.
//

import UIKit
import AVFoundation
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var videos: [VideoData] = []
    var currentVideo: VideoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        videos = MockDataConverter.getVideos()
        if currentVideo == nil {
            currentVideo = videos[0]
        }
        layoutCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pauseVideoForNonVisibleCells()
        playVideoForCell(at: 0)
    }
    
    func layoutCollectionView() {
        collectionView.contentInset = .zero
        collectionView.scrollIndicatorInsets = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
    }
}

//MARK: CollectionView Delegate & Datasource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StreamCollectionViewCell", for: indexPath) as! StreamCollectionViewCell
        cell.configure(videoData: videos[indexPath.item],shareActionDelegate: self)
        if let player = videos[indexPath.row].avPlayer {
            cell.addPlayer(player: player)
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentIndex = Int(scrollView.contentOffset.y / scrollView.frame.height)

        if let currentVideo = currentVideo {
            if currentVideo.id != videos[currentIndex].id {
                currentVideo.avPlayer?.pause()
                pauseVideoForNonVisibleCells()
                self.currentVideo = videos[currentIndex]
                playVideoForCell(at: currentIndex)
            } else {
                playVideoForCell(at: currentIndex)
            }
        }
    }
}

//MARK: Handle Play Pause
extension ViewController {

    private func playVideoForCell(at index: Int) {
        guard index >= 0, index < videos.count else { return }
        
        if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? StreamCollectionViewCell {
            cell.playVideo()
        }
    }
    
    private func pauseVideoForNonVisibleCells() {
        for video in videos {
            if let c = currentVideo {
                if c.id != video.id {
                    video.avPlayer?.pause()
                }
            } else {
                video.avPlayer?.pause()
            }
        }
    }
}

//MARK: CollectionView FlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

//MARK: FooterActionDelegate
extension ViewController: ShareActionDelegate {
    
    func shareTapped(for videoData: VideoData) {
        // Content to share
        let textToShare = videoData.description
        let urlToShare = URL(string: videoData.video)!
        let items: [Any] = [textToShare, urlToShare]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
}
