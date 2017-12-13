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
    
    // Pulling entries from Core Data
    @discardableResult convenience init(imageData: Data?, videoURL: URL?, note: String, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.imageData = imageData as NSData?
        self.videoURL = videoURL?.absoluteString
        self.note = note
        self.timestamp = timestamp as NSDate
    }
    
    
    // MARK: CloudKitSyncable
    
    convenience init?(record: CKRecord) {
        
        guard let timestamp = record.creationDate,
            let note = record[Entry.noteKey] as? String else { return nil }
        
        
        var imageData: Data?
        
        if let photoAsset = record[Entry.imageDataKey] as? CKAsset {
            
            imageData = try? Data(contentsOf: photoAsset.fileURL)
        }
        
        var videoURL: URL? = nil
        
        if let videoAsset = record[Entry.videoURLKey] as? CKAsset {
            do {
                guard let videoData = try? Data(contentsOf: videoAsset.fileURL) else { return nil }
                let directoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let newVideoURL = directoryURL.appendingPathComponent("\(UUID().uuidString).mov")
                try videoData.write(to: newVideoURL)
                
                videoURL = URL(string: newVideoURL.lastPathComponent)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        self.init(imageData: imageData, videoURL: videoURL, note: note, timestamp: timestamp, context: CoreDataStack.context)
        self.cloudKitRecordID = record.recordID
    }
    
    fileprivate var temporaryPhotoURL: URL {
        
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? imageData?.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
    
    
    var recordType: String { return Entry.typeKey }
    var cloudKitRecordID: CKRecordID?
}



extension CKRecord {
    convenience init(_ entry: Entry) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: Entry.typeKey, recordID: recordID)
        
        self[Entry.timestampKey] = entry.timestamp as CKRecordValue?
        self[Entry.noteKey] = entry.note as CKRecordValue?
        
        if entry.imageData != nil {
            self[Entry.imageDataKey] = CKAsset(fileURL: entry.temporaryPhotoURL)
        }
        
        guard let url = entry.videoURL?.createVideoURL() else { return }
        self[Entry.videoURLKey] = CKAsset(fileURL: url)
    }
}

