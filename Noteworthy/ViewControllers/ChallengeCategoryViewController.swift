//
//  ChallengeCategoryViewController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/7/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit

class ChallengeCategoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toOutdoorChallenges" {
    
            guard let challengeType = ChallengeController.shared.challengeTypes.filter({$0.name == "Outdoor"}).first,
                let challengeVC = segue.destination as? ChallengesTableViewController else { return }
            
            challengeVC.challengeType = challengeType
            
        } else if segue.identifier == "toFitnessChallenges" {
            
            guard let challengeType = ChallengeController.shared.challengeTypes.filter({$0.name == "Fitness"}).first,
                let challengeVC = segue.destination as? ChallengesTableViewController else { return }
            
            challengeVC.challengeType = challengeType
            
        } else if segue.identifier == "toTravelChallenges" {
            
            guard let challengeType = ChallengeController.shared.challengeTypes.filter({$0.name == "Travel"}).first,
                let challengeVC = segue.destination as? ChallengesTableViewController else { return }
            
            challengeVC.challengeType = challengeType
            
        } else if segue.identifier == "toSurvivalChallenges" {
            
            guard let challengeType = ChallengeController.shared.challengeTypes.filter({$0.name == "Survival"}).first,
                let challengeVC = segue.destination as? ChallengesTableViewController else { return }
            
            challengeVC.challengeType = challengeType
            
        } else if segue.identifier == "toFoodChallenges" {
            
            guard let challengeType = ChallengeController.shared.challengeTypes.filter({$0.name == "Food"}).first,
                let challengeVC = segue.destination as? ChallengesTableViewController else { return }
            
            challengeVC.challengeType = challengeType
            
        } else if segue.identifier == "toServiceChallenges" {
            
            guard let challengeType = ChallengeController.shared.challengeTypes.filter({$0.name == "Service"}).first,
                let challengeVC = segue.destination as? ChallengesTableViewController else { return }
            
            challengeVC.challengeType = challengeType
            
        }
    }
}
