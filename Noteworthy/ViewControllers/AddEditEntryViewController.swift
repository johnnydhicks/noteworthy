//
//  AddEditEntryViewController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit

class AddEditEntryViewController: UIViewController, PhotoSelectViewControllerDelegate {
    
    var image: UIImage?
    var movieURL: URL?
    
    
    func photoSelectViewControllerSelected(_ image: UIImage) {
        self.image = image
    }
    
    func photoSelectViewControllerSelectedMovie(movieURL: URL) {
        self.movieURL = movieURL
    }
    
    func saveButtonTapped() {
        // Check if there is an image or a movie, get the data from it, and save it.
        
        let photoData = UIImagePNGRepresentation(image!)
        let movieData = Data(contentsOf: movieURL!)
        
        EntryController.shared.createEntry(mediaData: <#T##Data#>, note: <#T##String#>, recordID: <#T##String#>, timestamp: <#T##Date#>)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.primaryAppBlue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
