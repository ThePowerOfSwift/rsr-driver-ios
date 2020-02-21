//
//  FamilyTree1TableViewCell.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 16/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit

class FamilyTreetableViewCell: UITableViewCell {

    @IBOutlet var vertline2: UILabel!
    @IBOutlet var verticalline: UILabel!
     @IBOutlet var treeverLbl: UILabel!
    @IBOutlet var subTitleLable: UILabel!
    @IBOutlet var titleLable: UILabel!
    
    @IBOutlet var treeButton: UIButton!
    
    @IBOutlet var detailBtn: UIButton!

    var treeNode: TreeViewNodeItem!
    
    @IBOutlet var wrapperView: CustomView!
    var ActualwrapperWidth:CGFloat = CGFloat()
    var isHeaderCell:Bool = Bool()
     //MARK:  Draw Rectangle for Image
    
    
    override func draw(_ rect: CGRect) {
        var titleFrame: CGRect = self.wrapperView.frame
         var buttonFrame: CGRect = self.treeverLbl.frame
        if(!isHeaderCell)
        {
        let indentation: Int = self.treeNode.nodeLevel! * 20
        let indentcount:Int = indentation/20
         for subview in self.subviews
        {
            if(subview is UILabel)
            {
                if(subview.tag == 100)
                {
                    subview.removeFromSuperview()
                }
            }
        }
        for i in 0...indentcount
        {
            let label:UILabel = UILabel()
            var count = i*20
            if(i == 0)
            {
                count = 6
            }
            else
            {
                count = count+6
            }
            var checkcount:Int = 0
            vertline2.isHidden = !self.treeNode.isExpanded!
            if(self.treeNode.nodeChildren?.count != nil)
            {
                checkcount = (self.treeNode.nodeChildren?.count)!
            }
            else
            {
                vertline2.isHidden = true
            }
            //            if(checkcount == 0 && self.treeNode.isExpanded == false && i == indentcount && self.treeNode.nodeLevel! != 0)
            //            {
            //                 label.frame = CGRect.init(x:count , y: 0, width: 3, height: 33)
            //            }
            //
            //            else
            //            {
            //                 label.frame = CGRect.init(x:count , y: 0, width: 3, height: 67)
            //            }
            label.frame = CGRect.init(x:count , y: 0, width: Int(1.5), height: 67)
            
            label.tag = 100
            label.backgroundColor = UIColor.black
            self.addSubview(label)
            
            
            }
         buttonFrame.origin.x = 6 + CGFloat(indentation)
        verticalline.frame.origin.x = buttonFrame.origin.x+buttonFrame.size.width-2
            verticalline.frame.size.width = 30
          titleFrame.origin.x = buttonFrame.size.width+verticalline.frame.size.width + CGFloat(indentation) + 2
        titleFrame.size.width = ActualwrapperWidth - CGFloat(indentation)

        treeverLbl.frame = buttonFrame
        self.wrapperView.frame = titleFrame
            vertline2.frame.origin.x = self.wrapperView.frame.origin.x-9
         wrapperView.sendSubview(toBack: self.contentView)
        }
        else
        {
            for subview in self.subviews
            {
                if(subview is UILabel)
                {
                    if(subview.tag == 100)
                    {
                        subview.removeFromSuperview()
                    }
                }
            }
            for _ in 0...0
            {
                let label:UILabel = UILabel()
                let count = 2
                label.frame = CGRect.init(x:count , y: 31, width: 3, height: 36)
                label.tag = 100
                label.backgroundColor = UIColor.black
                self.addSubview(label)
            }
            buttonFrame.origin.x = 2 + CGFloat(0)
            verticalline.frame.origin.x = buttonFrame.origin.x+buttonFrame.size.width
            titleFrame.origin.x = buttonFrame.size.width+verticalline.frame.size.width + CGFloat(0) + 2
            titleFrame.size.width = ActualwrapperWidth - CGFloat(0)
             treeverLbl.frame = buttonFrame
            
            self.wrapperView.frame = titleFrame
            
            wrapperView.sendSubview(toBack: self.contentView)
        }
       
     }
    
    
    
    //MARK:  Set Background image
    
    func setTheButtonBackgroundImage(_ backgroundImage: UIImage) {
        self.treeButton.setImage(backgroundImage, for: UIControlState())
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ActualwrapperWidth = UIScreen.main.bounds.size.width-40
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         // Configure the view for the selected state
    }
    
    
    
    @IBAction func treeButtonCLicked(_ sender: Any) {
        
        if (self.treeNode != nil) {
            if self.treeNode.nodeChildren != nil {
                if self.treeNode.isExpanded == true {
                    self.treeNode.isExpanded = false
                } else {
                    self.treeNode.isExpanded = true
                }
            } else {
                self.treeNode.isExpanded = false
            }
            
            self.isSelected = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: "TreeNodeButtonClicked"), object: self)
        }
    }
    
    
    @IBAction func detailsButtonClicked(_ sender: Any) {
        
    }

}
