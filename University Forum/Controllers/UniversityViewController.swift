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

class UniversityViewController: UIViewController {
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
    var feedsDatasource: [PostResponseModel] = []
    var cellCache: [UITableViewCell?] = []
    var playerItemContext: Int = 0

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
    
    @IBAction func didTapCreatePost(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(identifier: "PostViewController") as! PostViewController
        vc.universityID = SharedFunc.getString(university?.id)
        vc.universityName = SharedFunc.getString(university?.name)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
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
            return feedsDatasource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnivesityBannerCell.identifier, for: indexPath) as! UnivesityBannerCell
            SharedFunc.loadImage(imageView: cell.imgBanner, urlString: SharedFunc.getString(university?.bannerURLPath))
            cell.imgBanner.contentMode = SharedFunc.getString(university?.id) == "1" ? .scaleAspectFit : .scaleAspectFill
            cell.lblUniversityName.text = SharedFunc.getString(university?.name)
            cell.lblMembers.text = SharedFunc.getMembersCount(SharedFunc.getString(university?.memberCount))
            return cell
            
        default:
            if indexPath.row < cellCache.count {
                if let cell = cellCache[indexPath.row] {
                    return cell
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedsCell.identifier, for: indexPath) as! FeedsCell
            cell.separatorInset.left = 0
            cell.selectionStyle = .none
            SharedFunc.loadImage(imageView: cell.imgUniversityIcon, urlString: SharedFunc.getString(university?.bannerURLPath))
            cell.lblUniversityName.text = SharedFunc.getString(university?.name)
            cell.lblText.text = SharedFunc.getString(feedsDatasource[indexPath.row].postDescription)
            cell.imgPhoto.contentMode = .scaleAspectFill
            cell.imgPhoto.layer.cornerRadius = 5
            cell.imgPhoto.layer.masksToBounds = true
            
            if !feedsDatasource[indexPath.row].photoURLPath.isEmpty {
                SharedFunc.loadImage(imageView: cell.imgPhoto, urlString: feedsDatasource[indexPath.row].photoURLPath)
                cell.imgPhoto.isHidden = false
            }else{
                cell.imgPhoto.isHidden = true
            }
            
            let videoURL: String = SharedFunc.getString(feedsDatasource[indexPath.row].videoURLPath)
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
//                playerItem.addObserver(self,
//                                       forKeyPath: #keyPath(AVPlayerItem.status),
//                                       options: [.old, .new],
//                                       context: &playerItemContext)
                
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
