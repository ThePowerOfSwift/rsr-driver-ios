//
//  UpdatetableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 28/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import Shimmer

class UpdatetableViewCell: UITableViewCell {

    @IBOutlet var updateBtn: UIButton!
    @IBOutlet var updateLbl: CustomLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let shimmeringView = FBShimmeringView(frame: self.contentView.bounds)
         self.contentView.addSubview(shimmeringView as? UIView ?? UIView())
        shimmeringView.contentView = updateLbl
        shimmeringView.isShimmering = true
        self.contentView.bringSubview(toFront: updateBtn)
 
    }
    @IBAction func Didclickupdate(_ sender: Any) {
        
 let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id1338753121")
         if #available(iOS 10.0, *) {
            UIApplication.shared.open(appStoreURL!, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(appStoreURL!)
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
