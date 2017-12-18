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
                performFullSync()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            _ = Entry(imageData: imageData, videoURL: nil, note: note)
            performFullSync()
            saveToPersistentStore()
        }
    }
    
    func update(entry: Entry, imageData: Data?, oldVideoURL: URL?, note: String) {
        
        entry.note = note
        
        if let oldVideoURL = oldVideoURL {
            
            if let videoData = try? Data(contentsOf: oldVideoURL) {
                do {
                    let directoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let newVideoURL = directoryURL.appendingPathComponent(oldVideoURL.lastPathComponent)
                    try videoData.write(to: newVideoURL)
                    entry.videoURL = oldVideoURL.lastPathComponent
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            entry.imageData = nil
            
        } else if let imageData = imageData {
            entry.imageData = imageData as NSData
            entry.videoURL = nil
        }
        saveToPersistentStore()

        
        let entryRecord = CKRecord(entry)
        cloudKitManager.modifyRecords([entryRecord], perRecordCompletion: nil, completion: nil)
    }
    
    func delete(entry: Entry) {
        guard let moc = entry.managedObjectContext else { return }
        
        moc.delete(entry)
        guard let recordID = entry.cloudKitRecordID else { return }
        saveToPersistentStore()
        
        cloudKitManager.deleteRecordWithID(recordID) { (success, error) in
            
        }
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
    
    
    // Helper Fetches
    private func recordsOf(type: String) -> [CloudKitSyncable] {
        switch type {
        case "Entry":
            return entries.flatMap { $0 as CloudKitSyncable }
        default:
            return []
        }
    }
    
    func syncedRecordsOf(type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { $0.isSynced }
    }
    
    func unsyncedRecordsOf(type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { !$0.isSynced }
    }
    
    
    
    let cloudKitManager = CloudKitManager()
    
    // MARK - Sync
    func performFullSync(completion: @escaping (() -> Void) = {  }) {
        
        pushChangesToCloudKit { (success, error) in
            
            self.fetchNewRecordsOf(type: Entry.typeKey) {
                self.saveToPersistentStore()
                completion()
            }
        
        }
        
       
    }
    
    func fetchAllEntries(completion: @escaping () -> Void) {
        
        cloudKitManager.fetchRecordsWithType("Entry") { (records, error) in
            guard let records = records else { return }
            
            DispatchQueue.main.async {
                _ = records.flatMap({Entry(record: $0)})
                self.saveToPersistentStore()
                completion()
            }
        }
        
    }

    func saveAllEntriesToCloudKit() {
        
        var entryRecords: [CKRecord] = []
        
        for entry in entries {
            let entryRecord = CKRecord(entry)
            entryRecords.append(entryRecord)
        }
        
        cloudKitManager.modifyRecords(entryRecords, perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func fetchNewRecordsOf(type: String, completion: @escaping (() -> Void) = {  }) {
        
        var referencesToExclude = [CKReference]()
        var predicate: NSPredicate!
        referencesToExclude = self.syncedRecordsOf(type: type).flatMap { $0.cloudKitReference }
        predicate = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: [referencesToExclude])
        
        if referencesToExclude.isEmpty {
            predicate = NSPredicate(value: true)
        }
        
        let sortDescriptors: [NSSortDescriptor]?
        switch type {
        case Entry.typeKey:
            let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
            sortDescriptors = [sortDescriptor]
        default:
            sortDescriptors = nil
        }
        
        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, sortDescriptors: sortDescriptors) { (records, error) in
            
            defer { completion() }
            if let error = error {
                NSLog("Error fetching CloudKit records of type \(type): \(error)")
                return
            }
            guard let records = records else { return }
            
            switch type {
            case Entry.typeKey:
                
                
                let _ = records.flatMap { Entry(record: $0) }

            default:
                return
            }
        }
    }
    
    
    func pushChangesToCloudKit(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
        
        let unsavedPosts = unsyncedRecordsOf(type: Entry.typeKey) as? [Entry] ?? []
        var unsavedObjectsByRecord = [CKRecord: CloudKitSyncable]()
        for entry in unsavedPosts {
            let record = CKRecord(entry)
            unsavedObjectsByRecord[record] = entry
        }
        
        let unsavedRecords = Array(unsavedObjectsByRecord.keys)
        
        cloudKitManager.saveRecords(unsavedRecords, perRecordCompletion: { (record, error) in
            
            guard let record = record else { return }
            
            // Change this if you ever implement saving another class to CloudKit or it won't work.
            guard let entry = unsavedObjectsByRecord[record] as? Entry else { return }
                entry.recordID = record.recordID.recordName
            
        }) { (records, error) in
            
            let success = records != nil
            self.saveToPersistentStore()
            completion(success, error)
        }
    }
}
