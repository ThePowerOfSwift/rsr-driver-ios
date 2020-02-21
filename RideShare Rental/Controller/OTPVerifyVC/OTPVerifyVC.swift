//
//  OTPVerifyVC.swift
//  RideShare Rental
//
//  Created by CasperoniOS on 10/01/19.
//  Copyright © 2019 RideShare Rental. All rights reserved.
//

import UIKit
import PinCodeTextField
import SwiftValidators
protocol OTPVerifyVCDelegate {
    func reloaddata()
}
class OTPVerifyVC: UIViewController,SearchDelegate {

    @IBOutlet var otpwrapperView: UIView!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var pinFld: PinCodeTextField!
    @IBOutlet var countryCodeBtn: CustomButton!
    @IBOutlet var phonenumFld: CustomTextfield!
    @IBOutlet var mobwrapperView: UIView!
    var country_Code:String = String()
    var OTP:String = String()
    var delegate:OTPVerifyVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        pinFld.keyboardType = .numberPad
       }
    
    func setData()
    {
        phonenumFld.text = Themes.sharedInstance.GetPhone()
        countryCodeBtn.setTitle(Themes.sharedInstance.Getcountry(), for: .normal)
        country_Code = Themes.sharedInstance.Getcountry()
        otpwrapperView.isHidden = true
        if(country_Code.count == 0)
        {
            country_Code="+1"
            countryCodeBtn.setTitle("\(country_Code)", for: .normal)
         }
     }
    
    
    func didSelectLocation(countryName: String, countryCode: String) {
        print(countryName)
        print(countryCode)
        country_Code = countryCode
        countryCodeBtn.setTitle(countryCode, for: UIControlState.normal)
    }

     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mobwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in
            self.mobwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
                self.mobwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
                    self.mobwrapperView.transform = .identity
                })
            })
        })
    }
    
    func ShowOTPView()
    {
    otpwrapperView.isHidden = false
    otpwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
    UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in
    self.otpwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
    }, completion: {(_ finished: Bool) -> Void in
    UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
    self.otpwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
    }, completion: {(_ finished: Bool) -> Void in
    UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
    self.otpwrapperView.transform = .identity
    })
    })
    })
    }
    
    func DismissView()
    {
        self.mobwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in
            self.mobwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            
        }, completion: {(_ finished: Bool) -> Void in
            
            self.navigationController?.dismiss(animated:false, completion: nil)
            
            
        })
    }
    
    func DismissOTPView()
    {
        self.otpwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in
            self.otpwrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            
        }, completion: {(_ finished: Bool) -> Void in
            
            self.otpwrapperView.isHidden = true
            
        })
    }
    
     func SendOTP(param:[String:String],url:String)
    {
        Themes.sharedInstance.activityView(View: self.view)
        
        URLhandler.sharedinstance.makeCall(url:url, param: param, completionHandler: {(responseObject, error) ->  () in
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

                        self.OTP = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "mobile_verification_code"))
                        if(self.otpwrapperView.isHidden)
                        {
                            self.ShowOTPView()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                                self.pinFld.becomeFirstResponder()
                            })
                        }
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
    @IBAction func didclickresend(_ sender: Any) {
        let param:[String:String] = ["ph_country":country_Code,"phone_no":phonenumFld.text!]
        self.SendOTP(param: param,url:Constant.sharedinstance.resend_verification_message as String)

    }
    func VerifyOTP(param:[String:String],url:String)
    {
        Themes.sharedInstance.activityView(View: self.view)
        
        URLhandler.sharedinstance.makeCall(url:url, param: param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        Themes.sharedInstance.SavePhone(str: self.phonenumFld.text!)
                        Themes.sharedInstance.Savecountry(str: self.country_Code)
                        Themes.sharedInstance.Savephone_verified(str: "Yes")
                        Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "msg")), isSuccess: false)
                        self.delegate?.reloaddata()
                        self.DismissView()

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
    @IBAction func didclickOTPClose(_ sender: Any) {
        DismissOTPView()
     }
    @IBAction func didclickMobClose(_ sender: Any) {
        self.DismissView()
    }
    @IBAction func didclickverifySMS(_ sender: Any) {
        
        if(Validator.isEmpty().apply(phonenumFld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter Phone number")
        }
        else
        {
            let param:[String:String] = ["ph_country":country_Code,"phone_no":phonenumFld.text!]
            self.SendOTP(param: param,url:Constant.sharedinstance.send_verification_message as String)
         }
        

    }
    @IBAction func didclickverify(_ sender: Any) {
        
        if(pinFld.text != OTP)
        {
            Themes.sharedInstance.showErrorpopup(Msg: "OTP doesn't match")
        }
        else
        {
            let param:[String:String] = ["mobile_verification_code":pinFld.text!]
            self.VerifyOTP(param: param, url: Constant.sharedinstance.verify_mobile)
        }

     }
    @IBAction func didclickcountryCode(_ sender: Any) {
        let changeNoVC = storyboard?.instantiateViewController(withIdentifier:"SearchBarViewController" ) as! SearchBarViewController
        changeNoVC.delegate = self
        self.navigationController?.pushViewController(changeNoVC, animated: true)

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
