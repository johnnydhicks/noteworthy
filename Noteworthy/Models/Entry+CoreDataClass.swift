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
    static let mediaDataKey = "mediaData"
    static let timestampKey = "timestamp"
    static let noteKey = "note"
    
    
    // Initialize data from iCloud
    convenience init?(record: CKRecord, context: NSManagedObjectContext = CoreDataStack.context) {
        
        guard let timestamp = record[Entry.timestampKey] as? Date,
            let note = record[Entry.noteKey] as? String,
            let mediaData = record[Entry.mediaDataKey] as? Data else { return nil }
        
        self.init(context: context)
        self.timestamp = timestamp as NSDate?
        self.note = note
        self.mediaData = mediaData as NSData?
        self.recordID = record.recordID.recordName
    }
    
    
    // Properties
    var cloudKitRecordID: CKRecordID?

    
    // Pulling entries from Core Data
    @discardableResult convenience init(mediaData: Data, note: String, recordID: String, timestamp: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.mediaData = mediaData as NSData
        self.note = note
        self.recordID = recordID
        self.timestamp = timestamp as NSDate
    }
}


extension CKRecord {
    convenience init(_ entry: Entry) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: Entry.typeKey, recordID: recordID)
    }
}

