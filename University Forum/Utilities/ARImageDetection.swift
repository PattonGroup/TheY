//
//  ARImageDetection.swift
//  University Forum
//
//  Created by Ian Talisic on 10/11/2021.
//

import Foundation
import ARKit
import UIKit

class ImageDetection: UIViewController {
    
}

extension ImageDetection: ARSCNViewDelegate{

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

      //1. Check We Have Detected An ARImageAnchor
      guard let validAnchor = anchor as? ARImageAnchor else { return }

      //2. Create A Video Player Node For Each Detected Target
      node.addChildNode(createdVideoPlayerNodeFor(validAnchor.referenceImage))

    }


    /// Creates An SCNNode With An AVPlayer Rendered Onto An SCNPlane
    ///
    /// - Parameter target: ARReferenceImage
    /// - Returns: SCNNode
    func createdVideoPlayerNodeFor(_ target: ARReferenceImage) -> SCNNode{

      //1. Create An SCNNode To Hold Our VideoPlayer
      let videoPlayerNode = SCNNode()

      //2. Create An SCNPlane & An AVPlayer
      let videoPlayerGeometry = SCNPlane(width: target.physicalSize.width, height: target.physicalSize.height)
      var videoPlayer = AVPlayer()

      //3. If We Have A Valid Name & A Valid Video URL The Instanciate The AVPlayer
      if let targetName = target.name,
        let validURL = Bundle.main.url(forResource: targetName, withExtension: "mp4", subdirectory: "/art.scnassets") {
        videoPlayer = AVPlayer(url: validURL)
        videoPlayer.play()
      }

      //4. Assign The AVPlayer & The Geometry To The Video Player
      videoPlayerGeometry.firstMaterial?.diffuse.contents = videoPlayer
      videoPlayerNode.geometry = videoPlayerGeometry

      //5. Rotate It
      videoPlayerNode.eulerAngles.x = -.pi / 2

      return videoPlayerNode

    }

  }
