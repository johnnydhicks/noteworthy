//
//  ChallengeTableViewCell.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/8/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var completionDateLabel: UILabel!
    var delegate: ChallengeTableViewCellDelegate?
    let completedFeedback = UISelectionFeedbackGenerator()
    
    var challenge: Challenge? {
        didSet{
            updateViews()
        }
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.buttonCellButtonTapped(self)
        updateButton(challenge!.isComplete)
        
        guard let challenge = challenge,
            let date = challenge.date else { return }
        completionDateLabel.text = "Completed: \(dateFormatter.string(from: date))"
        completedFeedback.selectionChanged()
    }
    
    func updateButton(_ isComplete: Bool) {
        let imageName = isComplete ? "completeChallenge" : "incompleteChallenge"
        completeButton.setImage(UIImage(named: imageName), for: .normal)
        if isComplete == false {
            completionDateLabel.isHidden = true
        } else {
            completionDateLabel.isHidden = false
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Formats the data for each entry
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

}

extension ChallengeTableViewCell {
    
    func updateViews(){
        guard let challenge = self.challenge else { return }
        challengeNameLabel.text = challenge.name
        updateButton(challenge.isComplete)
        
        guard let date = challenge.date else { return }
        completionDateLabel.text = "Completed: \(dateFormatter.string(from: date))"
    }
}

protocol ChallengeTableViewCellDelegate {
    
    func buttonCellButtonTapped(_ sender: ChallengeTableViewCell)
    
}
