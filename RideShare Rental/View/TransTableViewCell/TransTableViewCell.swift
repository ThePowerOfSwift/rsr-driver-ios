//
//  TransTableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit

class TransTableViewCell: UITableViewCell {
    @IBOutlet var nameLbl: CustomLabel!
    
    @IBOutlet var statusLbl: CustomLabel!
    @IBOutlet var typeLbl: CustomLabel!
    @IBOutlet var levelLbl: CustomLabel!
    @IBOutlet var dateLbl: CustomLabel!
    @IBOutlet var rankLbl: CustomLabel!
    @IBOutlet var commLbl: CustomLabel!
    @IBOutlet var percentLbl: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
