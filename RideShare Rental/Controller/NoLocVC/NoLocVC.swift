//
//  NoLocVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 26/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class NoLocVC: UIViewController {
    
    @IBOutlet var Detail_Lbl: CustomLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Detail_Lbl.text = "Go to Settings>Privacy>Location Services,and switch \(Themes.sharedInstance.GetAppname()) to on"
        openActSheet()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeGround), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func appMovedToForeGround() {
        if(LocationService.sharedInstance.Locstatus == .authorizedWhenInUse || LocationService.sharedInstance.Locstatus == .authorizedWhenInUse)
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        openActSheet()
     }
    func openActSheet()
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "\(Themes.sharedInstance.GetAppname())", message: "Where are you?", preferredStyle: .actionSheet)
        let saveActionButton = UIAlertAction(title: "Open Settings", style: .default)
        { _ in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
