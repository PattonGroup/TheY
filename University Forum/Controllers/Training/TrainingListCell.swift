//
//  TrainingListCell.swift
//  University Forum
//
//  Created by Ian Talisic on 29/11/2021.
//

import UIKit

protocol TrainingListCellDelegate {
    func didTapRegister(urlString: String)
}

class TrainingListCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    static let identifier: String = "TrainingListCell"
    static let nib: UINib = UINib(nibName: "TrainingListCell", bundle: nil)
    
    var delegate: TrainingListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        
        btnRegister.layer.cornerRadius = 6
        btnRegister.layer.borderWidth = 2
        btnRegister.layer.borderColor = UIColor.white.cgColor
        btnRegister.layer.masksToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapRegisterNow(_ sender: UIButton) {
        delegate?.didTapRegister(urlString: sender.accessibilityLabel!)
    }
}
