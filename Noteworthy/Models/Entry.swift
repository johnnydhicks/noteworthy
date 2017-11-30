//
//  Entry.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 11/30/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    
    var video: CKAsset
    var note: String
    let timestamp: Date
    
    init(video: CKAsset, note: String, timestamp: Date) {
        self.video = video
        self.note = note
        self.timestamp = timestamp
    }
    
    
    
    
}
