//
//  CollectionViewCell.swift
//  HorizontalCollectionView
//
//  Created by home on 2019/08/31.
//  Copyright © 2019 Swift-beginners. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
