//
//  Step3VC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class Step3VC: UIViewController {

    @IBOutlet var confrm_Lbl: CustomLabel!
    @IBOutlet var ownername_Lbl: CustomLabel!
    @IBOutlet var carnameLbl: CustomLabel!
    var profReocrd:ProfileRecord = ProfileRecord()
    var objBookRecord:BookRecord = BookRecord()

    override func viewDidLoad() {
        super.viewDidLoad()
        ownername_Lbl.text = "\(profReocrd.firstname) \(profReocrd.lastname)"
        carnameLbl.text = "\(objBookRecord.carname) \(objBookRecord.carmodel) \(objBookRecord.caryear)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickBookNow(_ sender: Any) {
        
        let param:NSDictionary = ["firstname":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.firstname),"lastname":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.lastname),"gender":"","phone_no":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.phone_no),"birthday":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.birthday),"apt_no":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.apt_no),"address":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.address),"zip":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.zip),"licence_number":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.licence_number),"licence_exp_date":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.licence_exp_date),"licence_state":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.state),"carId":objBookRecord.carid,"date_from":objBookRecord.fromdate,"date_to":objBookRecord.todate,"state":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.state),"city":Themes.sharedInstance.CheckNullvalue(Passed_value: profReocrd.city),"deductible":objBookRecord.deductid,"pickup_hour":objBookRecord.pickuptime]
         self.UploadDetail(Param: param)
 
    }
    
    func UploadDetail(Param:NSDictionary)
    {
        
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.proceed_booking as String, param: Param as! [String : String], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        self.objBookRecord.booking_no = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "booking_no"))
                        let PaymentVC = self.storyboard?.instantiateViewController(withIdentifier:"PaymentVCID" ) as! PaymentVC
                          PaymentVC.Bookrecord = self.objBookRecord
                        self.navigationController?.pushViewController(PaymentVC, animated: true)

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
    @IBAction func DidclcikBack(_ sender: Any) {
        self.navigationController?.pop(animated: true)
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
