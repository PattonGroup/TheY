//
//  UniversityViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 06/09/2021.
//

import UIKit
import AVKit
import AVFoundation

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
    var university: University?
    var feedsDatasource: [Feed] = [Feed(), Feed(), Feed()]
    var cellCache: [UITableViewCell?] = []
    var playerItemContext: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Patton University"
        // Do any additional setup after loading the view.
        tableView.sectionHeaderHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        SharedFunc.initializeCellCache(cellCache: &cellCache, count: feedsDatasource.count, isDashboard: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        SharedFunc.initializeObserver(isAdd: false, vc: self, cellCache: cellCache)
        self.navigationController?.popViewController(animated: true)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
            
        default:
            return feedsDatasource.count
    
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnivesityBannerCell.identifier, for: indexPath) as! UnivesityBannerCell
            cell.imgBanner.image = UIImage(named: university!.imageName)
            cell.imgBanner.contentMode = .scaleAspectFill
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.delegate = self
            return cell
            
        default:
            if let cell = cellCache[indexPath.row] {
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedsCell.identifier, for: indexPath) as! FeedsCell
            cell.separatorInset.left = 0
            cell.selectionStyle = .none
            
            let videoURL: String = ""
            if videoURL.isEmpty {
                cell.playerView.isHidden = true
                cell.imageView?.isHidden = false
            }else{
                let url = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
                var asset: AVAsset!
                var playerItem: AVPlayerItem!

                // Key-value observing context
                

                let requiredAssetKeys = [
                    "playable",
                    "hasProtectedContent"
                ]

                asset = AVAsset(url: url)
                playerItem = AVPlayerItem(asset: asset,
                                          automaticallyLoadedAssetKeys: requiredAssetKeys)
                playerItem.addObserver(self,
                                       forKeyPath: #keyPath(AVPlayerItem.status),
                                       options: [.old, .new],
                                       context: &playerItemContext)
                
                
    //            cell.avPlayer = AVPlayer(url: url)
                cell.avPlayer = AVPlayer(playerItem: playerItem)
    //            cell.avPlayer?.removeObserver(self, forKeyPath: "rate")
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
        
        let vc = self.storyboard!.instantiateViewController(identifier: "PostViewController") as! PostViewController
        let transition = CATransition()
           transition.duration = 0.5
           transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           transition.type = CATransitionType.moveIn
           transition.subtype = CATransitionSubtype.fromTop
           self.navigationController?.view.layer.add(transition, forKey: nil)
           self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func initiatePhotoPost() {
        print(#function)
    }
    
    func initiatePollPost() {
        print(#function)
    }
}
