//
//  AddEditEntryViewController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit

let imagePickerAlertControllerGesureRecognizerWasSetNotification = Notification.Name("imagePickerAlertControllerGesureRecognizerWasSet")

class AddEditEntryViewController: ShiftableViewController, PhotoSelectViewControllerDelegate {
    
    // MARK: - Properties & Outlets
    var entry: Entry? 
    var image: UIImage?
    var movieURL: URL?
    var placeholderLabel: UILabel!
    
    weak var imagePickerAlertControllerGesureRecognizer: UIGestureRecognizer?
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - ACTIONS
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if image == nil && movieURL == nil {
            setUpAlertController()
        }
        // Check if there is an image or a movie, get the data from it, and save it.
        if let image = image {
            guard let photoData = UIImagePNGRepresentation(image),
                let note = noteTextView.text else { return }
            
            if let entry = entry {
                EntryController.shared.update(entry: entry, imageData: photoData, oldVideoURL: nil, note: note)
            } else {
                EntryController.shared.createEntry(imageData: photoData, oldVideoURL: nil, note: note)
            }
        } else if let movieURL = movieURL {
            guard let note = noteTextView.text else { return }
            if let entry = entry {
                EntryController.shared.update(entry: entry, imageData: nil, oldVideoURL: movieURL, note: note)
            } else {
                EntryController.shared.createEntry(imageData: nil, oldVideoURL: movieURL, note: note)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func setUpAlertController() {
        let alertController = UIAlertController(title: "Missing Video/Image", message: "To save the entry, please select an image or video", preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAlert)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.primaryAppBlue
        noteTextView.delegate = self
    
        updateViews()
        
        noteTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter Note Here..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (noteTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        noteTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (noteTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !noteTextView.text.isEmpty
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: imagePickerAlertControllerGesureRecognizerWasSetNotification, object: nil)
    }
    
    
    @objc func hideKeyboard(notification: Notification) {
        textViewBeingEdited?.resignFirstResponder()
        textFieldBeingEdited?.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    private func updateViews() {
        guard let entry = entry else { return }
        noteTextView.text = entry.note
        dateLabel.text = dateFormatter.string(from: entry.timestamp as Date)
        
        if let imageData = entry.imageData {
            image = UIImage(data: imageData as Data)
        }
        
        if let videoURLString = entry.videoURL,
            let videoURL = URL(string: videoURLString) {
            movieURL = videoURL
        }
    }
    
    func photoSelectViewControllerSelected(_ image: UIImage) {
        self.image = image
        self.movieURL = nil
    }
    
    func photoSelectViewControllerSelectedMovie(movieURL: URL) {
        self.movieURL = movieURL
        self.image = nil
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTextView.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContainerView" {
            guard let destinationVC = segue.destination as? MediaSelectViewController else { return }
            destinationVC.delegate = self
            if let entry = entry {
                destinationVC.entry = entry
            }
        }
    }

    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
}
