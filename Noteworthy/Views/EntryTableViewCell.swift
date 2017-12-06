//
//  EntryTableViewCell.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? {
        didSet {
            self.updateCell()
        }
    }
    
    @IBOutlet weak var videoPlayerSuperView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false

    
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
            avPlayer?.play()
            flipImage(image: photoImageView.image ?? UIImage())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
        videoPlayerItem = nil
    }

    
    func setupMoviePlayer() {
        guard self.avPlayer == nil else { return }
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
        avPlayer?.isMuted = true
        avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: photoImageView.frame.width, height: photoImageView.frame.height)
        
        self.backgroundColor = .clear
        self.videoPlayerSuperView.layer.insertSublayer(avPlayerLayer!, at: 0)
        self.videoPlayerSuperView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
   @discardableResult func flipImage(image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else {
            return image
        }
        let flippedImage = UIImage(cgImage: cgImage,
                                   scale: image.scale,
                                   orientation: .leftMirrored)
        return flippedImage
    }
    
    func updateCell() {
        guard let entry = entry else { return }
    
        dateLabel.text = dateFormatter.string(from: entry.timestamp as Date)
        noteLabel.text = entry.note
        
        
        if let imageData = entry.imageData {
        photoImageView.image = UIImage(data: imageData as Data)
        photoImageView.contentMode = UIViewContentMode.scaleAspectFill
        photoImageView.clipsToBounds = true
            
        } else if let videoURLString = entry.videoURL,
            let videoURL = URL(string: videoURLString) {
            setupMoviePlayer()
            let finalVideoURL = createVideoURL(url: videoURL)!
            videoPlayerItem = AVPlayerItem(url: finalVideoURL)
            print("-----> \(finalVideoURL)")
            let fm = FileManager.default
            let exist = fm.fileExists(atPath: finalVideoURL.path)
            print("-----> \(exist)")
            photoImageView.image = nil
        }
    }
    
    // Creating video URL to be referenced in core data
    func createVideoURL(url: URL) -> URL? {
        do {
            let directoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let finalDirectory = directoryURL.appendingPathComponent(url.path)
            return finalDirectory
        } catch let e {
            print("Error getting docs directory \(e)")
        }
        return nil
    }
    
    // Formats the data for each entry
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

}
