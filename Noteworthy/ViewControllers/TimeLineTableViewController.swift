//
//  TimeLineTableViewController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class TimeLineTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let context = CoreDataStack.context
        let fetchRequest : NSFetchRequest<Entry> = Entry.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 400.0
        
        let sess = AVAudioSession.sharedInstance()
        if sess.isOtherAudioPlaying {
            _ = try? sess.setCategory(AVAudioSessionCategoryAmbient, with: .duckOthers)
            _ = try? sess.setActive(true, with: [])
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            NSLog("Error performing fetch on NSFetchedResultsController: \(error)")
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections, sections.count > section else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EntryTableViewCell else { return }
        cell.avPlayer?.pause()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? EntryTableViewCell else { return }
        cell.avPlayer?.play()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let entries = fetchedResultsController.fetchedObjects else { return EntryTableViewCell() }
        let entry = entries[indexPath.row]
        
        if entry.imageData != nil {
            
            // Set up photo cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryPhotoCell", for: indexPath) as? EntryWithPhotoTableViewCell else { return UITableViewCell() }
            cell.entry = entry
            return cell
            
        } else if entry.videoURL != nil {
            
            // Set up video cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
            cell.entry = entry
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entry = fetchedResultsController.object(at: indexPath)
            EntryController.shared.delete(entry: entry)
            
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditEntry" || segue.identifier == "toAddEditEntry" {
            if let detailVC = segue.destination as? AddEditEntryViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                let entry = EntryController.shared.entries[selectedRow]
                detailVC.entry = entry
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


