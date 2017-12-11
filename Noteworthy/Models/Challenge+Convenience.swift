//
//  Challenge+Convenience.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/8/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import Foundation
import CoreData

extension Challenge {
    
    @discardableResult convenience init(name: String, isComplete: Bool = false, date: Date? = nil, challengeType: ChallengeType, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.date = date
        self.name = name
        self.isComplete = isComplete
        self.challengeType = challengeType
    }
    
    
}
