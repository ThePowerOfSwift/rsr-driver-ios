//
//  ExtendDetailtableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 15/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class ExtendDetailtableViewCell: UITableViewCell {
    @IBOutlet var from_date: CustomLabel!
    
    @IBOutlet var total_charge: CustomLabel!
    @IBOutlet var noofDays: CustomLabel!
    @IBOutlet var to_date: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
