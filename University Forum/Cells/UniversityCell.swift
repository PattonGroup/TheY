//
//  UniversityCell.swift
//  University Forum
//
//  Created by Ian Talisic on 07/09/2021.
//

import UIKit

class UniversityCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.register(UniversityCollectionViewCell.nib, forCellWithReuseIdentifier: UniversityCollectionViewCell.identifier)
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
    }
    
    
    static let identifier: String = "UniversityCell"
    static let nib: UINib = UINib(nibName: "UniversityCell", bundle: nil)
    
    var universityArray: [University] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension UniversityCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.shared.universityBannersImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UniversityCollectionViewCell.identifier, for: indexPath) as! UniversityCollectionViewCell
        cell.imgView.image = UIImage(named: Constants.shared.universityBannersImageNames[indexPath.row])
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.backgroundColor = UIColor.lightGray
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height - 10, height: collectionView.frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED UNIVERSITY AT INDEX: \(indexPath.row)")
        GlobalCache.shared.delegate?.didSelectUniversity(university: University(id: "1", name: "", imageURL: ""))
    }
    
}
