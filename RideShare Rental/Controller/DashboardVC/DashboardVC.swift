//
//  DashboardVC.swift
//  RideShare Rental
//
//  Created by CasperoniOS on 10/01/19.
//  Copyright © 2019 RideShare Rental. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet var phonenum: CustomLabel!
    @IBOutlet var emailattrLbl: TTTAttributedLabel!
    @IBOutlet var emailadd: CustomLabel!
    @IBOutlet var name: CustomLabel!
    var nameStr:String = String()
    var phoneNo:String = ""
    var countryCode:String = ""
    @IBOutlet var profile_img: CustomimageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GetData()

    }
    func GetData()
    {
         Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.profile as String, param: [:], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                 let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    let CommDict:NSDictionary = responseObject?.value(forKey: "commonArr") as! NSDictionary
                    Themes.sharedInstance.Saveemail_verified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "email_verified")))
                     Themes.sharedInstance.Savephone_verified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "ph_verified")))
                      if(status == "1")
                    {
                        
                        self.GetDetail(responseDict: resDict)
                        self.Setdata()
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
    
    func GetDetail(responseDict:NSDictionary?)
    {
        let detailDict:NSDictionary = responseDict?.value(forKey: "driverDetails") as! NSDictionary

        

         nameStr  = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "firstname")) + " " + Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "lastname"))
         phoneNo = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "phone_no"))
        countryCode = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "country"))
        profile_img.sd_setImage(with: URL(string:   Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "profile_pic"))), placeholderImage: #imageLiteral(resourceName: "avatar"))

        
      

         name.text = nameStr
 
    }
    func Setdata()
    {
           emailattrLbl.attributedText = Themes.sharedInstance.ReturnAttributedText(color: Themes.sharedInstance.returnThemeColor(), mainText: "Please verify your email address by clicking the link in the message we just sent to \(Themes.sharedInstance.Getemail()) Can’t find our message? resend the confirmation email", attributeText: "resend the confirmation email")
        emailattrLbl.font = UIFont(name: Constant.sharedinstance.Regular, size: emailattrLbl.font.pointSize+1)
        emailattrLbl.text = "Please verify your email address by clicking the link in the message we just sent to testdriver@yopmail.com Can’t find our message? resend the confirmation email"
        emailattrLbl.delegate = self
        let range: Range? = ((emailattrLbl.text as? String) ?? "").range(of: "resend the confirmation email")
        let mofiedrange:NSRange = (((emailattrLbl.text as? String) ?? "").nsRange(from: range!))!
        emailattrLbl.addLink(to: URL(string: "\(BaseUrl)company/terms-conditions"), with: mofiedrange)
        
        emailadd.text =  ((Themes.sharedInstance.Getemail_verified() == "Yes")) ? "Email Address-Verified" : "Email Address-Not Verified"
        phonenum.text =  ((Themes.sharedInstance.Getphone_verified() == "Yes")) ? "Phone Number-Verified" : "Phone Number-Not Verified"

 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didclickbuildprof(_ sender: Any) {
        let EditProfileVC = storyboard?.instantiateViewController(withIdentifier:"EditProfileVCID" ) as! EditProfileVC
        EditProfileVC.isfromBuild = true
        self.navigationController?.pushViewController(EditProfileVC, animated: true)

    }
    @IBAction func didclickreservation(_ sender: Any) {
        Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "MyreservationVCID")

    }
    
    @IBAction func didclickviewprofile(_ sender: Any) {
        Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "ProfileVCID")

    }
    @IBAction func didclickmenu(_ sender: Any) {
        self.findHamburguerViewController()?.showMenuViewController()
     }
    
    @IBAction func didclickhere(_ sender: Any) {
        
        let OTPVerifyVC = storyboard?.instantiateViewController(withIdentifier:"OTPVerifyVCID" ) as! OTPVerifyVC
        OTPVerifyVC.delegate = self
          OTPVerifyVC.modalPresentationStyle = .overFullScreen
         var aObjNavi = UINavigationController(rootViewController: OTPVerifyVC)
        aObjNavi.setNavigationBarHidden(true, animated: false)
        aObjNavi.view.backgroundColor = UIColor.clear
        aObjNavi.modalPresentationStyle = .overFullScreen
         self.present(aObjNavi, animated: true, completion: nil)

    }
    
    func verficationemail()
    {
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.resend_email_verification as String, param: [:], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                     if(status == "1")
                    {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DashboardVC: OTPVerifyVCDelegate
{
    func reloaddata() {
        GetData()
    }
}


extension DashboardVC: TTTAttributedLabelDelegate
{
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        verficationemail()
     }
}

