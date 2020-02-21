//
//  ChangepasswordVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 08/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import SwiftValidators

class ChangepasswordVC: UIViewController {

    @IBOutlet var retype_pass: CustomTextfield!
    @IBOutlet var new_pass: CustomTextfield!
    @IBOutlet var current_pass: CustomTextfield!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuuact(_ sender: AnyObject) {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    @IBAction func DidclickNewpass(_ sender: Any) {
        if(Validator.isEmpty().apply(current_pass.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the current password")
            
        }
       else if(Validator.isEmpty().apply(new_pass.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the new password")
            
        }
        else if(Validator.isEmpty().apply(retype_pass.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "retype your new password")
         }
        else if(retype_pass.text != new_pass.text)
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Password doesn't match")
        }
         else
        {
             self.view.endEditing(true)
            let param:NSDictionary = ["password":current_pass.text!,"new_password":retype_pass.text!]
            self.UploadDetail(Param: param)
        }
    }
    
    func UploadDetail(Param:NSDictionary)
    {
        
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.change_password as String, param: Param as! [String : String], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        self.current_pass.text = ""
                        self.retype_pass.text  = ""
                        self.new_pass.text  = ""
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
