//
//  UniversityCollectionViewCell.swift
//  University Forum
//
//  Created by Ian Talisic on 07/09/2021.
//

import UIKit

class UniversityCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "UniversityCollectionViewCell"
    static let nib: UINib = UINib(nibName: "UniversityCollectionViewCell", bundle: nil)
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
