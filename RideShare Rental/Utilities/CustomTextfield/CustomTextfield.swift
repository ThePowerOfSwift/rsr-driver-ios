//
//  CustomTextfield.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 06/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class CustomTextfield: UITextField {
     /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
     required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)!
        if(self.tag == 10)
        {
          self.font=UIFont(name: Constant.sharedinstance.Regular, size: (self.font?.pointSize)!)
        }
        else if(self.tag == 11)
        {
            self.font=UIFont(name: Constant.sharedinstance.Bold, size: (self.font?.pointSize)!)
        }
        else if(self.tag == 13)
        {
            self.font=UIFont(name: Constant.sharedinstance.SemiBold, size: (self.font?.pointSize)!)
        }
        else if(self.tag == 14)
        {
            self.font=UIFont(name: Constant.sharedinstance.Medium, size: (self.font?.pointSize)!)
        }
            
        else if(self.tag == 15)
        {
            self.font=UIFont(name: Constant.sharedinstance.Light, size: (self.font?.pointSize)!)
        }
        
    }
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            var paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            
            if(newValue == 5)
            {
                paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: frame.size.height))
            }
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRight: CGFloat  {
        get {
            return rightView!.frame.size.width
        }
        set {
            var paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            
            if(newValue == 5)
            {
                paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: frame.size.height))
                
            }
            rightView = paddingView
            rightViewMode = .always
        }
    }


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
     @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
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
