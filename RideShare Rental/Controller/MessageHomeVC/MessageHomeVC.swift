//
//  MessageHomeVC.swift
//  RideShare Rental
//
//  Created by CasperoniOS on 10/01/19.
//  Copyright © 2019 RideShare Rental. All rights reserved.
//

import UIKit

class MessageHomeVC: UIViewController {
    var pageMenu : CAPSPageMenu?
    @IBOutlet var header_View: CustomView!
    @IBOutlet var msg_Lbl: CustomLabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        var controllerArray : [UIViewController] = []

        let controller : InboxVC = self.storyboard?.instantiateViewController(withIdentifier: "InboxVCID") as! InboxVC
        controller.title = "Conversation with Owner"
        controller.iswithowner = true
        controller.iswithadmin = false
        controller.iswithdirectowner = false
        controller.iswithdirectadmin = false

 
        let controller1 : InboxVC = self.storyboard?.instantiateViewController(withIdentifier: "InboxVCID") as! InboxVC
        controller1.title = "Conversation with Admin"
        controller1.iswithowner = false
        controller1.iswithadmin = true
        controller1.iswithdirectowner = false
        controller1.iswithdirectadmin = false

        let controller2 : InboxVC = self.storyboard?.instantiateViewController(withIdentifier: "InboxVCID") as! InboxVC
        controller2.title = "Direct Conversation with Owner"
        controller2.iswithowner = false
        controller2.iswithadmin = false
        controller2.iswithdirectowner = true
        controller2.iswithdirectadmin = false
        let controller3 : InboxVC = self.storyboard?.instantiateViewController(withIdentifier: "InboxVCID") as! InboxVC
        controller3.title = "Direct Conversation with Admin"
        controller3.iswithowner = false
        controller3.iswithadmin = false
        controller3.iswithdirectowner = false
        controller3.iswithdirectadmin = true
        controllerArray.append(controller)
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        controllerArray.append(controller3)
         var menuFont:UIFont!
        var width:CGFloat!
        if(UIScreen.main.bounds.size.width == 320)
        {
            menuFont =  UIFont(name: Constant.sharedinstance.Medium, size: 12.0)!
            
        }
        else
        {
            menuFont =  UIFont(name: Constant.sharedinstance.Medium, size: 13.0)!
            
        }
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(Themes.sharedInstance.returnThemeColor()),
            .bottomMenuHairlineColor(Themes.sharedInstance.returnThemeColor()),
            .menuItemFont(menuFont),
            .menuHeight(60),
            .menuItemWidth(UIScreen.main.bounds.size.width/3.5+85),
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
    
    @IBAction func DidclickInbox(_ sender: Any) {
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
