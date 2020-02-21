//
//  AddCardVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 15/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SwiftValidators
import ActionSheetPicker_3_0


class AddCardVC: UIViewController {

    @IBOutlet var cvv: CustomTextfield!
    @IBOutlet var terms_Lbl: TTTAttributedLabel!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var bottom_View: UIView!
    @IBOutlet var check_Btn: UIButton!
     @IBOutlet var name_Fld: CustomTextfield!
    @IBOutlet var year_Lbl: CustomTextfield!
    @IBOutlet var month_Lbl: CustomTextfield!
    @IBOutlet var CardFld: CustomTextfield!
    
    var isAccept:Bool = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
         CardFld.doneAccessory = true
        GetData()
        CardFld.delegate = self
        
         terms_Lbl.font = UIFont(name: Constant.sharedinstance.Regular, size: terms_Lbl.font.pointSize+1)
        terms_Lbl.text = "I Accept Payment Terms of Service"
        terms_Lbl.delegate = self
        let range: Range? = (terms_Lbl.text as! String).range(of: "Terms of Service")
        let mofiedrange:NSRange = ((terms_Lbl.text as! String).nsRange(from: range!))!
        terms_Lbl.addLink(to: URL(string: "\(BaseUrl)company/terms-conditions"), with: mofiedrange)

    // Do any additional setup after loading the view.
    }
    func GetData()
    {
        scrollView.isHidden = true
        Themes.sharedInstance.activityView(View: self.view)
        
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.card_details as String, param: [:], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            self.scrollView.isHidden = false
             if(error == nil)
            {
                
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
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
        CardFld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "cc_no"))
         month_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "cc_exp_date"))
        year_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "cc_exp_year"))
        name_Fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "cc_holder_name"))
        
        if(year_Lbl.text?.length == 2)
        {
            year_Lbl.text = "20"+Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "cc_exp_year"))

        }
 
    }
    override func viewDidLayoutSubviews() {
        scrollView.contentSize.height = bottom_View.frame.origin.y+bottom_View.frame.size.height-60
        
    }
    @IBAction func DidclickMenu(_ sender: Any) {
        self.findHamburguerViewController()?.showMenuViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func DidclickYear(_ sender: Any) {
        
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
    @IBAction func DidclickCheckBtn(_ sender: Any) {
        
        isAccept = !isAccept
        check_Btn.setImage(isAccept == true ? #imageLiteral(resourceName: "check"):#imageLiteral(resourceName: "uncheck"), for: .normal)
    }
    
    @IBAction func DidclickAddCard(_ sender: Any) {
        if(Validator.isEmpty().apply(CardFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly enter the card no")
        }
        else if(!Validator.isCreditCard().apply(CardFld.text!))
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
            
        else if(Validator.isEmpty().apply(name_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly enter the card holder name")
        }
        
       else if(!isAccept)
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly accept the terms of service")

        }
        else
        {
            
 
            let param:[String : String] = ["cc_no":CardFld.text!,"cc_exp_date":month_Lbl.text!,"cc_exp_year":year_Lbl.text!,"cc_holder_name":name_Fld.text!]
            self.addcard(Param: param)

        }
    }
    
    func addcard(Param:[String:String])
    {
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.add_card_details as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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

extension AddCardVC: TTTAttributedLabelDelegate
{
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
    }
}

extension AddCardVC:UITextFieldDelegate
    
{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == CardFld)
        {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 16
        }
        
        return true
    }
}
