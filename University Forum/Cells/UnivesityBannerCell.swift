//
//  UnivesityBannerCell.swift
//  University Forum
//
//  Created by Ian Talisic on 13/09/2021.
//
import TagListView
import UIKit

class UnivesityBannerCell: UITableViewCell {
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblUniversityName: UILabel!
    @IBOutlet weak var lblOfficialGroup: UILabel!
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var btnJoined: CustomButton!
    @IBOutlet weak var btnInvite: CustomButton!
    @IBOutlet weak var tagListView: TagListView!
    

    
    let dataSource: [String] = ["All Posts", "Announcements"]
    static let identifier = "UnivesityBannerCell"
    static let nib = UINib(nibName: "UnivesityBannerCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagListView.textFont = UIFont(name: "Helvetica-Bold", size: 15)!
        tagListView.removeAllTags()
        tagListView.addTags(dataSource)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func didTapButton(_ sender: CustomButton) {
    }
}
