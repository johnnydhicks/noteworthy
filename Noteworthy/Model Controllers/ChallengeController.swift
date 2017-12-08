//
//  ChallengeController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/8/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import Foundation
import CoreData

class ChallengeController: NSObject, NSFetchedResultsControllerDelegate {
    
    static let shared = ChallengeController()
    
    var fetchedResultsController: NSFetchedResultsController<Challenge>!
    
    func setupChallengeTypesAndChallenges() {
        let outdoor = ChallengeType(name: "Outdoor")
        let fitness = ChallengeType(name: "Fitness")
        let travel = ChallengeType(name: "Travel")
        let survival = ChallengeType(name: "Survival")
        let food = ChallengeType(name: "Food")
        let service = ChallengeType(name: "Service")
        
        
        Challenge(name: "Cross a slackline", challengeType: outdoor)
        Challenge(name: "Carve somethings out of wood", challengeType: survival)
        Challenge(name: "Eat the first thing on the menu at a local Mexican Restaurant", challengeType: food)
        Challenge(name: "Run a half or full marathon", challengeType: fitness)
        Challenge(name: "Volunteer at your local soup kitchen", challengeType: service)
        Challenge(name: "Take a road-trip to another state", challengeType: travel)
        
        
        saveToPersistentStorage()
        
        UserDefaults.standard.set(true, forKey: "challengesHaveBeenSetUp")
    }
    
    
    var challengeTypes: [ChallengeType] {
        
        let fetchrequest: NSFetchRequest<ChallengeType> = ChallengeType.fetchRequest()
        
        do {
            return try CoreDataStack.context.fetch(fetchrequest)
        } catch {
            print("Error running fetch request: \(error)")
            return []
        }
    }
    
    func toggleIsCompleteFor(challenge: Challenge) {
        challenge.isComplete = !challenge.isComplete
        saveToPersistentStorage()
    }
    
    
    func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
}


extension ChallengeController {

    
}
