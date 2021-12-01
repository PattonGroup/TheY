//
//  TaskCell.swift
//  University Forum
//
//  Created by Ian Talisic on 01/12/2021.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblTask: UILabel!
    
    static let identifier: String = "TaskCell"
    static let nib: UINib = UINib(nibName: "TaskCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        
        lblTask.textColor = .white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
