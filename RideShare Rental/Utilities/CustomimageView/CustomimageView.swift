//
//  CustomimageView.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 06/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class CustomimageView: UIImageView {

  
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var isAddbackgroudColor: Bool = false {
        didSet {
            if(isAddbackgroudColor)
            {
                self.backgroundColor = Themes.sharedInstance.returnThemeColor()
            }
        }
    }
    @IBInspectable var isRoundedCorner: Bool = false {
        didSet {
            if(isRoundedCorner)
            {
                layer.cornerRadius = self.frame.size.width/2;
                self.clipsToBounds = true;
            }
        }
    }
    
 
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

}
