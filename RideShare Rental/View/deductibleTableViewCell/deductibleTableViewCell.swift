//
//  deductibleTableViewCell.swift
//  RideShare Rental
//
//  Created by CasperoniOS on 01/06/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import Spring

class deductibleTableViewCell: UITableViewCell {

    @IBOutlet weak var selectionimg: SpringImageView!
    @IBOutlet weak var title: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
