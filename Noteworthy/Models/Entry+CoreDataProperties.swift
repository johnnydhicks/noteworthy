//
//  Entry+CoreDataProperties.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/5/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var timestamp: NSDate
    @NSManaged public var recordID: String?
    @NSManaged public var note: String
    @NSManaged public var imageData: NSData?
    @NSManaged public var videoURL: String?

}
