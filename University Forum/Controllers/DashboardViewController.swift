//
//  DashboardViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 06/09/2021.
//

import AVKit
import UIKit
import ARKit

class DashboardViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
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
    
    
    var selectedUniversity: University?
    var dataSource: [NSDictionary] = [[:],[:],[:],[:],[:],[:],[:],[:],[:],[:]]
    var cellCache: [UITableViewCell?] = []
    var playerItemContext: Int = 0
    var session: ARSession {
        return sceneView.session
    }
    
    // Create video player
    let isaVideoPlayer: AVPlayer = {
        //load Isa video from bundle
        guard let url = Bundle.main.url(forResource: "isa video", withExtension: "mp4", subdirectory: "art.scnassets") else {
            print("Could not find video file")
            return AVPlayer()
        }
        
        return AVPlayer(url: url)
    }()
    let pragueVideoPlayer: AVPlayer = {
        //load Prague video from bundle
        guard let url = Bundle.main.url(forResource: "prague video", withExtension: "mp4", subdirectory: "art.scnassets") else {
            print("Could not find video file")
            return AVPlayer()
        }
        
        return AVPlayer(url: url)
    }()
    let fightClubVideoPlayer: AVPlayer = {
        //load Prague video from bundle
        guard let url = Bundle.main.url(forResource: "fight club video", withExtension: "mov", subdirectory: "art.scnassets") else {
            print("Could not find video file")
            return AVPlayer()
        }
        
        return AVPlayer(url: url)
    }()
    let homerVideoPlayer: AVPlayer = {
        //load Prague video from bundle
        guard let url = Bundle.main.url(forResource: "homer video", withExtension: "mov", subdirectory: "art.scnassets") else {
            print("Could not find video file")
            return AVPlayer()
        }
        
        return AVPlayer(url: url)
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        sceneView.delegate = self
        sceneView.session.delegate = self
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            print("Could not load images")
            return
        }
        
        // Setup Configuration
        configuration.trackingImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 4
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = "University Hangouts"
        
        SharedFunc.initializeCellCache(cellCache: &cellCache, count: dataSource.count)
        GlobalCache.shared.delegate = self
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        // Do any additional setup after loading the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SharedFunc.initializeObserver(isAdd: true, vc: self, cellCache: cellCache)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the AR experience
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }
    
    func resetTracking() {
        let configuration = ARImageTrackingConfiguration()
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        // Show video overlaid on image
        if let imageAnchor = anchor as? ARImageAnchor {
            
            // Create a plane
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            if imageAnchor.referenceImage.name == "prague image" {
                // Set AVPlayer as the plane's texture and play
                plane.firstMaterial?.diffuse.contents = self.pragueVideoPlayer
                self.pragueVideoPlayer.play()
                self.pragueVideoPlayer.volume = 0.4
            } else if imageAnchor.referenceImage.name == "fight club image" {
                plane.firstMaterial?.diffuse.contents = self.fightClubVideoPlayer
                self.fightClubVideoPlayer.play()
            } else if imageAnchor.referenceImage.name == "homer image" {
                plane.firstMaterial?.diffuse.contents = self.homerVideoPlayer
                self.homerVideoPlayer.play()
            } else {
                plane.firstMaterial?.diffuse.contents = self.isaVideoPlayer
                self.isaVideoPlayer.play()
                self.isaVideoPlayer.isMuted = true
            }
            
            let planeNode = SCNNode(geometry: plane)
            
            // Rotate the plane to match the anchor
            planeNode.eulerAngles.x = -.pi / 2
            
            // Add plane node to parent
            node.addChildNode(planeNode)
        }
        
        return node
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

}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ?  10 : 1
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
            return cell
            
        default:
            if let cell = cellCache[indexPath.row] {
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedsCell.identifier, for: indexPath) as! FeedsCell
            cell.separatorInset.left = 0
            cell.imgPhoto.isHidden = indexPath.row % 2 == 0
            cell.selectionStyle = .none
//            let url = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//            let avPlayer = AVPlayer(url: url!);
//            cell.playerView?.playerLayer.player = avPlayer;
//            cell.playerView?.playerLayer.player?.allowsExternalPlayback = true
//            cell.configureCell(imageUrl: nil, description: "Video", videoUrl: "https://v.pinimg.com/videos/720p/0d/29/18/0d2918323789eabdd7a12cdd658eda04.mp4")
//            cell.configureCell(imageUrl: nil, description: "", videoUrl:  "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
            
//            DispatchQueue.main.async {
//                cell.imgPhoto.image = SharedFunc.createVideoThumbnail(from: url!)
//            }
            let url = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
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
            playerItem.addObserver(self,
                                   forKeyPath: #keyPath(AVPlayerItem.status),
                                   options: [.old, .new],
                                   context: &playerItemContext)
            
            
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
            case 0:  return 80
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

extension DashboardViewController: ARSessionDelegate {
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Use `flatMap(_:)` to remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        blurView.isHidden = false
        statusViewController.showMessage("""
        SESSION INTERRUPTED
        The session will be reset after the interruption has ended.
        """, autoHide: false)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        blurView.isHidden = true
        statusViewController.showMessage("RESETTING SESSION")
        
        restartExperience()
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Blur the background.
        blurView.isHidden = false
        
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.blurView.isHidden = true
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Interface Actions
    
    func restartExperience() {
        guard isRestartAvailable else { return }
        isRestartAvailable = false
        
        statusViewController.cancelAllScheduledMessages()
        
        resetTracking()
        
        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
        }
    }
}


extension DashboardViewController: GlobalCacheDelegate {
    func didSelectUniversity(university: University) {
        SharedFunc.initializeObserver(isAdd: false, vc: self, cellCache: cellCache)
        self.selectedUniversity = university
        self.performSegue(withIdentifier: "showUniversity", sender: nil)
    }
}
