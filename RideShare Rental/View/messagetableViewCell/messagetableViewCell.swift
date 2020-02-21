//
//  messagetableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 15/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class messagetableViewCell: UITableViewCell {
    @IBOutlet var user_img: CustomimageView!
    
    @IBOutlet var read_status: UIImageView!
    @IBOutlet var date_Lbl: CustomLabel!
    @IBOutlet var message_Lbl: CustomLabel!
    @IBOutlet var name_Lbl: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
