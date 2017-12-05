//
//  Entry+CoreDataClass.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Entry)
public class Entry: NSManagedObject, CloudKitSyncable {
    
    // Keys
    static let typeKey = "Entry"
    static let imageDataKey = "imageData"
    static let timestampKey = "timestamp"
    static let noteKey = "note"
    static let videoURLKey = "videoURL"
    
    
    // Initialize data from iCloud
    convenience init?(record: CKRecord, context: NSManagedObjectContext = CoreDataStack.context) {
        
        guard let timestamp = record[Entry.timestampKey] as? Date,
            let note = record[Entry.noteKey] as? String  else { return nil }
        
            let imageData = record[Entry.imageDataKey] as? Data
            let videoURL = record[Entry.videoURLKey] as? String
        
        self.init(context: context)
        self.timestamp = timestamp as NSDate
        self.note = note
        self.imageData = imageData as NSData?
        self.recordID = record.recordID.recordName
        self.videoURL = videoURL
    }
    
    
    // Properties
    var cloudKitRecordID: CKRecordID?

    
    // Pulling entries from Core Data
    @discardableResult convenience init(imageData: Data?, videoURL: URL?, note: String, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.imageData = imageData as NSData?
        self.videoURL = videoURL?.absoluteString
        self.note = note
        self.timestamp = timestamp as NSDate
    }
}


extension CKRecord {
    convenience init(_ entry: Entry) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: Entry.typeKey, recordID: recordID)
    }
}

