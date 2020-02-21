//
//  ResetPasswordVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 08/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import SwiftValidators


class ResetPasswordVC: UIViewController {

    @IBOutlet var header_lbl: CustomLabel!
    @IBOutlet var submit_Btn: CustomButton!
    @IBOutlet var email_Fld: CustomTextfield!
    @IBOutlet var header_Lbl: CustomLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Setdata()
        // Do any additional setup after loading the view.
    }
    func Setdata()
    {
        header_lbl.textColor = UIColor.black
        header_lbl.attributedText = Themes.sharedInstance.ReturnAttributedText(color: Themes.sharedInstance.returnThemeColor(), mainText: "Reset your Password", attributeText: "Reset your")
    }

    @IBAction func Didclickback(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidCliCkSubmit(_ sender: Any) {
          if(Validator.isEmpty().apply(email_Fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter email id")
            
        }
        else if(!Validator.isEmail().apply(email_Fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter valid email id")
        }
        else
          {
            self.view.endEditing(true)
            let param:NSDictionary = ["email":email_Fld.text!]
            self.UploadDetail(Param: param)
        }
    }
    
    func UploadDetail(Param:NSDictionary)
    {
        
        Themes.sharedInstance.activityView(View: self.view)
         URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.reset_password as String, param: Param as! [String : String], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "msg")), isSuccess: true)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
