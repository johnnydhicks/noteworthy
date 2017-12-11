//
//  EntryController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class EntryController {
    
    // Shared Instance
    static let shared = EntryController()
    
    var fetchedResultsController: NSFetchedResultsController<Entry>!

    var entries: [Entry] {
        
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let results = (try? CoreDataStack.context.fetch(request)) ?? []
        
        return results.sorted(by: { $0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970 })
    }
    
    // CRUD Functions
    func createEntry(imageData: Data?, oldVideoURL: URL?, note: String) {
        
        if let oldVideoURL = oldVideoURL {
            
            guard let videoData = try? Data(contentsOf: oldVideoURL) else { return }
            
            do {
                
                let directoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let newVideoURL = directoryURL.appendingPathComponent(oldVideoURL.lastPathComponent)
                try videoData.write(to: newVideoURL)
                
                _ = Entry(imageData: imageData, videoURL: URL(string:oldVideoURL.lastPathComponent), note: note)
                saveToPersistentStore()

            } catch {
                print(error.localizedDescription)
            }
            
            
        } else {
            _ = Entry(imageData: imageData, videoURL: nil, note: note)
            saveToPersistentStore()

        }
        
        
    }
    
    func update(entry: Entry, imageData: Data?, oldVideoURL: URL?, note: String) {
        
        entry.note = note
        
        if let oldVideoURL = oldVideoURL {
            
            guard let videoData = try? Data(contentsOf: oldVideoURL) else { return  }
            // When the video isn't updated, the update function never hits the do-try-catch function, and thus never updates the note
            do {
                
                let directoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let newVideoURL = directoryURL.appendingPathComponent(oldVideoURL.lastPathComponent)
                try videoData.write(to: newVideoURL)
                
                
                
                entry.videoURL = oldVideoURL.lastPathComponent

                
//                _ = Entry(imageData: imageData, videoURL: URL(string:oldVideoURL.lastPathComponent), note: note)
                
            } catch {
                print(error.localizedDescription)
            }
            
            entry.imageData = nil
        } else if let imageData = imageData {
            entry.imageData = imageData as NSData
            entry.videoURL = nil
        }
    
        saveToPersistentStore()
    }
    
    func delete(entry: Entry) {
        guard let moc = entry.managedObjectContext else { return }
        
        moc.delete(entry)
        
        saveToPersistentStore()
    }
    
    
    // Save Entries
    func saveToPersistentStore() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch let error {
            print("There was a problem saving to persistent store: \(error)")
        }
    }
}
