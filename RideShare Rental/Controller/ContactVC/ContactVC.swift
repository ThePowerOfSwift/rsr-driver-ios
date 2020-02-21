//
//  ContactVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 11/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import SwiftValidators
import ActionSheetPicker_3_0


class ContactVC: UIViewController {
    @IBOutlet var message_Fld: CustomTextfield!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var send_Btn: CustomButton!
    @IBOutlet var date_Fld: CustomTextfield!
    @IBOutlet var year_Fld: CustomTextfield!
    @IBOutlet var model_Fld: CustomTextfield!
    @IBOutlet var make_Fld: CustomTextfield!
    @IBOutlet var phone_Fld: CustomTextfield!
    @IBOutlet var email_Fld: CustomTextfield!
    @IBOutlet var last_Fld: CustomTextfield!
    @IBOutlet var first_Fld: CustomTextfield!
    
    var car_makes:NSArray = NSArray()
    var car_models:NSDictionary = NSDictionary()
    var carFeature:NSMutableArray = NSMutableArray()
    var car_makesval:NSMutableArray = NSMutableArray()
    var car_modelsval:NSMutableArray = NSMutableArray()
    var yearArr:NSMutableArray = NSMutableArray()

    var carmake:String = String()
    var carmodel:String = String()
    


     override func viewDidLoad() {
        super.viewDidLoad()
        
        phone_Fld.doneAccessory = true
        make_Fld.isEnabled = false
        year_Fld.isEnabled = false
        model_Fld.isEnabled = false
        date_Fld.isEnabled = false
        self.GetData()
        
        carmake = ""
        carmodel = ""

         // Do any additional setup after loading the view.
    }
    
    func GetData()
    {
        scrollView.isHidden = true
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.more_filter as String, param: [:], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                self.scrollView.isHidden = false
                
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    
                    self.GetDetail(responseDict: resDict)
                    
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
        carFeature = NSMutableArray()
        yearArr = NSMutableArray()
 
        let car_makeArr = responseDict?.object(forKey: "car_makes") as? [[String:Any]]
        
        if((car_makeArr?.count)! > 0)
        {
            for Dict in car_makeArr!
            {
                car_makesval.add(Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["name"]))
            }
            car_makes = car_makeArr! as NSArray
        }
        
        let car_modelsArr = responseDict?.object(forKey: "car_models") as? NSDictionary
        
        if((car_modelsArr?.count)! > 0)
        {
            car_models = car_modelsArr! as NSDictionary
        }
        
        for i in Int32(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "min_year")))!...Int32(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "max_year")))!
        {
            yearArr.add("\(i)")
        }
    }
    
    
    func Showcarmake(_ sender: Any)
    {
        ActionSheetStringPicker.show(withTitle: "Choose Car make", rows: car_makesval.mutableCopy() as! [Any], initialSelection: 0, doneBlock: {
            picker, value, index in
            self.make_Fld.text = index as? String
            let Dict:NSDictionary = self.car_makes[value] as! NSDictionary
            self.carmake = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "id"))
            let Array:NSArray = self.car_models[self.carmake] as! NSArray
            if(Array.count > 0)
            {
                let Dict:NSDictionary = Array[0] as! NSDictionary
                self.carmodel = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "id"))
                self.model_Fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "name"))

                self.year_Fld.text = self.yearArr[0] as? String

             }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    
    
    func sendDetail(Param:[String:String])
    {
        Themes.sharedInstance.activityView(View: self.view)

         URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.contact_us as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize.height = wrapperView.frame.origin.y+wrapperView.frame.size.height+60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuuact(_ sender: AnyObject) {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    @IBAction func Didclickdate(_ sender: Any) {
        
        
        let datePicker = ActionSheetDatePicker(title: "Choose Pick Up Date", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date:Date = value as! Date
            self.date_Fld.text = dateFormatter.string(from: date)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        
        datePicker?.minimumDate = Date()
        datePicker?.maximumDate = self.generateDates(fromDate:  Date(), value: 30)
        datePicker?.show()

    }
    
    func generateDates(fromDate:Date,value : Int) -> Date {
        
        let today = fromDate
        let tomorrow = Calendar.current.date(byAdding: .year, value: value, to: today)
        
        return tomorrow!
    }
    @IBAction func Didclickyear(_ sender: Any) {
        
        
        if(!Validator.isEmpty().apply(model_Fld.text!) && !(Validator.isEmpty().apply(carmodel)))
        {
            
            ActionSheetStringPicker.show(withTitle: "Choose manufacture year", rows: yearArr.mutableCopy() as! [Any], initialSelection: 0, doneBlock: {
                picker, value, index in
                self.year_Fld.text = index as? String
                 return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
            
        }
        else
        {
            
            Themes.sharedInstance.showErrorpopup(Msg: "Choose car model")
         }
    }
    @IBAction func DidclickSendBtn(_ sender: Any) {
        

        if(Validator.isEmpty().apply(first_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter First name")
            
        }
        else if(Validator.isEmpty().apply(last_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter Last name")
            
        }
            
       else if(Validator.isEmpty().apply(email_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter email id")
            
        }
            
        else if(!Validator.isEmail().apply(email_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter valid email id")
            
        }
        
        else if(Validator.isEmpty().apply(phone_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter phone number")
            
        }
        else if(Validator.maxLength(9).apply(phone_Fld.text) || Validator.minLength(15).apply(phone_Fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter valid phone number")
        }
        
       else if(Validator.isEmpty().apply(make_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Choose car make")
            
        }
       else if(Validator.isEmpty().apply(model_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Choose car model")
            
        }
       else if(Validator.isEmpty().apply(year_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Choose manufacture year")
            
        }
        
        else if(Validator.isEmpty().apply(date_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Choose pick Up Date")
            
        }
        else if(Validator.isEmpty().apply(message_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter message")
            
        }
        else
        {
            let Dict:[String:String] = ["firstname":Themes.sharedInstance.CheckNullvalue(Passed_value: first_Fld.text!),"lastname":Themes.sharedInstance.CheckNullvalue(Passed_value: last_Fld.text!),"email":Themes.sharedInstance.CheckNullvalue(Passed_value: email_Fld.text!),"make":Themes.sharedInstance.CheckNullvalue(Passed_value:carmake),"model":Themes.sharedInstance.CheckNullvalue(Passed_value: carmodel),"year":Themes.sharedInstance.CheckNullvalue(Passed_value: year_Fld.text!),"pick_up_date":Themes.sharedInstance.CheckNullvalue(Passed_value: date_Fld.text!),"phone_no":Themes.sharedInstance.CheckNullvalue(Passed_value: phone_Fld.text!),"message":Themes.sharedInstance.CheckNullvalue(Passed_value: message_Fld.text!)]
            
            self.sendDetail(Param: Dict)
 
        }
    }
    
    @IBAction func DidclickModel(_ sender: Any) {
        
        if(!Validator.isEmpty().apply(make_Fld.text!) && !(Validator.isEmpty().apply(carmake)))
        {
            car_modelsval.removeAllObjects()
            let Array:NSArray = car_models[carmake] as! NSArray
            
            if(Array.count > 0)
            {
                for i in 0..<Array.count
                {
                    let Dict:NSDictionary =  Array[i] as! NSDictionary
                    car_modelsval.add(Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["name"]))
                }
            }
            
            ActionSheetStringPicker.show(withTitle: "Choose Car model", rows: car_modelsval.mutableCopy() as! [Any], initialSelection: 0, doneBlock: {
                picker, value, index in
                self.model_Fld.text = index as? String
                let Dict:NSDictionary = Array[value] as! NSDictionary
                self.carmodel = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "id"))
                return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
            
        }
        else
        {
            Showcarmake(sender)
        }
    }
    @IBAction func Didclickmake(_ sender: Any) {
        
        self.Showcarmake(sender)
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
