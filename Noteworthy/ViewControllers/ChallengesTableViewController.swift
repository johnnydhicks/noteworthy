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
        navigationItem.title = challengeType?.name
        
        navigationItem.rightBarButtonItem?.isEnabled = true
    
    }
    
    @IBAction func addChallengeButtonTapped(_ sender: Any) {
        setUpChallengeAlertController()
    }
    
    func setUpChallengeAlertController() {
        var challengeTextField: UITextField!
        
        
        let alertController = UIAlertController(title: "Add item to your Bucketlist", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            challengeTextField = textField
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let name = challengeTextField.text else { return }
            
            ChallengeController.shared.addToBucketlist(itemName: name)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    
    
    
    
    var challengeType: ChallengeType?
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeType?.challenges?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if challengeType?.name == "BucketList" {
                return .delete
        } else {
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let challenge = challengeType?.challenges?.object(at: indexPath.row) as? Challenge else { return }
            
            ChallengeController.shared.removeFromBucketlist(challenge: challenge)
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
