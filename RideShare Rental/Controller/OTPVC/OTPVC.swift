//
//  OTPVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 24/01/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import PinCodeTextField

class OTPVC: UIViewController {
    
    @IBOutlet var pinFld: PinCodeTextField!
    @IBOutlet var SigninBtn: TKTransitionSubmitButton!
    var ProfRecord:ProfileRecord = ProfileRecord()
    
    var phoneVerified:String = String()
    var mode:String = String()
    var mobile_verification_code:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        SigninBtn.addTarget(self, action: #selector(self.DidclickSignup(_:)), for: .touchUpInside)
        pinFld.keyboardType = .numberPad
        if(mode == "development")
        {
            pinFld.text = mobile_verification_code
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didclickresend(_ sender: Any) {
        let param:[String:String] = ["email":ProfRecord.email,"ph_country":ProfRecord.ph_country,"phone_no":ProfRecord.phone_no]
        self.SendOTP(param: param,ProfRecord:ProfRecord)
    }
    
    func SendOTP(param:[String:String],ProfRecord:ProfileRecord)
    {
        Themes.sharedInstance.activityView(View: self.view)
        
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.sent_otp as String, param: param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        self.mobile_verification_code = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "mobile_verification_code"))

                        Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "msg")), isSuccess: false)

 
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
    
    @IBAction func Didclickback(_ sender: Any) {
        self.navigationController?.pop(animated: true)

    }
    @IBAction func DidclickSignup(_ sender: Any) {
        
        if(pinFld.text != mobile_verification_code)
        {
            Themes.sharedInstance.showErrorpopup(Msg: "OTP doesn't match")
        }
        else
        {
            let loginParam:[String:String] = ["login_type":"email","facebookId":"","googleImage":"","firstname":ProfRecord.firstname,"lastname":ProfRecord.lastname,"email":ProfRecord.email,"password":ProfRecord.password,"deviceToken":Themes.sharedInstance.getDeviceToken(),"mobile_key":"iOS","ph_country":ProfRecord.ph_country,"phone_no":ProfRecord.phone_no,"ph_verified":phoneVerified,"referral_code":ProfRecord.referral_code]
            
          Login(Param: loginParam)
        }

    }
    func Login(Param:[String:String])
    {
        Themes.sharedInstance.activityView(View: self.view)
        
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.Register as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
    
    func SaveDetails(responseObject:NSDictionary?)
    {
        let CommDict:NSDictionary = responseObject?.value(forKey: "commonArr") as! NSDictionary
        Themes.sharedInstance.saveSign(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "signature_image")))

        Themes.sharedInstance.Saveuser_id(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "commonId")))
        Themes.sharedInstance.Savecurrency(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "currencySymbol")))
        Themes.sharedInstance.Saveemail(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "email")))
        Themes.sharedInstance.Saveemail_verified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "email_verified")))
        Themes.sharedInstance.Saveprofile_pic(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "profile_pic")))
        Themes.sharedInstance.Saveverified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "verified")))
        Themes.sharedInstance.SavemessageCount(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "unread_message_count")))
         Themes.sharedInstance.Savephone_verified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "ph_verified")))
         Themes.sharedInstance.SavePhone(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "phone_no")))
        Themes.sharedInstance.Savecountry(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "ph_country")))


        self.MovetoHome()
    }
    func MovetoHome()
    {
        self.SigninBtn.startLoadingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.SigninBtn.startFinishAnimation(0.1, completion: {
                
                
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
