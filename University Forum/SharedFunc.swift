//
//  SharedFunc.swift
//  University Forum
//
//  Created by Ian Talisic on 11/09/2021.
//

import Foundation
import AVKit
import UIKit

class SharedFunc {
    static let shared = SharedFunc()
    
    static func createVideoThumbnail(from url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.7)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 2)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }

    }
    
    static func initializeCellCache(cellCache: inout [UITableViewCell?], count: Int, isDashboard: Bool = true) {
        cellCache.removeAll()
        if isDashboard {
            cellCache.append(nil) /*This is for the first cell*/
        }
        for _ in 0..<count {
            cellCache.append(nil)
        }
    }
    
    static func initializeObserver(isAdd: Bool, vc: UIViewController, cellCache: [UITableViewCell?]){
        for cell in cellCache {
            if let ncell = cell as? FeedsCell {
                if isAdd {
                    ncell.avPlayer?.addObserver(vc, forKeyPath: "rate", options: [], context: nil)
                }else{
                    ncell.avPlayer?.pause()
                    ncell.avPlayer?.removeObserver(vc, forKeyPath: "rate")
                }
            }
        }
    }
}
