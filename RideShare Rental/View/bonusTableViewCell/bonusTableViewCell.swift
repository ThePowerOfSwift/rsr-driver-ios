//
//  bonusTableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit

class bonusTableViewCell: UITableViewCell {
    @IBOutlet var bonusLbl: CustomLabel!
    
    @IBOutlet var paymentLbl: CustomLabel!
    @IBOutlet var rankLbl: CustomLabel!
    @IBOutlet var dateLbl: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
