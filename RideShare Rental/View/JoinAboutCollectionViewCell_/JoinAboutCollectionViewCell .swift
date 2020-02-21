//
//  AboutCollectionViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 02/01/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit

class JoinAboutCollectionViewCell : UICollectionViewCell {
    @IBOutlet var wrapperView: UIView!

    @IBOutlet var nameLbl1: CustomLabel!
    @IBOutlet var featureimg1: UIImageView!
    
    @IBOutlet var nameLbl2: CustomLabel!
    @IBOutlet var featureimg2: UIImageView!
    
    
    @IBOutlet var nameLbl3: CustomLabel!
    @IBOutlet var featureimg3: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
