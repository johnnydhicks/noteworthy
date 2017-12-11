//
//  ChallengesTableViewController.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/8/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit

class ChallengesTableViewController: UITableViewController, ChallengeTableViewCellDelegate {
    
    
    func buttonCellButtonTapped(_ sender: ChallengeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender),
        let challenge = challengeType?.challenges?.object(at: indexPath.row) as? Challenge else { return }
        
        ChallengeController.shared.toggleIsCompleteFor(challenge: challenge)
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    var challengeType: ChallengeType?
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return challengeType?.challenges?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as? ChallengeTableViewCell else { return UITableViewCell() }

        guard let challenge = challengeType?.challenges?.object(at: indexPath.row) as? Challenge else { return UITableViewCell() }
        cell.delegate = self
        cell.selectionStyle = .none
        cell.challenge = challenge
        return cell
    }
}
