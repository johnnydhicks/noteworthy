//
//  EntryWithPhotoTableViewCell.swift
//  Noteworthy
//
//  Created by Johnny Hicks on 12/7/17.
//  Copyright © 2017 Johnny Hicks. All rights reserved.
//

import UIKit

class EntryWithPhotoTableViewCell: UITableViewCell {

    var entry: Entry? {
        didSet {
            self.updateCell()
            flipImage(image: photoImageView.image ?? UIImage())
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        entry = nil
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @discardableResult func flipImage(image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else {
            return image
        }
        let flippedImage = UIImage(cgImage: cgImage,
                                   scale: image.scale,
                                   orientation: .leftMirrored)
        return flippedImage
    }
    
    func updateCell() {
        guard let entry = entry else { return }
        
        dateLabel.text = dateFormatter.string(from: entry.timestamp as Date)
        noteLabel.text = entry.note
        if let imageData = entry.imageData {
            photoImageView.image = UIImage(data: imageData as Data)
            photoImageView.contentMode = UIViewContentMode.scaleAspectFill
            photoImageView.clipsToBounds = true
        }
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
