//
//  MytransactableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 18/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class MytransactableViewCell: UITableViewCell {

    @IBOutlet var dateadded: CustomLabel!
    @IBOutlet var amt_Lbl: CustomLabel!
    @IBOutlet var cost_Lbl: CustomLabel!
    @IBOutlet var header_Lbl: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
