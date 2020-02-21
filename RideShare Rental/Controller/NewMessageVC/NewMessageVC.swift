//
//  NewMessageVC.swift
//  RideShare Rental
//
//  Created by CasperoniOS on 10/01/19.
//  Copyright © 2019 RideShare Rental. All rights reserved.
//

import UIKit
import SwiftValidators
import ActionSheetPicker_3_0

protocol  NewMessageVCDelegate{
    func Updatemessage()
}
class NewMessageVC: UIViewController {
    @IBOutlet var driverView: CustomView!

    @IBOutlet var messageFld: CustomTextfield!
    @IBOutlet var subFld: CustomTextfield!
    @IBOutlet var driverFld: CustomTextfield!
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var headerLbl: CustomLabel!
    
    var delegate:NewMessageVCDelegate?
    
    var isfromAdmin:Bool = Bool()
    var isfromowner:Bool = Bool()

    var driverArr:NSMutableArray = NSMutableArray()
    var driverid:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isfromAdmin)
        {
            driverView.isHidden = true
            headerLbl.text = "Start Conversation with Admin"
        }

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        if(isfromAdmin)
        {
            messageFld.frame.origin.y =  messageFld.frame.origin.y - 30
            subFld.frame.origin.y =  subFld.frame.origin.y - 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in
            self.wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
                self.wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
                    self.wrapperView.transform = .identity
                })
            })
        })
    }
    @IBAction func didclicksubmit(_ sender: Any) {
        if(isfromowner)
        {
            if(Validator.isEmpty().apply(driverFld.text!))
            {
                Themes.sharedInstance.showErrorpopup(Msg: "Choose the driver name")
                
            }
            else if(Validator.isEmpty().apply(subFld.text!))
            {
                Themes.sharedInstance.showErrorpopup(Msg: "Enter the subject")
                
            }
            else if(Validator.isEmpty().apply(messageFld.text!))
            {
                Themes.sharedInstance.showErrorpopup(Msg: "Enter the message")
                
            }
            else
            {
                let param:[String : String] = ["subject":subFld.text!,"message":messageFld.text!,"receiverId":self.driverid]
                self.Updatemessage(Param: param)

            }
            

        }
        else
        {
             if(Validator.isEmpty().apply(subFld.text!))
            {
                Themes.sharedInstance.showErrorpopup(Msg: "Enter the subject")
                
            }
            else if(Validator.isEmpty().apply(messageFld.text!))
            {
                Themes.sharedInstance.showErrorpopup(Msg: "Enter the message")
                
            }
             else
             {
            let param:[String : String] = ["subject":subFld.text!,"message":messageFld.text!]
            self.Updatemessage(Param: param)
            }

        }
        
      
    }
    
    
    func Updatemessage(Param:[String:String])
    {
        
        
        var url = ""
        if(isfromAdmin)
        {
            url =  Constant.sharedinstance.start_new_direct_admin_conversation as String
         }
        if(isfromowner)
        {
            url =  Constant.sharedinstance.start_new_direct_conversation as String
          }
        Themes.sharedInstance.activityView(View: self.view)
         URLhandler.sharedinstance.makeCall(url:url, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
             if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: "Successfully Updated" , isSuccess: true)
                        self.DismissView()
                        self.delegate?.Updatemessage()

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
    
    func DismissView()
    {
        self.wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in
            self.wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            
        }, completion: {(_ finished: Bool) -> Void in
            
            self.dismiss(animated:false, completion: nil)
            
            
        })
    }
    
    @IBAction func didclickClose(_ sender: Any) {
        DismissView()
    }
    @IBAction func didclickdriver(_ sender: Any) {
        
        var drivername:[String] = [String]()
        if((driverArr.count) > 0)
        {
            for i in 0..<driverArr.count
            {
                let dict = driverArr[i] as! NSDictionary
                drivername.append(Themes.sharedInstance.CheckNullvalue(Passed_value: dict["name"] as! String))

             }
 
            ActionSheetStringPicker.show(withTitle: "Choose Car make", rows: drivername, initialSelection: 0, doneBlock: {
                picker, value, index in
                self.driverFld.text = index as? String
                let Dict:NSDictionary = self.driverArr[value] as! NSDictionary
                self.driverid = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "id"))
                
                return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
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
