//
//  TopMenuCell.swift
//  University Forum
//
//  Created by Ian Talisic on 28/10/2021.
//

import UIKit

class TopMenuCell: UITableViewCell {
    static let identifier: String = "TopMenuCell"
    static let nib: UINib = UINib(nibName: "TopMenuCell", bundle: nil)

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(TopMenuCollectionViewCell.nib, forCellWithReuseIdentifier: TopMenuCollectionViewCell.identifier)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



extension TopMenuCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.shared.topMenuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopMenuCollectionViewCell.identifier, for: indexPath) as! TopMenuCollectionViewCell
//        cell.imgIcon.backgroundColor = .blue
        if indexPath.row == 0 {
            cell.imgIcon.image = UIImage(named: "camera-icon")?.withRenderingMode(.alwaysTemplate)
            cell.imgIcon.tintColor = .darkGray
            cell.lblTitle.text = ""
            cell.configureMenu(isFirstMenu: true)
//            cell.imgIcon.contentMode = .scaleAspectFill
        }else{
            cell.menuItem = Constants.shared.topMenuItems[indexPath.row]
            cell.configureMenu()
//            cell.imgIcon.contentMode = .scaleAspectFit
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SharedFunc.shared.delegate?.didSelectTopItem(index: indexPath.row)
    }
    
}
