//
//  AddEditEntryViewController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit

class AddEditEntryViewController: UIViewController, PhotoSelectViewControllerDelegate {
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        // Check if there is an image or a movie, get the data from it, and save it.
        if let image = image {
            guard let photoData = UIImagePNGRepresentation(image),
                let note = noteTextField.text else { return }
            
            if let entry = entry {
            // update
            } else {
            
                EntryController.shared.createEntry(imageData: photoData, oldVideoURL: nil, note: note)
            }
        } else if let movieURL = movieURL {
            guard let note = noteTextField.text else { return }
            
            EntryController.shared.createEntry(imageData: nil, oldVideoURL: movieURL, note: note)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    var entry: Entry? {
        didSet {
            if isViewLoaded { updateViews() }
        }
    }
    var image: UIImage?
    var movieURL: URL?
    
    @IBOutlet weak var noteTextField: UITextField!
    
    func photoSelectViewControllerSelected(_ image: UIImage) {
        self.image = image
    }
    
    func photoSelectViewControllerSelectedMovie(movieURL: URL) {
        self.movieURL = movieURL
    }
    
    private func updateViews() {
        guard let entry = entry else { return }
        noteTextField.text = entry.note
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.primaryAppBlue
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContainerView" {
            guard let destinationVC = segue.destination as? MediaSelectViewController else { return }
            destinationVC.delegate = self
            
        }
    }

}
