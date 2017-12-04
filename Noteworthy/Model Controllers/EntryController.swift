//
//  EntryController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    // Shared Instance
    static let shared = EntryController()
    
    
    // Source of all truth
    var entries: [Entry] {
        
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        return (try? CoreDataStack.context.fetch(request)) ?? []
    }
    
    
    // CRUD Functions
    func createEntry(mediaData: Data, note: String, recordID: String, timestamp: Date) {
        
        Entry(mediaData: mediaData, note: note, recordID: recordID, timestamp: timestamp)
    }
    
    func delete(entry: Entry) {
        guard let moc = entry.managedObjectContext else { return }
        
        moc.delete(entry)
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
