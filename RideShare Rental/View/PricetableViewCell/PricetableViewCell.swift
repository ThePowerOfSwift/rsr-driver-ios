//
//  PricetableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 12/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class PricetableViewCell: UITableViewCell {

    @IBOutlet var help_btn: UIButton!
     @IBOutlet var right_Lbl: CustomLabel!
    @IBOutlet var left_Lbl: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
