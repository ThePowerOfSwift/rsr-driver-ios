//
//  SigninVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 05/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import SwiftValidators
import TPKeyboardAvoiding

class SigninVC: UIViewController {
 
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet var login_Btn: TKTransitionSubmitButton!
    @IBOutlet var password_fld: CustomTextfield!
    @IBOutlet var email_fld: CustomTextfield!
    @IBOutlet var header_lbl: CustomLabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        login_Btn.backgroundColor = Themes.sharedInstance.returnThemeColor()
        login_Btn.layer.cornerRadius = 3.0
        login_Btn.clipsToBounds = true;
         Setdata()

    }
    override func viewDidLayoutSubviews() {
        scrollView.contentSize.height = wrapperView.frame.origin.y +  wrapperView.frame.size.height
    }
    
    func Setdata()
    {
        header_lbl.textColor = UIColor.black
        header_lbl.attributedText = Themes.sharedInstance.ReturnAttributedText(color: Themes.sharedInstance.returnThemeColor(), mainText: "Login to Ride Share Rental", attributeText: "Login to")
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    @IBAction func DidclickLogin(_ sender: Any) {
   if(Validator.isEmpty().apply(email_fld.text!))
       {
        Themes.sharedInstance.showErrorpopup(Msg: "Enter the email")
      }
      else  if(!Validator.isEmail().apply(email_fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter a valid email id")
        }
        else if(Validator.isEmpty().apply(password_fld.text!))
      {
        Themes.sharedInstance.showErrorpopup(Msg: "Enter the password")
      }
        else
        {
            self.view.endEditing(true)
            let loginParam:[String:String] = ["email":Themes.sharedInstance.CheckNullvalue(Passed_value:email_fld.text!),"password":Themes.sharedInstance.CheckNullvalue(Passed_value:password_fld.text!)]
            self.Login(Param: loginParam)
    
        }
      
    }
    
    @IBAction func Didclickback(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
 
    @IBAction func DidclickForgot_password(_ sender: Any) {
        let objResetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVCID") as! ResetPasswordVC
        self.navigationController?.pushViewController(objResetPasswordVC, animated: true)
     }
   func MovetoHome()
    {
        self.login_Btn.startLoadingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.login_Btn.startFinishAnimation(0.5, completion: {
                
                
                if(Themes.sharedInstance.Getactive_reservation() == "Yes")
                {
                    (UIApplication.shared.delegate as! AppDelegate).Make_RootVc("DLDemoRootViewController", RootStr: "MyreservationVCID")

                }
                else
                {
                (UIApplication.shared.delegate as! AppDelegate).Make_RootVc("DLDemoRootViewController", RootStr: "HomeVCID")
                }
              })
        }
    }
    
    func SaveDetails(responseObject:NSDictionary?)
    {
        let CommDict:NSDictionary = responseObject?.value(forKey: "commonArr") as! NSDictionary
         Themes.sharedInstance.saveSign(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "signature_image")))

        Themes.sharedInstance.saveSign(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "signature_image")))
         Themes.sharedInstance.Saveuser_id(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "commonId")))
        Themes.sharedInstance.Savecurrency(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "currencySymbol")))
        Themes.sharedInstance.Saveemail(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "email")))
        Themes.sharedInstance.Saveprofile_pic(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "profile_pic")))
        Themes.sharedInstance.Saveverified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "verified")))
        Themes.sharedInstance.SavemessageCount(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "unread_message_count")))
        Themes.sharedInstance.SaveReservationStatus(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "active_reservation")))
        Themes.sharedInstance.Saveemail_verified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "email_verified")))
         Themes.sharedInstance.Savephone_verified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "ph_verified")))
         Themes.sharedInstance.SavePhone(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "phone_no")))
        Themes.sharedInstance.Savecountry(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "ph_country")))

        self.MovetoHome()
    }
    
      func Login(Param:[String:String])
     {
        Themes.sharedInstance.activityView(View: self.view)
        
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.login as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        self.SaveDetails(responseObject: responseObject)
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
