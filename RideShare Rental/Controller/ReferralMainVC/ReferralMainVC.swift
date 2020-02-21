//
//  ReferralMainVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 14/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit

class ReferralMainVC: UIViewController {
    var pageMenu : CAPSPageMenu?
    @IBOutlet var header_View: CustomView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var controllerArray : [UIViewController] = []
        let controller : InviteVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteVCID") as! InviteVC
        controller.title = "INFO"
        let controller2 : ReftransactionVC = self.storyboard?.instantiateViewController(withIdentifier: "ReftransactionVCID") as! ReftransactionVC
        controller2.title = "TRANSACTIONS"
        
        
        let controller3 : rankChangeVC = self.storyboard?.instantiateViewController(withIdentifier: "rankChangeVCID") as! rankChangeVC
        controller3.title = "RANK"

        let controller4 : bonusVC = self.storyboard?.instantiateViewController(withIdentifier: "bonusVCID") as! bonusVC
        controller4.title = "BONUS"

        let controller5 : PayoutVC = self.storyboard?.instantiateViewController(withIdentifier: "PayoutVCID") as! PayoutVC
        controller5.title = "PAYOUT"
        
        let controller6: TreeVC = self.storyboard?.instantiateViewController(withIdentifier: "TreeVCID") as! TreeVC
        controller6.title = "GENOMIC TREE"
        controllerArray.append(controller)
        controllerArray.append(controller2)
        controllerArray.append(controller3)
        controllerArray.append(controller4)
        controllerArray.append(controller5)
        controllerArray.append(controller6)

        var menuFont:UIFont!
        var width:CGFloat!
        if(UIScreen.main.bounds.size.width == 320)
        {
          menuFont =  UIFont(name: Constant.sharedinstance.Medium, size: 12.0)!
      
        }
        else
        {
            menuFont =  UIFont(name: Constant.sharedinstance.Medium, size: 12.0)!
 
        }

        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(Themes.sharedInstance.returnThemeColor()),
            .bottomMenuHairlineColor(Themes.sharedInstance.returnThemeColor()),
            .menuItemFont(menuFont),
            .menuHeight(60),
            .menuItemWidth(UIScreen.main.bounds.size.width/4+20),
            .centerMenuItems(true),.hideTopMenuBar(false),.selectedMenuItemLabelColor(Themes.sharedInstance.returnThemeColor()),.unselectedMenuItemLabelColor(UIColor.black)
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:header_View.frame.size.height, width:self.view.frame.width, height:self.view.frame.height-header_View.frame.size.height), pageMenuOptions: parameters)
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func DidclickMenu(_ sender: Any) {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
