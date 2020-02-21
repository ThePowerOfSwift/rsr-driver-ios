//
//  DoctableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class DoctableViewCell: UITableViewCell {

    @IBOutlet var view_Btn: CustomButton!
    @IBOutlet var selectBtn: UIImageView!
    @IBOutlet var title: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
