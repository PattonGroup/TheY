//
//  FeedsCell.swift
//  University Forum
//
//  Created by Ian Talisic on 07/09/2021.
//

import UIKit
import AVKit

class FeedsCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    
    @IBOutlet weak var imgUniversityIcon: CustomImageView!
    @IBOutlet weak var lblUniversityName: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var playerView: PlayerView!
    
    var playerController: ASVideoPlayerController?
    var avPlayer: AVPlayer?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    
    static let identifier: String = "FeedsCell"
    static let nib: UINib = UINib(nibName: "FeedsCell", bundle: nil)


    override func awakeFromNib() {
        super.awakeFromNib()
//        imgPhoto.layer.cornerRadius = 5
//        imgPhoto.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
////        imgPhoto.clipsToBounds = true
//        imgPhoto.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
//        imgPhoto.layer.borderWidth = 0.5
//        videoLayer.backgroundColor = UIColor.clear.cgColor
//        videoLayer.videoGravity = AVLayerVideoGravity.resize
//        imgPhoto.layer.addSublayer(videoLayer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
        self.videoURL = videoUrl
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 20
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.9).rounded(.up)
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(imgPhoto.frame, from: imgPhoto)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
}
