//
//  AddressDisplayCell.swift
//  UberForXUser
//
//  Created by Japahar Jose on 09/10/18.
//  Copyright © 2018 Casperon. All rights reserved.
//

import UIKit

class AddressDisplayCell: UITableViewCell {

    @IBOutlet weak var locImgView: CustomimageView!
    @IBOutlet weak var addressNameLbl: CustomLabel!
    @IBOutlet weak var formattedAddressLbl: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
