//
//  Entry+Convenience.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/4/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import Foundation
import CoreData


extension Entry {
    @discardableResult convenience init(mediaData: Data, note: String, recordID: String, timestamp: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.mediaData = mediaData
        self.note = note
        self.recordID = recordID
        self.timestamp = timestamp
    }
}
