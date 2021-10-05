//
//  PostTableViewCell.swift
//  University Forum
//
//  Created by Ian Talisic on 14/09/2021.
//

import UIKit

protocol PostTableViewCellDelegate {
    func initiateWritePost()
    func initiatePhotoPost()
    func initiatePollPost()
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var lblWriteSomething: UILabel!
    static let identifier = "PostTableViewCell"
    static let nib = UINib(nibName: "PostTableViewCell", bundle: nil)

    
    var delegate: PostTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        lblWriteSomething.isUserInteractionEnabled = true
        lblWriteSomething.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapWriteSomething)))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapPhoto(_ sender: UIButton) {
        if sender.tag == 0 {
            self.delegate?.initiatePhotoPost()
        }else{
            self.delegate?.initiatePollPost()
        }
    }
    
    @objc func didTapWriteSomething(){
        self.delegate?.initiateWritePost()
    }
}
