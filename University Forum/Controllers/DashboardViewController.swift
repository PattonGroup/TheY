//
//  DashboardViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 06/09/2021.
//

import AVKit
import UIKit
import Kingfisher
import MBProgressHUD

class DashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(TopMenuCell.nib, forCellReuseIdentifier: TopMenuCell.identifier)
            tableView.register(UniversityCell.nib, forCellReuseIdentifier: UniversityCell.identifier)
            tableView.register(FeedsCell.nib, forCellReuseIdentifier: FeedsCell.identifier)
            tableView.tableHeaderView = UIView()
            tableView.tableFooterView = UIView()
            tableView.sectionHeaderHeight = 0
            tableView.sectionFooterHeight = 0
        }
    }
    
    let refreshControl = UIRefreshControl()
    var selectedUniversity: UniversityResponseModel?
    var dataSource: [PostResponseModel] = []
    var cellCache: [UITableViewCell?] = []
    var playerItemContext: Int = 0
    var universityDatasource: [UniversityResponseModel] = []
    let group = DispatchGroup()
    var isFirstLoad: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view
    }
    
    @objc private func setup(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = "Univercity Hangouts"
        
        SharedFunc.shared.delegate = self
        SharedFunc.initializeCellCache(cellCache: &cellCache, count: dataSource.count)
        GlobalCache.shared.delegate = self
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
        SharedFunc.initializeObserver(isAdd: true, vc: self, cellCache: cellCache)
        
        if isFirstLoad {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        getAllUniversity()
        getAllPosts()
        getNotifiedAfterFetching()
        let userID = SharedFunc.getUserID()
        
        print("USERID: \(userID)")
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(setup), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFirstLoad {
            getAllPosts()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayedVideos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pausePlayedVideos()
    }
    
    private func getAllUniversity(){
        // MARK:  Fetch all the universities
        group.enter()
        UniversityAPI.shared.getAllUniversity { [self] data in
            print("Universities: \(data)")
            universityDatasource = data
            tableView.reloadData()
            group.leave()
        }
    }
    private func getAllPosts() {
        // MARK: Fetch all posts
        group.enter()
        PostsAPI.shared.getAllPosts {[self] data in
            print("Posts: \(data)")
            dataSource = data
            SharedFunc.initializeCellCache(cellCache: &cellCache, count: dataSource.count)
            tableView.reloadSections([2], with: .none)
            group.leave()
        }
    }
    
    private func getNotifiedAfterFetching(){
        group.notify(queue: .main) {
            print("both done")
            self.isFirstLoad = false
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUniversity" {
            (segue.destination as! UniversityViewController).university = selectedUniversity
        }
    }
    
    func playVideo(cell:UITableViewCell,row:Int) {
            guard let cell = cell as? FeedsCell else {
                return
            }
            let url = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
//            let player = AVPlayer(url: url)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = cell.playerView.bounds
//            playerLayer.name = "Video"
//            cell.playerView.layer.addSublayer(playerLayer)
//            player.play()
        
            let player = AVPlayer(url: url)
            let playerController = AVPlayerViewController()

            playerController.player = player
            self.addChild(playerController)
        cell.playerView.addSubview(playerController.view)
        playerController.view.frame = cell.playerView.bounds

            player.play()
        }

        func removeVideo(cell:UITableViewCell,row:Int) {
            guard let cell = cell as? FeedsCell, let layers = cell.playerView.layer.sublayers else {
                return
            }
            for layer in layers {
                if layer.name == "Video" {
                    //(layer as? AVPlayerLayer)?.player?.pause()
                    layer.removeFromSuperlayer()
                }
            }
        }

    @IBAction func didTapLogout(_ sender: Any) {
        SharedFunc.logout(self)
    }
}

extension DashboardViewController: SharedFuncDelegate {
    func didSelectTopItem(index: Int) {
        switch index {
        case 0:
            self.performSegue(withIdentifier: "ImageDetection", sender: self)
            break
        
        case 1:
            self.performSegue(withIdentifier: "showCurriculum", sender: self)
            break
            
        case 2:
            self.performSegue(withIdentifier: "showTraining", sender: self)
            break
            
        case 3:
            self.performSegue(withIdentifier: "showTask", sender: self)
            break
            
        default:
            break
        }
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ?  dataSource.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TopMenuCell.identifier, for: indexPath) as! TopMenuCell
            cell.collectionView.reloadData()
            cell.separatorInset.left = self.view.frame.width
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: UniversityCell.identifier, for: indexPath) as! UniversityCell
            cell.collectionView.reloadData()
            cell.separatorInset.left = 0
            cell.selectionStyle = .none
            cell.universityDatasource = self.universityDatasource
            return cell
            
        default:
            if let cell = cellCache[indexPath.row] {
                return cell
            }
            
            let university = SharedFunc.getUnivesityDetails(id:  SharedFunc.getString(dataSource[indexPath.row].universityID), universityList: universityDatasource)
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedsCell.identifier, for: indexPath) as! FeedsCell
            cell.separatorInset.left = 0
            cell.selectionStyle = .none
            SharedFunc.loadImage(imageView: cell.imgUniversityIcon, urlString: university.bannerURLPath)
            cell.lblUniversityName.text = university.name
            
            if let pastDate = dataSource[indexPath.row].postAt.toDate() {
                cell.lblPostedBy.text = "Posted " + pastDate.timeAgoDisplay()
            }else{
                cell.lblPostedBy.text = ""
            }

            cell.lblText.text = SharedFunc.getString(dataSource[indexPath.row].postDescription)
            cell.imgPhoto.contentMode = .scaleAspectFill
            cell.imgPhoto.layer.cornerRadius = 5
            cell.imgPhoto.layer.masksToBounds = true
            cell.separatorInset.left = (indexPath.row == dataSource.count - 1) ? self.view.frame.width : 0
            
            if !dataSource[indexPath.row].photoURLPath.isEmpty {
                SharedFunc.loadImage(imageView: cell.imgPhoto, urlString: dataSource[indexPath.row].photoURLPath)
                cell.imgPhoto.isHidden = false
            }else{
                cell.imgPhoto.isHidden = true
            }
            
            let videoURL: String = SharedFunc.getString(dataSource[indexPath.row].videoURLPath)
            cell.playerView.isHidden = videoURL.isEmpty
            
            if !videoURL.isEmpty {
                let url = URL(string: videoURL)!
                var asset: AVAsset!
                //            var player: AVPlayer!
                var playerItem: AVPlayerItem!
                
                // Key-value observing context
                
                
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
                
                
                //            cell.avPlayer = AVPlayer(url: url)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected at \(indexPath.row)")
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
//        playVideo(cell: cell, row: indexPath.row)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:  return 65
            case 1: return 100
            default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? 3 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 3))
            header.backgroundColor = UIColor(named: "gray-separator")
            return header
        }
        return nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayedVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayedVideos()
        }
    }
    
    func pausePlayedVideos(){
//        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
//        pauseVideos()
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
    
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
    
    func pauseVideos(){
//        if let indices = tableView.indexPathsForVisibleRows {
//            for i in 0..<dataSource.count {
//                let indexPath = IndexPath(row: i, section: 1)
//                if let cell = tableView.cellForRow(at: indexPath) as? FeedsCell, let player = cell.avPlayer {
//                    if indices.contains(indexPath) && (player.rate != 0 && player.error == nil) {
//                        //do nothing
//                    }else{
//                        player.pause()
//                    }
//                }
//            }
//        }
    }
}


extension DashboardViewController: GlobalCacheDelegate {
    func didSelectUniversity(university: UniversityResponseModel) {
        SharedFunc.initializeObserver(isAdd: false, vc: self, cellCache: cellCache)
        self.selectedUniversity = university
        self.performSegue(withIdentifier: "showUniversity", sender: nil)
    }
}
