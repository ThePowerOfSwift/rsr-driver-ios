//
//  PaymentVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftValidators

class PaymentVC: UIViewController {
    @IBOutlet var BookBtn: CustomButton!

    @IBOutlet var cvvfld: CustomTextfield!
     @IBOutlet var year_Lbl: CustomTextfield!
    @IBOutlet var month_Lbl: CustomTextfield!
    @IBOutlet var cardno_fld: CustomTextfield!
    @IBOutlet var credit_View: CustomView!
    @IBOutlet var paypalView: CustomView!
    @IBOutlet var paypal_image: UIImageView!
    @IBOutlet var cardimage: UIImageView!
    var Bookrecord:BookRecord = BookRecord()
    var month:String = ""
    var year:String = ""
    var carnumber:String = ""
    
    var extendID:String = String()
    var isFromextend:Bool = Bool()
    var paypalUrl:String = ""



    override func viewDidLoad() {
        super.viewDidLoad()
        credit_View.borderColor = UIColor.lightGray.withAlphaComponent(0.7)
        paypalView.borderColor = UIColor.lightGray.withAlphaComponent(0.7)
        
        credit_View.borderColor = Themes.sharedInstance.returnThemeColor()
        paypalView.borderColor = UIColor.lightGray.withAlphaComponent(0.7)
        cardimage.image = #imageLiteral(resourceName: "cardselect")
        paypalView.layer.borderWidth = 3.0
        cvvfld.delegate = self
        cardno_fld.delegate = self
        cvvfld.doneAccessory = true
        cardno_fld.doneAccessory = true
        if(isFromextend)
        {
            BookBtn.setTitle("Extend with credit card", for: .normal)
            GetData(param:["extend_no":extendID])


        }
        else
        {
            GetData(param:["booking_no":Bookrecord.booking_no])

        }

        // Do any additional setup after loading the view.
    }
    
    func GetData(param:[String:String])
    {
         Themes.sharedInstance.activityView(View: self.view)
        var UrlStr:String = Constant.sharedinstance.payment
        if(isFromextend)
        {
            UrlStr = Constant.sharedinstance.extend_payment
         }
        
        URLhandler.sharedinstance.makeCall(url:UrlStr as String, param: param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
             if(error == nil)
            {
                
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        self.paypalUrl  = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "paypalUrl"))
                        self.GetDetail(responseDict: resDict)
                    }
                    else
                    {
                        
                    }
                    
                }
                
            }
            else
            {
                Themes.sharedInstance.showErrorpopup(Msg: Constant.sharedinstance.errormessage)
            }
        })
    }
    
    func GetDetail(responseDict:NSDictionary?)
    {
        let detailDict:NSDictionary = responseDict?.value(forKey: "car_details") as! NSDictionary
        cardno_fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "cc_no"))
        month_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "cc_exp_date"))
        year_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "cc_exp_year"))
        if(year_Lbl.text?.length == 2)
        {
            year_Lbl.text = "20"+Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "cc_exp_year"))
         }
        
     }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickCreditBtn(_ sender: Any) {
        credit_View.borderColor = Themes.sharedInstance.returnThemeColor()
        paypalView.borderColor = UIColor.lightGray.withAlphaComponent(0.7)
        cardimage.image = #imageLiteral(resourceName: "cardselect")

    }
    @IBAction func DidclickPaypal(_ sender: Any) {
        
        AJAlertController.initialization().showAlert(aStrMessage: "Do you want to continue paying with PayPal ?",
                                                     aCancelBtnTitle: "NO",
                                                     aOtherBtnTitle: "YES")
        { (index, title) in
             if(index == 1)
            {
                 let objVC:DocViewController = self.storyboard?.instantiateViewController(withIdentifier: "DocViewControllerID") as! DocViewController
                objVC.webViewTitle = "Transaction"
                 objVC.webViewURL = self.paypalUrl
                objVC.isFrompayment = true
                objVC.isFromextension = self.isFromextend
                  objVC.Bookrecord = self.Bookrecord
                self.navigationController?.pushViewController(objVC, animated: true)

            }
        }
       }
    @IBAction func DidclickBack(_ sender: Any) {
        AJAlertController.initialization().showAlert(aStrMessage: "Do you wish to cancel the booking?",
                                                     aCancelBtnTitle: "NO",
                                                     aOtherBtnTitle: "YES")
        { (index, title) in
            if(index == 1)
            {
                self.navigationController?.popToRoot(animated: true)

             }
        }
        
     }
    
    @IBAction func DidclickBook(_ sender: Any) {
        if(Validator.isEmpty().apply(cardno_fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly enter the card no")
        }
        else if(!Validator.isCreditCard().apply(cardno_fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly enter the valid card no")

        }
        else if(Validator.isEmpty().apply(month_Lbl.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly choose the month")

        }
        else if(Validator.isEmpty().apply(year_Lbl.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly choose the year")
         }
        else if(Validator.isEmpty().apply(cvvfld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly enter the cvv no")
        }

         else
        {
            if(!isFromextend)
            {
 
            let param:[String : String] = ["booking_no":Bookrecord.booking_no,"card_number":cardno_fld.text!,"expire_month":month_Lbl.text!,"expire_year":year_Lbl.text!,"security_code":cvvfld.text!]
            self.ValidateCard(Param: param)
            }
            else
            {
                let param:[String : String] = ["extend_no":extendID,"card_number":cardno_fld.text!,"expire_month":month_Lbl.text!,"expire_year":year_Lbl.text!,"security_code":cvvfld.text!]
                self.ExtValidateCard(Param: param)

            }
         }

    }
    
    
    
    
    func ExtValidateCard(Param:[String:String])
    {
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.proceed_extend_payment as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        let PaymentSuccessVC = self.storyboard?.instantiateViewController(withIdentifier:"PaymentSuccessVCID" ) as! PaymentSuccessVC
                        PaymentSuccessVC.isFromextend = true
                        PaymentSuccessVC.objbookrecord = self.Bookrecord
                        self.navigationController?.pushViewController(PaymentSuccessVC, animated: true)
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
    

    func ValidateCard(Param:[String:String])
    {
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.proceed_payment as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        let PaymentSuccessVC = self.storyboard?.instantiateViewController(withIdentifier:"PaymentSuccessVCID" ) as! PaymentSuccessVC
                            PaymentSuccessVC.objbookrecord = self.Bookrecord
                         self.navigationController?.pushViewController(PaymentSuccessVC, animated: true)
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
    @IBAction func DidClickYear(_ sender: Any) {
        self.view.endEditing(true)
        let CurrentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let Year = dateFormatter.string(from: CurrentDate)
        var yearNum:Int32 = Int32(Year)!
        var yearArr:[String] = [String]()
        for _ in 0..<100
        {
            yearArr.append("\(yearNum)")
            yearNum = yearNum+1

        }
        
        ActionSheetStringPicker.show(withTitle: "Choose Year", rows: yearArr, initialSelection: 0, doneBlock: {
            picker, value, index in
            self.year_Lbl.text = index as? String
 
              return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)

 
 
     }
    @IBAction func DidclickMonth(_ sender: Any) {
        
        self.view.endEditing(true)

         var monthArr:[String] = [String]()
        for i in 1..<13
        {
            if(i < 10)
            {
            monthArr.append("0\(i)")
            }
            else
            {
                monthArr.append("\(i)")
           }
        }
        
        ActionSheetStringPicker.show(withTitle: "Choose Year", rows: monthArr, initialSelection: 0, doneBlock: {
            picker, value, index in
            self.month_Lbl.text = index as? String
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
 
}
extension PaymentVC:UITextFieldDelegate

{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == cardno_fld)
        {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 16
        }
        else if(textField == cvvfld)
        {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 4

        }
        return true
    }
}
