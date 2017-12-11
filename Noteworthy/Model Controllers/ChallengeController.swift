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
        challenge.date = Date()
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

    func setupChallengeTypesAndChallenges() {
        let outdoor = ChallengeType(name: "Outdoor")
        let fitness = ChallengeType(name: "Fitness")
        let travel = ChallengeType(name: "Travel")
        let survival = ChallengeType(name: "Survival")
        let food = ChallengeType(name: "Food")
        let service = ChallengeType(name: "Service")
        
        // Outdoor
        Challenge(name: "Cross a slackline 2x", challengeType: outdoor)
        Challenge(name: "Ride a mountain bike on a dirt trail", challengeType: outdoor)
        Challenge(name: "Ride a road bike down a highway", challengeType: outdoor)
        Challenge(name: "Get up on a wakeboard/water skis", challengeType: outdoor)
        Challenge(name: "Go longboarding", challengeType: outdoor)
        Challenge(name: "Find a geocache", challengeType: outdoor)
        Challenge(name: "Do some bouldering", challengeType: outdoor)
        Challenge(name: "Stand under a waterfall", challengeType: outdoor)
        Challenge(name: "Take a dip in the Pacific Ocean", challengeType: outdoor)
        Challenge(name: "Trail Run for 1 Mile", challengeType: outdoor)
        Challenge(name: "Jump into a body of water with your clothes on", challengeType: outdoor)
        Challenge(name: "Kayak, canoe, paddleboard, tube, or row across a body of water", challengeType: outdoor)
        Challenge(name: "Swing on a rope swing", challengeType: outdoor)
        Challenge(name: "Go bungee jumping", challengeType: outdoor)
        Challenge(name: "Find a natural hot spring and take a dip", challengeType: outdoor)
        Challenge(name: "Cross a state line", challengeType: outdoor)
        Challenge(name: "Jump off of a high dive or platform into a pool of water", challengeType: outdoor)
        Challenge(name: "Walk on a boardwalk", challengeType: outdoor)
        Challenge(name: "Go fishing", challengeType: outdoor)
        Challenge(name: "Fly a kite", challengeType: outdoor)
        Challenge(name: "Go rollerblading or ride a scooter", challengeType: outdoor)
        Challenge(name: "Learn to do a flip on a trampoline", challengeType: outdoor)
        Challenge(name: "Go scubadiving or snorkeling", challengeType: outdoor)
        Challenge(name: "Go paddleboarding", challengeType: outdoor)
        Challenge(name: "Learn to dive", challengeType: outdoor)
        Challenge(name: "Plant a garden", challengeType: outdoor)
        Challenge(name: "Go horseback riding", challengeType: outdoor)
        Challenge(name: "Visit an amusement park", challengeType: outdoor)
        Challenge(name: "Go on a picnic", challengeType: outdoor)
        Challenge(name: "Stargaze", challengeType: outdoor)
        Challenge(name: "Get creative with sidewalk chalk", challengeType: outdoor)
        Challenge(name: "Take in a sunset or sunrise", challengeType: outdoor)
        Challenge(name: "Have a waterballoon fight", challengeType: outdoor)
        Challenge(name: "Rent a metal detector and search for treasure", challengeType: outdoor)
        Challenge(name: "Go rock climbing", challengeType: outdoor)
        Challenge(name: "Go skiing or snowboarding", challengeType: outdoor)
        Challenge(name: "Go snowshoeing", challengeType: outdoor)
        Challenge(name: "Go repelling", challengeType: outdoor)
        Challenge(name: "Go out on a wildlife safari", challengeType: outdoor)
        Challenge(name: "Go Birdwatching", challengeType: outdoor)
        Challenge(name: "Climb a tree", challengeType: outdoor)
        Challenge(name: "Go on a orienteering adventure", challengeType: outdoor)
        Challenge(name: "Play a game of paintball", challengeType: outdoor)
        Challenge(name: "Go hunting/shooting", challengeType: outdoor)
        Challenge(name: "Go ATV Riding", challengeType: outdoor)
        Challenge(name: "Go Clam digging", challengeType: outdoor)
        Challenge(name: "Go Surfing", challengeType: outdoor)
        Challenge(name: "Build a sandcastle", challengeType: outdoor)
        Challenge(name: "Hit the river and go whitewater rafting", challengeType: outdoor)
        Challenge(name: "Go Jetskiing", challengeType: outdoor)
        Challenge(name: "Go skydiving", challengeType: outdoor)
        Challenge(name: "Ride a camel", challengeType: outdoor)
        Challenge(name: "Go on a Desert Jeep Safari", challengeType: outdoor)
        Challenge(name: "Go Sandboarding", challengeType: outdoor)
        Challenge(name: "Do a corn maze", challengeType: outdoor)
        
        
        // Survival
        Challenge(name: "Carve somethings out of wood", challengeType: survival)
        
        // Food
        Challenge(name: "Eat the first thing on the menu at a local Mexican Restaurant", challengeType: food)
        
        
        // Fitness
        Challenge(name: "Run a half or full marathon", challengeType: fitness)
        Challenge(name: "Run a half or full marathon 2x", challengeType: fitness)
        
        // Service
        Challenge(name: "Volunteer at your local soup kitchen", challengeType: service)
        Challenge(name: "Volunteer at your local soup kitchen 2x", challengeType: service)
        
        
        // Travel
        Challenge(name: "Take a road-trip to another state", challengeType: travel)
        
        
        saveToPersistentStorage()
        
        UserDefaults.standard.set(true, forKey: "challengesHaveBeenSetUp")
    }
    
}
