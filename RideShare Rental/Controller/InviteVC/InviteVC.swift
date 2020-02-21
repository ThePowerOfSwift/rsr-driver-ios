//
//  InviteVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 20/01/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit

import Social
import MessageUI
import NVActivityIndicatorView

class InviteVC: UIViewController {
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)

    @IBOutlet var rank: CustomLabel!
    @IBOutlet var password: CustomLabel!
    @IBOutlet var username: CustomLabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var yourcodeLbl: CustomLabel!
    @IBOutlet var wrapperView: UIView!
    
    var referral_code:String = ""
   var referral_link:String = ""
    var share_link:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Getref(Param: [:])

        // Do any additional setup after loading the view.
    }
    
    func Getref(Param:[String:String])
    {
        self.ShowSpinner()
           scrollView.isHidden = true
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.ambassador as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            self.StopSPinner()
             if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        self.scrollView.isHidden = false
                        self.referral_code = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.object(forKey: "referral_code"))
                        self.referral_link = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.object(forKey: "referral_link"))
                        
                        self.share_link = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.object(forKey: "share_link"))
                        self.yourcodeLbl.attributedText = Themes.sharedInstance.ReturnAttributedText(color: Themes.sharedInstance.returnThemeColor(), mainText: "Referral Code : \(self.referral_code)", attributeText: "\(self.referral_code)")
                        Themes.sharedInstance.savePaypalid(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.object(forKey: "amb_paypal_id")))
                        
                        let uname:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.object(forKey: "uname"))
                        let pwd:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.object(forKey: "pwd"))
                        let rank:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.object(forKey: "rank"))
                         self.rank.attributedText = Themes.sharedInstance.ReturnAttributedText(color: UIColor.darkGray, mainText:"Rank : \(rank)" , attributeText: "\(rank)")


                        self.username.attributedText = Themes.sharedInstance.ReturnAttributedText(color: UIColor.darkGray, mainText:"Username : \(uname)" , attributeText: "\(uname)")
                        self.password.attributedText   = Themes.sharedInstance.ReturnAttributedText(color: UIColor.darkGray, mainText:"Password : \(pwd)" , attributeText: "\(pwd)")
 
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Didclicktwitter(_ sender: Any) {
        
        let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
 
        vc?.add(URL(string: share_link))
        vc?.setInitialText("\(Themes.sharedInstance.GetAppname()) ambassador program referral")
        self.present(vc!, animated: true, completion: nil)
 
    }
    @IBAction func Didclickgoogle(_ sender: Any) {
    }
    @IBAction func Didclickfb(_ sender: Any) {
 
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
         vc?.add(URL(string: share_link))
        vc?.setInitialText("\(Themes.sharedInstance.GetAppname()) ambassador program referral")
        self.present(vc!, animated: true, completion: nil)
 

    }
    
    @IBAction func Didclickemail(_ sender: Any) {
 
        
         showInputDialog(title: Themes.sharedInstance.GetAppname(),
                        subtitle: "Enter the list of Email IDs separated by comma",
                        actionTitle: "Send",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Enter Email IDs",
                        inputKeyboardType: UIKeyboardType.default)
        { (input:String?) in
            if(input != nil && input != "")
            {
            self.SendMessage(Param: ["mailids":input!])
            }
            else
            {
                Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: Themes.sharedInstance.CheckNullvalue(Passed_value: "Enter email ids"), isSuccess: false)
             }
         }

     }
    func ShowSpinner()
    {
        activityIndicatorView.color = Themes.sharedInstance.returnThemeColor()
        activityIndicatorView.center=CGPoint(x:UIScreen.main.bounds.size.width/2,y:  20);
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
    }
    func StopSPinner()
    {
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    func SendMessage(Param:[String:String])
    {
        Themes.sharedInstance.activityView(View: self.view)
         URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.send_referral_mail as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
   
    
    
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func Didclickhere(_ sender: Any) {
        if let url = URL(string: referral_link) {
            UIApplication.shared.open(url, options: [:])
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
extension InviteVC:MFMailComposeViewControllerDelegate
{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
