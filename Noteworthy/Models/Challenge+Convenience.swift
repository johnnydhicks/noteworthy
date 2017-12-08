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
    
    @discardableResult convenience init(name: String, isComplete: Bool = false, challengeType: ChallengeType, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
        self.isComplete = isComplete
        self.challengeType = challengeType
    }
    
    
}
