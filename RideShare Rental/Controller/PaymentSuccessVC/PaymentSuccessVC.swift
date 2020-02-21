//
//  PaymentSuccessVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class PaymentSuccessVC: UIViewController {
    var status:String = String()
    var Appdel=UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var statusIcon: UIImageView!
    @IBOutlet var detail_Lbl: CustomLabel!
    @IBOutlet var status_Lbl: CustomLabel!
    @IBOutlet var wrapperView: CustomView!
    @IBOutlet var totalAmt: CustomLabel!
    var isFromextend:Bool = Bool()
    var objbookrecord:BookRecord = BookRecord()
      override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
        totalAmt.text = "\(Themes.sharedInstance.Getcurrency()) \(objbookrecord.total_amount)"
        
    }
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclcikBack(_ sender: Any) {
        if(!isFromextend)
        {
        self.navigationController?.popToRoot(animated: true)
        }
        else
        {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "MyreservationVCID")
        }
    }
    @IBAction func DidclickDone(_ sender: Any) {
        Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "MyreservationVCID")
 
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
