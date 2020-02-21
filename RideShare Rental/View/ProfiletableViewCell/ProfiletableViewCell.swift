//
//  ProfiletableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 07/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class ProfiletableViewCell: UITableViewCell {
    @IBOutlet var title: CustomLabel!
    @IBOutlet var desc: CustomLabel!

    @IBOutlet var licenseimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
