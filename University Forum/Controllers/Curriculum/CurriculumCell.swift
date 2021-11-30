//
//  CurriculumCell.swift
//  University Forum
//
//  Created by Ian Talisic on 30/11/2021.
//

import UIKit

class CurriculumCell: UITableViewCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let identifier: String = "CurriculumCell"
    static let nib: UINib = UINib(nibName: "CurriculumCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
