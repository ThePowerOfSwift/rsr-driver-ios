//
//  MyreservationVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 12/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class MyreservationVC: UIViewController {
    var pageMenu : CAPSPageMenu?

    @IBOutlet var header_View: CustomView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var controllerArray : [UIViewController] = []
         let controller : ActiveReservationVC = self.storyboard?.instantiateViewController(withIdentifier: "ActiveReservationVCID") as! ActiveReservationVC
        controller.title = "ACTIVE RESERVATION"
        let controller2 : PastReservationVC = self.storyboard?.instantiateViewController(withIdentifier: "PastReservationVCID") as! PastReservationVC
        controller2.title = "PAST RESERVATION"
        controllerArray.append(controller)
        controllerArray.append(controller2)
         let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(Themes.sharedInstance.returnThemeColor()),
            .bottomMenuHairlineColor(Themes.sharedInstance.returnThemeColor()),
            .menuItemFont(UIFont(name: Constant.sharedinstance.Medium, size: 14.0)!),
            .menuHeight(60),
            .menuItemWidth(UIScreen.main.bounds.size.width/2-20),
            .centerMenuItems(true),.hideTopMenuBar(false),.selectedMenuItemLabelColor(Themes.sharedInstance.returnThemeColor()),.unselectedMenuItemLabelColor(UIColor.black)
        ]
         pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:header_View.frame.size.height, width:self.view.frame.width, height:self.view.frame.height-header_View.frame.size.height), pageMenuOptions: parameters)
         self.addChildViewController(pageMenu!)
         self.view.addSubview(pageMenu!.view)
        
        LocationService.sharedInstance.delegate = self
        if(Themes.sharedInstance.Getactive_reservation() == "Yes")
        {
            LocationService.sharedInstance.startUpdatingLocation()
        }
        else
        {
            LocationService.sharedInstance.stopUpdatingLocation()
            
        }
//        LocationService.sharedInstance.startUpdatingLocation()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeGround), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)

          // Do any additional setup after loading the view.
    }
    
    @objc func appMovedToForeGround() {
        if(LocationService.sharedInstance.Locstatus == .authorizedWhenInUse || LocationService.sharedInstance.Locstatus == .authorizedWhenInUse)
        {
            self.dismiss(animated: true, completion: {
//                LocationService.sharedInstance.startUpdatingLocation()
                if(Themes.sharedInstance.Getactive_reservation() == "Yes")
                {
                    LocationService.sharedInstance.startUpdatingLocation()
                }
                else
                {
                    LocationService.sharedInstance.stopUpdatingLocation()
                    
                }
            })
            
        }
  }

    @IBAction func DidclickMenu(_ sender: Any) {
      self.findHamburguerViewController()?.showMenuViewController()
     }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}


extension MyreservationVC:LocationServiceDelegate
{
    func tracingLocation(_ currentLocation: CLLocation) {
    }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
    
    func ChangeStatus(_ Locstatus: CLAuthorizationStatus) {
        if(LocationService.sharedInstance.Locstatus == .denied || LocationService.sharedInstance.Locstatus == .restricted)
        {
            let NoLocVC = storyboard?.instantiateViewController(withIdentifier:"NoLocVCID" ) as! NoLocVC
            self.navigationController?.present(NoLocVC, animated: true, completion: nil)
        }
    }
}

