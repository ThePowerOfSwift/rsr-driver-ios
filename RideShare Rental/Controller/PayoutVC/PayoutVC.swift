//
//  PayoutVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 14/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import SwiftValidators

class PayoutVC: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
 
    @IBOutlet var editBtn: CustomButton!
    @IBOutlet var BtnwrapperView: UIView!
    @IBOutlet var submit_Btn: CustomButton!

    @IBOutlet var nameFld: CustomTextfield!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Themes.sharedInstance.GetpaypalID() != "")
        {
        nameFld.text = Themes.sharedInstance.GetpaypalID()
        BtnwrapperView.isHidden = true
        editBtn.isHidden = false
        nameFld.isEnabled = false
        nameFld.layer.borderWidth = 0.0
        }
        else if(Themes.sharedInstance.Getemail() != "")
        {
            nameFld.text = Themes.sharedInstance.Getemail()
            BtnwrapperView.isHidden = true
            editBtn.isHidden = false
            nameFld.isEnabled = false
            nameFld.layer.borderWidth = 0.0

        }
        else
        {
            BtnwrapperView.isHidden = false
            editBtn.isHidden = true
            nameFld.isEnabled = true
            nameFld.layer.borderWidth = 1.0
        }
         // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
    scrollView.contentSize.height = submit_Btn.frame.origin.y+submit_Btn.frame.size.height+40
    }
    
    @IBAction func Didclickcancel(_ sender: Any) {
        BtnwrapperView.isHidden = true
        editBtn.isHidden = false
        nameFld.isEnabled = false
        nameFld.layer.borderWidth = 0.0

     }
    @IBAction func DidclickEdit(_ sender: Any)
    {
        BtnwrapperView.isHidden = false
        editBtn.isHidden = true
        nameFld.isEnabled = true
        nameFld.becomeFirstResponder()
        nameFld.layer.borderWidth = 1.0
     }
    

    @IBAction func Didclickupdate(_ sender: Any) {
        
          if(Validator.isEmpty().apply(nameFld.text!))
         {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter email id")
         }
        else if(!Validator.isEmail().apply(nameFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter valid email id")
        }
        else
        {
            self.view.endEditing(true)
            let Dict:[String:String] = ["amb_paypal_id":Themes.sharedInstance.CheckNullvalue(Passed_value:nameFld.text!)]
                
                self.sendDetail(Param: Dict)
        }
     }
    
    func sendDetail(Param:[String:String])
    {
        Themes.sharedInstance.activityView(View: self.view)
        
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.save_amb_paypal_id as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        Themes.sharedInstance.shownotificationBanner(Msg: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "msg")))
                        Themes.sharedInstance.savePaypalid(user_id: self.nameFld.text!)
                        self.BtnwrapperView.isHidden = true
                        self.editBtn.isHidden = false
                        self.nameFld.isEnabled = false
                        self.nameFld.layer.borderWidth = 0.0

                    }
                    else
                    {
                        Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "msg")), isSuccess: false)
                    }
                }
            }
            else
            {
                Themes.sharedInstance.showErrorpopup(Msg: Constant.sharedinstance.errormessage)
            }
        })
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
