//
//  SignUpVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 05/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import GoogleSignIn

import NVActivityIndicatorView
import SwiftValidators

class SignUpVC: UIViewController,SearchDelegate {
    @IBOutlet var firstname_fld: CustomTextfield!
    @IBOutlet var lastname_fld: CustomTextfield!
    @IBOutlet var phonenumber_fld: CustomTextfield!
    @IBOutlet var email_fld: CustomTextfield!
    @IBOutlet var code_Btn: UIButton!
    @IBOutlet var ref_code: CustomTextfield!
    @IBOutlet var bottom_View: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var password_fld: CustomTextfield!
    @IBOutlet var privacy_Lbl: TTTAttributedLabel!
    @IBOutlet var header_Lbl: CustomLabel!
    @IBOutlet var SigninBtn: TKTransitionSubmitButton!
 
    
    @IBOutlet var confirm_password: CustomTextfield!
    var country_Code:String = String()
    var CodeStr:String=String()

    override func viewDidLoad() {
        super.viewDidLoad()
        Setdata()
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
         SigninBtn.backgroundColor = Themes.sharedInstance.returnThemeColor()
        SigninBtn.layer.cornerRadius = 3.0
        SigninBtn.clipsToBounds = true;
        phonenumber_fld.doneAccessory = true
     }
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer)
      {
      }
     func Setdata()
     {
        header_Lbl.textColor = UIColor.black
        header_Lbl.attributedText = Themes.sharedInstance.ReturnAttributedText(color: Themes.sharedInstance.returnThemeColor(), mainText: "Sign up your new account", attributeText: "Sign up")
        privacy_Lbl.attributedText = Themes.sharedInstance.ReturnAttributedText(color: Themes.sharedInstance.returnThemeColor(), mainText: "I Agree To Accept Terms of Service & Privacy Policy", attributeText: "Terms of Service & Privacy Policy")
        privacy_Lbl.font = UIFont(name: Constant.sharedinstance.Regular, size: privacy_Lbl.font.pointSize+2)
        privacy_Lbl.text = "I Agree To Accept Terms of Service & Privacy Policy"
        privacy_Lbl.delegate = self
        let range: Range? = (privacy_Lbl.text as! String).range(of: "Terms of Service")
        let mofiedrange:NSRange = (((privacy_Lbl.text as? String) ?? "").nsRange(from: range!))!
        privacy_Lbl.addLink(to: URL(string: "\(BaseUrl)company/terms-conditions"), with: mofiedrange)
        let privacyrange: Range? = ((privacy_Lbl.text as? String) ?? "").range(of: "Privacy Policy")
        let privacymofiedrange:NSRange = (((privacy_Lbl.text as? String) ?? "").nsRange(from: privacyrange!))!
        
         privacy_Lbl.addLink(to: URL(string: "\(BaseUrl)company/privacy-policy"), with: privacymofiedrange)
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            country_Code = countryCode
            let Code:NSArray=Themes.sharedInstance.getCountryList().object(forKey: country_Code as String) as! NSArray
            if(Code.count > 0)
            {
                CodeStr="+1"
                code_Btn.setTitle("\(CodeStr)", for: .normal)
                country_Code = "\(CodeStr)"
            }
            else
            {
                CodeStr="";
                code_Btn.setTitle("+", for: .normal)
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func DidclickSignup(_ sender: Any) {
        
        if(Validator.isEmpty().apply(firstname_fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter First name")
            
        }
        else if(Validator.isEmpty().apply(lastname_fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter Last name")

        }
        else if(Validator.isEmpty().apply(email_fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter email name")

        }
        else if(!Validator.isEmail().apply(email_fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter valid email id")
        }
        else if(Validator.isEmpty().apply(password_fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter password")
        }
        else if(Validator.isEmpty().apply(confirm_password.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter confirm password")
        }
        else if(confirm_password.text != password_fld.text)
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Password doesn't match")
        }
         else if(Validator.isEmpty().apply(phonenumber_fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter Phone number")
         }
         else if(Validator.maxLength(9).apply(phonenumber_fld.text) || Validator.minLength(15).apply(phonenumber_fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter valid phone number")
        }
       
        else
         {
            self.view.endEditing(true)
            let ProfRecord:ProfileRecord = ProfileRecord()
            ProfRecord.firstname = Themes.sharedInstance.CheckNullvalue(Passed_value: firstname_fld.text!)
            ProfRecord.lastname = Themes.sharedInstance.CheckNullvalue(Passed_value: lastname_fld.text!)
            
            ProfRecord.password = Themes.sharedInstance.CheckNullvalue(Passed_value: password_fld.text!)

            ProfRecord.email = Themes.sharedInstance.CheckNullvalue(Passed_value: email_fld.text!)
            
            ProfRecord.phone_no = Themes.sharedInstance.CheckNullvalue(Passed_value: email_fld.text!)
            ProfRecord.ph_country = Themes.sharedInstance.CheckNullvalue(Passed_value:
              "\(CodeStr)")
            ProfRecord.phone_no = Themes.sharedInstance.CheckNullvalue(Passed_value: phonenumber_fld.text!)
             ProfRecord.referral_code = Themes.sharedInstance.CheckNullvalue(Passed_value: ref_code.text!)
            let param:[String:String] = ["email":ProfRecord.email,"ph_country":ProfRecord.ph_country,"phone_no":ProfRecord.phone_no]
            self.SendOTP(param: param,ProfRecord:ProfRecord)

         }
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
                        let OTPVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPVCID") as! OTPVC
                        OTPVC.mode = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "mode"))
                        OTPVC.mobile_verification_code = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "mobile_verification_code"))
                        OTPVC.ProfRecord = ProfRecord
                        if(OTPVC.mode == "development")
                        {
                           OTPVC.phoneVerified = "No"
                        }
                        else
                        {
                            OTPVC.phoneVerified = "Yes"

                        }

                        self.navigationController?.pushViewController(OTPVC, animated: true)
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
    @IBAction func DidclickBack(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    @IBAction func Didclickfb(_ sender: Any) {
      
    }
    
    @IBAction func DidclickCountryCode(_ sender: Any) {
        let changeNoVC = storyboard?.instantiateViewController(withIdentifier:"SearchBarViewController" ) as! SearchBarViewController
        changeNoVC.delegate = self
        self.navigationController?.pushViewController(changeNoVC, animated: true)
     }
    
    func didSelectLocation(countryName: String, countryCode: String) {
        print(countryName)
        print(countryCode)
        CodeStr = countryCode
       code_Btn.setTitle(countryCode, for: UIControlState.normal)
     }
    
    @IBAction func DidclickGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()

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
        Themes.sharedInstance.SaveReservationStatus(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "active_reservation")))
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SignUpVC: TTTAttributedLabelDelegate
{
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
    }
}
extension SignUpVC:GIDSignInDelegate,GIDSignInUIDelegate

{
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
             let fullName = Themes.sharedInstance.CheckNullvalue(Passed_value: user.profile.name)
             let email = Themes.sharedInstance.CheckNullvalue(Passed_value: user.profile.email)
             let URl = Themes.sharedInstance.CheckNullvalue(Passed_value: user.profile.imageURL(withDimension: 150).absoluteString)
            
            // let email = user.profile.email
             let loginParam:[String:String] = ["login_type":"google","facebookId":"","googleImage":URl,"firstname":fullName,"lastname":"","email":email,"password":"","deviceToken":Themes.sharedInstance.getDeviceToken(),"mobile_key":"iOS"]
            Login(Param: loginParam)
            // ...
        } else {
        }
    }
}

