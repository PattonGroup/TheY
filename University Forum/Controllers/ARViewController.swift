//
//  ARViewController.swift
//  University Forum
//
//  Created by Ian Talisic on 15/11/2021.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var containerView: UIView!
    var sceneView = ARSCNView()
    var player: AVPlayer!
    var videoScene: SKScene!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.frame = self.view.bounds
        sceneView.delegate = self
        self.view.addSubview(sceneView)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let btn = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapClose))
        self.navigationItem.rightBarButtonItem = btn
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeAR()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.player?.pause()
        self.player = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
    
    @objc func didTapClose(){
        player?.pause()
        player = nil
        self.navigationController?.popViewController(animated: false)
    }
    
    func initializeAR(){
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // first see if there is a folder called "ARImages" Resource Group in our Assets Folder
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ARImages", bundle: Bundle.main) {
            
            // if there is, set the images to track
            configuration.trackingImages = trackedImages
            // at any point in time, only 1 image will be tracked
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print(#function)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print(#function)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        print(#function)
        print("ffffff: \(scene)")
        
        if scene != videoScene {
            videoScene?.removeFromParent()
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        print(#function)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
//        // if the anchor is not of type ARImageAnchor (which means image is not detected), just return
        guard let imageAnchor = anchor as? ARImageAnchor, let fileUrlString = Bundle.main.path(forResource: "ymca-video", ofType: "mp4") else {
            print("gg")
            return
        }
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: fileUrlString))
        player = AVPlayer(playerItem: playerItem)
        //initialize video node with avplayer
        let videoNode = SKVideoNode(avPlayer: player)
        player.volume = 1
        player.play()
        // add observer when our player.currentItem finishes player, then start playing from the beginning
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { [self] (notification) in
            player.seek(to: CMTime.zero)
//            player.play()
        }
        
        // set the size (just a rough one will do)
        videoScene = SKScene(size: CGSize(width: 800, height: 500))
        // center our video to the size of our video scene
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        // invert our video so it does not look upside down
        videoNode.yScale = -1.0
        // add the video to our scene
        videoScene.addChild(videoNode)
        // create a plan that has the same real world height and width as our detected image
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        // set the first materials content to be our video scene
        plane.firstMaterial?.diffuse.contents = videoScene
        // create a node out of the plane
        let planeNode = SCNNode(geometry: plane)
        // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
        planeNode.eulerAngles.x = -Float.pi / 2
        planeNode.name = "video"
        // finally add the plane node (which contains the video node) to the added node
        node.addChildNode(planeNode)
        
        print("scene: \(videoScene)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
