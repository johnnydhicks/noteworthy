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
    
    
    weak var delegate: PhotoSelectViewControllerDelegate?
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectMediaButton: UIButton!
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    
    var authorizationStatus: PHAuthorizationStatus = .notDetermined
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
            avPlayer?.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMoviePlayer()
        if PHPhotoLibrary.authorizationStatus() == .notDetermined ||
            PHPhotoLibrary.authorizationStatus() == .denied {
            PHPhotoLibrary.requestAuthorization({ (status) in
                self.authorizationStatus = status
            })
            
        }
    }
    
    func setupMoviePlayer() {
        
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
        
        if UIScreen.main.bounds.width == 375 {
            let widthRequired = videoView.frame.size.width
            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
        }else if UIScreen.main.bounds.width == 320 {
            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: (videoView.frame.size.height - 120) * 1.78, height: videoView.frame.size.height - 120)
        }else{
            let widthRequired = videoView.frame.size.width
            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
        }
        videoView.backgroundColor = .clear
        self.videoView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
    }
    
    func startPlayback() {
        self.avPlayer?.play()
    }
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    @IBAction func selectMediaButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Select Media Location", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
                
                DispatchQueue.main.async {
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }))
            
        }
        
        // Configuration for adding a photo from using the Camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.cameraCaptureMode = .video
                imagePicker.modalPresentationStyle = .popover
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            delegate?.photoSelectViewControllerSelected(image)
            selectMediaButton.setTitle("", for: UIControlState())
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            
            picker.dismiss(animated: true, completion: nil)
            
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            
            selectMediaButton.setTitle("", for: UIControlState())
            delegate?.photoSelectViewControllerSelectedMovie(movieURL: videoURL)
            
            self.videoPlayerItem = AVPlayerItem(url: videoURL)
            
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
}

protocol PhotoSelectViewControllerDelegate: class {
    
    func photoSelectViewControllerSelected(_ image: UIImage)
    func photoSelectViewControllerSelectedMovie(movieURL: URL)
}
