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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toOutdoorChallenges" {
            // Get the right challengeType
            
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
