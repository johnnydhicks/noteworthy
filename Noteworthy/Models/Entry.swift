//
//  Entry.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 11/30/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//
/*
import Foundation
import UIKit
import CloudKit

class Entry {
    
    // Keys
    static let typeKey = "Entry"
    static let photoDataKey = "photoData"
    static let timestampKey = "timestamp"
    static let noteKey = "note"
    static let identifierKey = "identifier"
    
    
    // Properties
    var recordType: String { return Entry.typeKey }
    let mediaData: Data?
    var photo: UIImage? {
        guard let mediaData = self.mediaData else { return nil }
        return UIImage(data: mediaData)
    }
    var note: String
    let timestamp: Date
    let recordID: CKRecordID
    
    
    // Memberwise Intializer
    init(mediaData: Data?, note: String, timestamp: Date = Date(), recordID: CKRecordID = CKRecordID(recordName: "Entry")) {
        
        self.photoData = photoData
        self.note = note
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    // Failable Initializer- Fetching records from iCloud
    init?(record: CKRecord) {
        guard let timestamp = record[Entry.timestampKey] as? Date,
            let note = record[Entry.noteKey] as? String,
            let recordID = record[Entry.identifierKey],
            let photoAsset = record[Entry.photoDataKey] as? CKAsset else { return nil }
        
        let photoData = try?
    }
    
    
}

extension CKRecord {
    convenience init(_ entry: Entry) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: entry.recordType, recordID: recordID)
    }
}

// Equatable Protocol: Used for deleting entries
func ==(lhs: Entry, rhs: Entry) -> Bool {
    if lhs.timestamp != rhs.timestamp { return false }
    if lhs.note != rhs.note { return false }
    if lhs.identifier != rhs.identifier { return false }
    
    return true
}
*/
