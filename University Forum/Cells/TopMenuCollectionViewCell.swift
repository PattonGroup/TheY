//
//  TopMenuCollectionViewCell.swift
//  University Forum
//
//  Created by Ian Talisic on 28/10/2021.
//

import UIKit

class TopMenuCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "TopMenuCollectionViewCell"
    static let nib: UINib = UINib(nibName: "TopMenuCollectionViewCell", bundle: nil)

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var menuItem: TopMenuItem? {
        didSet {
            setupMenu()
        }
    }
    
    func configureMenu(isFirstMenu: Bool = false) {
        widthConstraint.constant = isFirstMenu ?  40 : 30
        heightConstraint.constant = isFirstMenu ?  40 : 30
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    private func setupMenu(){
        guard let item = menuItem else { return }
        imgIcon.image = UIImage(named: item.menuIconName)
        lblTitle.text = item.menuTitle
        
        
//        let url = URL(string: "https://example.com/high_resolution_image.png")
//        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
//                     |> RoundCornerImageProcessor(cornerRadius: 20)
//        imageView.kf.indicatorType = .activity
//        imageView.kf.setImage(
//            with: url,
//            placeholder: UIImage(named: "placeholderImage"),
//            options: [
//                .processor(processor),
//                .scaleFactor(UIScreen.main.scale),
//                .transition(.fade(1)),
//                .cacheOriginalImage
//            ])
//        {
//            result in
//            switch result {
//            case .success(let value):
//                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//            }
//        }
    }
    

}
