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
    
    
    // Source of all truth
    var entriesOriginal: [Entry] {
        
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        return (try? CoreDataStack.context.fetch(request)) ?? []
    }
    
    var entries: [Entry] {
        return entriesOriginal.reversed()
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
    
    func update(entry: Entry, imageData: Data?, OldVideoURL: URL?, note: String) {
        
//        entry.note = note
//        entry.imageData = imageData as NSData
//        entry.videoURL = OldVideoURL
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
