//
//  PopoverCell.swift
//  University Forum
//
//  Created by Ian Talisic on 06/12/2021.
//

import UIKit

class PopoverCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    static let identifier: String = "PopoverCell"
    static let nib: UINib = UINib(nibName: "PopoverCell", bundle: nil)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
