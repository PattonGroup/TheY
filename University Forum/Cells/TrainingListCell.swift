//
//  TrainingListCell.swift
//  University Forum
//
//  Created by Ian Talisic on 29/11/2021.
//

import UIKit

class TrainingListCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
    static let identifier: String = "TrainingListCell"
    static let nib: UINib = UINib(nibName: "TrainingListCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        imgIcon.image = imgIcon.image?.withRenderingMode(.alwaysTemplate)
        imgIcon.tintColor = .white
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
