//
//  UniversityViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 06/09/2021.
//

import UIKit
import AVKit
import AVFoundation
import MBProgressHUD
import FTPopOverMenu_Swift
import Kingfisher

class UniversityViewController: UIViewController {
    @IBOutlet weak var createPostImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.sectionFooterHeight = 0
            tableView.sectionHeaderHeight = 0
            tableView.register(UnivesityBannerCell.nib, forCellReuseIdentifier: UnivesityBannerCell.identifier)
            tableView.register(PostTableViewCell.nib, forCellReuseIdentifier: PostTableViewCell.identifier)
            tableView.register(FeedsCell.nib, forCellReuseIdentifier: FeedsCell.identifier)
        }
    }
    var university: UniversityResponseModel?
    var announcementsDatasource: [AnnouncementModel] = []
    var feedsDatasource: [PostResponseModel] = []
    var cellCache: [UITableViewCell?] = []
    var playerItemContext: Int = 0
    var isAnnouncements: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPosts()
    }
    
    private func setup(){
        self.title = SharedFunc.getString(university?.name)
        tableView.sectionHeaderHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        
        createPostImageView.makePerfectRounded()
        
    }
    
    private func getPosts(){
        cellCache.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        PostsAPI.shared.getPostFromUniversity(id: SharedFunc.getString(university?.id)) { [self] post in
            MBProgressHUD.hide(for: self.view, animated: true)
            feedsDatasource = post
            SharedFunc.initializeObserver(isAdd: false, vc: self, cellCache: cellCache)
            tableView.reloadData()
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        SharedFunc.initializeObserver(isAdd: false, vc: self, cellCache: cellCache)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapLogout(_ sender: Any) {
        SharedFunc.logout(self)
    }
    
    @IBAction func didTapCreatePost(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(identifier: "PostViewController") as! PostViewController
        vc.universityID = SharedFunc.getString(university?.id)
        vc.universityName = SharedFunc.getString(university?.name)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate", let player = object as? AVPlayer {
            if player.rate == 1 {
                print("Playing")
                newPauseVideo(currentPlayer: player)
                
            } else {
                print("Paused")
            }
        }
    }
    
    func newPauseVideo(currentPlayer: AVPlayer){
        for cell in cellCache {
            if let fcell = cell as? FeedsCell, let player = fcell.avPlayer, player.rate == 1 {
                if player != currentPlayer {
                    player.pause()
                }
            }
        }
    }

}


extension UniversityViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        default:
            return isAnnouncements ? announcementsDatasource.count : feedsDatasource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnivesityBannerCell.identifier, for: indexPath) as! UnivesityBannerCell
            SharedFunc.loadImage(imageView: cell.imgBanner, urlString: SharedFunc.getString(university?.bannerURLPath))
            cell.imgBanner.contentMode = .scaleAspectFill
            cell.lblUniversityName.text = SharedFunc.getString(university?.name)
            cell.lblMembers.text = SharedFunc.getMembersCount(SharedFunc.getString(university?.memberCount))
            cell.delegate = self
            return cell
            
        default:
            if indexPath.row < cellCache.count {
                if let cell = cellCache[indexPath.row] {
                    return cell
                }
            }
            
            var description: String = ""
            var imageURL: String = ""
            var videoURL: String = ""
            var postedAt: String = ""
            
            if isAnnouncements {
                description = announcementsDatasource[indexPath.row].description
                imageURL = announcementsDatasource[indexPath.row].imageURL
                postedAt = announcementsDatasource[indexPath.row].postedAt
            }else{
                description = feedsDatasource[indexPath.row].postDescription
                imageURL = feedsDatasource[indexPath.row].photoURLPath
                postedAt = feedsDatasource[indexPath.row].postAt
                videoURL = feedsDatasource[indexPath.row].videoURLPath
            }
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedsCell.identifier, for: indexPath) as! FeedsCell
            cell.separatorInset.left = 0
            cell.selectionStyle = .none
            cell.docID = feedsDatasource[indexPath.row].documentID
            cell.btnMore.tag = indexPath.row
            cell.btnMore.isHidden = isAnnouncements
            cell.imgMore.isHidden = isAnnouncements
            cell.delegate = self
            SharedFunc.loadImage(imageView: cell.imgUniversityIcon, urlString: SharedFunc.getString(university?.bannerURLPath))
            cell.lblUniversityName.text = SharedFunc.getString(university?.name)
            
            if let pastDate = postedAt.toDate() {
                cell.lblPostedBy.text = "Posted " + pastDate.timeAgoDisplay()
            }else{
                cell.lblPostedBy.text = ""
            }
            
            cell.lblText.text = SharedFunc.getString(description)
            cell.imgPhoto.contentMode = .scaleAspectFill
            cell.imgPhoto.layer.cornerRadius = 5
            cell.imgPhoto.layer.masksToBounds = true
            
            if !imageURL.isEmpty {
//                SharedFunc.loadImage(imageView: cell.imgPhoto, urlString: imageURL)
                let url = URL(string: imageURL)
                let processor = DownsamplingImageProcessor(size: cell.imgPhoto.bounds.size)
                            |> RoundCornerImageProcessor(cornerRadius: 5)
                cell.imgPhoto.kf.indicatorType = .activity
                cell.imgPhoto.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholderImage"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
                {
                    result in
                    switch result {
                    case .success(let value):
                        
                        let height = SharedFunc.getImageDesiredHeight(image: cell.imgPhoto.image, baseWidth: cell.imgPhoto.superview!.frame.width)
                        cell.imgPhotoHeightConstraint.constant = height
                        
                        DispatchQueue.main.async {
                            cell.imgPhoto.layoutIfNeeded()
                        }
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                cell.imgPhoto.isHidden = false
            }else{
                cell.imgPhoto.isHidden = true
            }
            
            if videoURL.isEmpty {
                cell.playerView.isHidden = true
            }else{
                let url = URL(string: videoURL)!
                var asset: AVAsset!
                var playerItem: AVPlayerItem!
                let requiredAssetKeys = [
                    "playable",
                    "hasProtectedContent"
                ]

                asset = AVAsset(url: url)
                playerItem = AVPlayerItem(asset: asset,
                                          automaticallyLoadedAssetKeys: requiredAssetKeys)
                
                cell.avPlayer = AVPlayer(playerItem: playerItem)
                cell.avPlayer?.addObserver(self, forKeyPath: "rate", options: [], context: nil)
                let playerController = AVPlayerViewController()

                playerController.player = cell.avPlayer
                playerController.title = "test"
                self.addChild(playerController)
                cell.playerView.addSubview(playerController.view)
                playerController.view.frame = cell.playerView.bounds
                cellCache[indexPath.row] = cell
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0//section == 0 ? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}


extension UniversityViewController: PostTableViewCellDelegate {
    func initiateWritePost() {
        print(#function)
    }
    
    func initiatePhotoPost() {
        print(#function)
    }
    
    func initiatePollPost() {
        print(#function)
    }
}


extension UniversityViewController: FeedsCellDelegate, UIPopoverPresentationControllerDelegate {
    func didTapMore(sender: UIButton, docID: String, index: Int) {
        
        
        FTPopOverMenu.showForSender(sender: sender,
                                    with: ["Delete"],
                                    menuImageArray: ["delete"],
                                    done: { (selectedIndex) -> () in
            
            print(selectedIndex)
            
            PostsAPI.shared.deletePost(documentID: docID) { success  in
                if success {
                    self.feedsDatasource.remove(at: index)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    
    // UIPopoverPresentationControllerDelegate method
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
}


extension UniversityViewController: UnivesityBannerCellDelegate {
    func didTapTopButtons(index: Int) {
        if index == 0 {
            isAnnouncements = false
            tableView.reloadData()
        }else{
            isAnnouncements = true
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            AnnouncementAPI.shared.getAllAnnouncements { data in
                self.announcementsDatasource = data
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.reloadData()
                }
                
            
            }
        }
        
    }
    
    func didTapInvite() {
        
    }
}
