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
    
    func addToBucketlist(itemName name: String) {
        
        guard let challengeType = challengeTypes.filter( { $0.name == "BucketList" }).first else { return }
        _ = Challenge(name: name, challengeType: challengeType, context: CoreDataStack.context)
        
        saveToPersistentStorage()
    }
    
    func updateBucketlist(challenge: Challenge, name: String) {
        challenge.name = name
        
        saveToPersistentStorage()
    }
    
    func removeFromBucketlist(challenge: Challenge) {
        challenge.managedObjectContext?.delete(challenge)
        
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
    
    func setupBucketList() {
        let _ = ChallengeType(name: "BucketList")
        
        saveToPersistentStorage()
        UserDefaults.standard.set(true, forKey: "bucketlistHasBeenSetUp")
    }
    
    func fixTypos(challengeTypeName: String, challengeName: String, fixedChallengeName: String) {
        if let challengetype = ChallengeController.shared.challengeTypes.filter({ $0.name == challengeTypeName}).first {
            if let challenge = challengetype.challenges?.filter({ ($0 as? Challenge)?.name == challengeName }).first as? Challenge {
                challenge.name = fixedChallengeName
                saveToPersistentStorage()
            }
        }
    }

    func setupChallengeTypesAndChallenges() {
        let outdoor = ChallengeType(name: "Outdoor")
        let fitness = ChallengeType(name: "Fitness")
        let travel = ChallengeType(name: "Travel")
        let survival = ChallengeType(name: "Survival")
        let _ = ChallengeType(name: "BucketList")
        let service = ChallengeType(name: "Service")
        
        
        // Outdoor
        Challenge(name: "Cross a slackline", challengeType: outdoor)
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
        Challenge(name: "Eat a meal gathered from plants and insects gathered in the wild", challengeType: survival)
        Challenge(name: "Catch a fish with your bare hands", challengeType: survival)
        Challenge(name: "Start a fire without matches or starter fluid", challengeType: survival)
        Challenge(name: "Filter water from a natural source and drink it", challengeType: survival)
        Challenge(name: "Camp under the stars without a tent", challengeType: survival)
        Challenge(name: "Sleep in a hammock", challengeType: survival)
        Challenge(name: "Make s'mores", challengeType: survival)
        Challenge(name: "Make a tinfoil dinner", challengeType: survival)
        Challenge(name: "Take pictures of a wild mammal", challengeType: survival)
        Challenge(name: "Skip a rock at least 7 times", challengeType: survival)
        Challenge(name: "Carve somethings out of wood", challengeType: survival)
        Challenge(name: "Go tree tipping", challengeType: survival)
        Challenge(name: "Cut your own wood for a campfire", challengeType: survival)
        
        
        
        // Fitness
        Challenge(name: "Run a half or full marathon", challengeType: fitness)
        Challenge(name: "Run a mile faster than your previous personal record", challengeType: fitness)
        Challenge(name: "Make yourself a healthy meal using a recipe you've never used before", challengeType: fitness)
        Challenge(name: "Attend a class at a gym/fitness studio that you've never attended", challengeType: fitness)
        Challenge(name: "Complete a 50-mile bike ride", challengeType: fitness)
        Challenge(name: "Walk 10,000+ steps every day for a week", challengeType: fitness)
        Challenge(name: "Do 100 push-ups without taking a break", challengeType: fitness)
        Challenge(name: "Go to the local track and do the high jump", challengeType: fitness)
        Challenge(name: "Make a field goal from 20+ yards away", challengeType: fitness)
        Challenge(name: "Make a full court shot with a basketball", challengeType: fitness)
        Challenge(name: "Hit a bullseye with a bow and arrow at an archery range", challengeType: fitness)
        Challenge(name: "Swim a mile", challengeType: fitness)
        Challenge(name: "Bowl a score over 170", challengeType: fitness)
        Challenge(name: "Participate in Ragnar", challengeType: fitness)
        Challenge(name: "Run a 5K/10K that is for a good cause", challengeType: fitness)
        
        
        
        
        
        // Service
        Challenge(name: "Schedule a time at the local homeless shelter to serve food (not on a holiday)", challengeType: service)
        Challenge(name: "Watch your neighbor's/sibling's kids for free while they go on a date with their spouse or themself", challengeType: service)
        Challenge(name: "Adopt a highway", challengeType: service)
        Challenge(name: "Pay for somebody in line behind you", challengeType: service)
        Challenge(name: "Donate money to a charity", challengeType: service)
        Challenge(name: "Clean our your closet and take your unneeded clothes to the local charity", challengeType: service)
        Challenge(name: "Make treats for your neighbors and deliver them ", challengeType: service)
        Challenge(name: "Compliment (sincerely) ten people today", challengeType: service)
        Challenge(name: "Send a loved one an email or text telling them why you love and appreciate them", challengeType: service)
        Challenge(name: "Buy some prepackaged food, then drive around town, handing it out to homeless people you pass", challengeType: service)
        Challenge(name: "Help an older neighbor or friend with yardwork or housework", challengeType: service)
        Challenge(name: "Walk down mainstreet, and pick up all of the trash that you see along the way", challengeType: service)
        Challenge(name: "Call a friend who you haven't seen in a long time and set up a time to catch up", challengeType: service)

        
        
        // Travel
        Challenge(name: "Book a flight and travel to a country you've always wanted to go to", challengeType: travel)
        Challenge(name: "Visit a country whose primary language is different than your own", challengeType: travel)
        Challenge(name: "Visit ancients ruins", challengeType: travel)
        Challenge(name: "Travel to a state you've never been to", challengeType: travel)
        Challenge(name: "Visit a Destination Where 90% of the Wildlife and Plants are Unique", challengeType: travel)
        Challenge(name: "Go backpacking in another country", challengeType: travel)
        Challenge(name: "Create a photobook documenting your last trip", challengeType: travel)
        Challenge(name: "Go to a museum containing famous art", challengeType: travel)
        Challenge(name: "Go on a cruise", challengeType: travel)
        Challenge(name: "Go on a trip traveling by train", challengeType: travel)
        Challenge(name: "Travel to a national park", challengeType: travel)
        Challenge(name: "Make a list of everywhere you’ve been, then a list of everywhere you want to go next, and make a timeline for yourself", challengeType: travel)
        
        
        saveToPersistentStorage()
        
        UserDefaults.standard.set(true, forKey: "challengesHaveBeenSetUp")
    }
    
}
