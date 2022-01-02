//
//  FeedsCell.swift
//  University Forum
//
//  Created by Ian Talisic on 07/09/2021.
//

import UIKit
import AVKit

protocol FeedsCellDelegate {
    func didTapMore(sender: UIButton, docID: String, index: Int)
}

class FeedsCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    
    @IBOutlet weak var imgUniversityIcon: CustomImageView!
    @IBOutlet weak var lblUniversityName: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblPostedBy: UILabel!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imgMore: UIImageView!
    @IBOutlet weak var imgPhotoHeightConstraint: NSLayoutConstraint!
    
    var playerController: ASVideoPlayerController?
    var delegate: FeedsCellDelegate?
    var avPlayer: AVPlayer?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var docID: String = ""
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
        imgMore.image = imgMore.image?.withRenderingMode(.alwaysTemplate)
        imgMore.tintColor = .darkGray
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
    
    @IBAction func didTapMore(_ sender: UIButton) {
        delegate?.didTapMore(sender: sender, docID: docID, index: sender.tag)
    }
}
