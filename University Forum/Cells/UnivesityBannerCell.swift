//
//  UnivesityBannerCell.swift
//  University Forum
//
//  Created by Ian Talisic on 13/09/2021.
//
import TagListView
import UIKit

protocol UnivesityBannerCellDelegate {
    func didTapTopButtons(index: Int)
    func didTapInvite()
}

class UnivesityBannerCell: UITableViewCell, TagListViewDelegate {
  
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
    
    var delegate: UnivesityBannerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagListView.delegate = self
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
        self.delegate?.didTapInvite()
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        self.delegate?.didTapTopButtons(index: title.lowercased() == "all posts" ? 0 : 1)
    }
}

