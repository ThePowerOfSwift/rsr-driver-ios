//
//  WishlisttableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 23/01/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit

class WishlisttableViewCell: UITableViewCell {
    @IBOutlet var vehicleno: CustomLabel!
    
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var userimage: CustomButton!
    @IBOutlet var favBtn: UIButton!
    @IBOutlet var vinno: CustomLabel!
    @IBOutlet var carname: CustomLabel!
    @IBOutlet var carimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
