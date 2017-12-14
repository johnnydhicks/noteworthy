//
//  MediaSelectViewController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos

class MediaSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Variables and Outlets
    weak var delegate: PhotoSelectViewControllerDelegate?
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectMediaButton: UIButton!
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    var mediaSelected: Bool = false
    
    var entry: Entry?
    
    var authorizationStatus: PHAuthorizationStatus = .notDetermined
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
            avPlayer?.play()
        }
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMoviePlayer()
        
        updateViews()
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        if let videoURLString = entry.videoURL,
            let videoURL = URL(string: videoURLString) {
            
            selectMediaButton.setTitle("", for: [])
            selectMediaButton.backgroundColor = .clear
            //            setupMoviePlayer()
            let finalVideoURL = createVideoURL(url: videoURL)!
            videoPlayerItem = AVPlayerItem(url: finalVideoURL)
            print("-----> \(finalVideoURL)")
            let fm = FileManager.default
            let exist = fm.fileExists(atPath: finalVideoURL.path)
            print("-----> \(exist)")
            imageView.image = nil
            
        } else if let imageData = entry.imageData {
            
            imageView.image = UIImage(data: imageData as Data)
            imageView.clipsToBounds = true
            selectMediaButton.setTitle("", for: [])
            selectMediaButton.backgroundColor = .clear
            videoPlayerItem = nil
        }
    }
    
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
    
    func setupMoviePlayer() {
        guard self.avPlayer == nil else { return }
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
        avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height)
        self.videoView.layer.insertSublayer(avPlayerLayer!, at: 0)
        self.videoView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero, completionHandler: nil)
    }
    
    @IBAction func selectMediaButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Select Media Location", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            
            alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                
                if PHPhotoLibrary.authorizationStatus() == .notDetermined ||
                    PHPhotoLibrary.authorizationStatus() == .denied {
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        self.authorizationStatus = status
                        
                        if self.authorizationStatus == .authorized {
                            self.showImagePickerFor(sourceType: .photoLibrary)
                        }
                    })
                } else if PHPhotoLibrary.authorizationStatus() == .authorized {
                    self.showImagePickerFor(sourceType: .photoLibrary)
                }
            }))
        }
        
        // Configuration for adding a photo from using the Camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                self.showImagePickerFor(sourceType: .camera)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerFor(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.videoMaximumDuration = 30
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            delegate?.photoSelectViewControllerSelected(image)
            selectMediaButton.setTitle("", for: UIControlState())
            selectMediaButton.backgroundColor = nil
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            avPlayerLayer = nil
            avPlayer = nil
            videoPlayerItem = nil
            
            picker.dismiss(animated: true, completion: nil)
            
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            
            selectMediaButton.setTitle("", for: UIControlState())
            selectMediaButton.backgroundColor = nil
            delegate?.photoSelectViewControllerSelectedMovie(movieURL: videoURL)
            
            imageView.image = nil
            
            self.videoPlayerItem = AVPlayerItem(url: videoURL)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

protocol PhotoSelectViewControllerDelegate: class {
    func photoSelectViewControllerSelected(_ image: UIImage)
    func photoSelectViewControllerSelectedMovie(movieURL: URL)
}
