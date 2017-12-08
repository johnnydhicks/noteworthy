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
    var delegate: ChallengeTableViewCellDelegate?
    
    var challenge: Challenge? {
        didSet{
            updateViews()
        }
    }
    
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        
        delegate?.buttonCellButtonTapped(self)
        updateButton(challenge!.isComplete)
    }
    
    func updateButton(_ isComplete: Bool) {
        let imageName = isComplete ? "completeChallenge" : "incompleteChallenge"
        completeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ChallengeTableViewCell {
    
    func updateViews(){
        guard let challenge = self.challenge else { return }
        challengeNameLabel.text = challenge.name
        
        updateButton(challenge.isComplete)
    }
}

protocol ChallengeTableViewCellDelegate {
    
    func buttonCellButtonTapped(_ sender: ChallengeTableViewCell)
    
}
