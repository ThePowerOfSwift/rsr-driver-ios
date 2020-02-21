//
//  ViewController.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 05/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import GoogleSignIn
import TOWebViewController



class InitialVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var bottomDetailView: UIView!
    @IBOutlet var header_Lbl: CustomLabel!
    @IBOutlet var header_imgView: UIImageView!
    
    @IBOutlet var signup_Btn: TKTransitionSubmitButton!
    @IBOutlet var google_Btn: CustomButton!
     @IBOutlet var bottom_View: UIView!
    @IBOutlet var bottom_line: UIView!
    @IBOutlet weak var accLbl: CustomLabel!

    @IBOutlet var logo_image: UIImageView!
            var actualY:CGFloat!
    enum Scrollpostion: Int {
         case upward = 0
        case downward = 2
 
    }
    var isexpanded:Bool = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        SetViewData()
         // Do any additional setup after loading the view, typically from a nib.
        signup_Btn.backgroundColor = Themes.sharedInstance.returnThemeColor()
        signup_Btn.layer.cornerRadius = 3.0
        signup_Btn.clipsToBounds = true;
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.taponView(_:)))
        self.view.addGestureRecognizer(tapGesture)
        accLbl.attributedText = Themes.sharedInstance.ReturnFontAttributedText( mainText:  "If you are involved in an accident, Please fill out the claim form below", attributeText: "If you are involved in an accident", size: accLbl.font.pointSize)
        actualY = bottomBtn.frame.origin.y
        isexpanded = false
       }
    
    func animateDownBottom(isdownward:Bool)
    {
        self.bottomBtn.layer.removeAllAnimations()
        if(isdownward)
        {
        self.bottomBtn.rotate(angle: 180)
        }
        else
        {
            self.bottomBtn.rotate(angle: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.bottomBtn.frame.origin.y = self.actualY-5
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut, .autoreverse, .repeat,.allowUserInteraction], animations: {
                self.bottomBtn.frame.origin.y = self.actualY
            }, completion: {suc in
            })
        }
    }
    @objc func taponView(_ sender: UITapGestureRecognizer) {
        self.animateDownBottom(isdownward: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.scrollViewSetPostion(postion: .downward)
        }
  }
    func scrollViewSetPostion(postion:Scrollpostion)
    {
        if(postion == .upward)
        {


            scrollView.setContentOffset(CGPoint(x: 0, y: bottomDetailView.frame.size.height+30), animated: true)
            isexpanded = true

        }
        else if(postion == .downward)
        {

            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            isexpanded = false
        }
        
    }
    
    @IBAction func didclickClaimant(_ sender: Any) {
        let ClaimantClaimVC = self.storyboard?.instantiateViewController(withIdentifier: "ClaimantClaimVCID") as! ClaimantClaimVC
        self.navigationController?.pushViewController(ClaimantClaimVC, animated: true)
        
    }
    @IBAction func didclickdriver(_ sender: Any) {
        let DriverClaimVC = self.storyboard?.instantiateViewController(withIdentifier: "ClaimLoginViewController") as! ClaimLoginViewController
        DriverClaimVC.isfromLogin = true
        
        self.navigationController?.pushViewController(DriverClaimVC, animated: true)
        
    }
    @IBAction func scrollBottomButtom(_ sender: Any) {
        if(!isexpanded)
        {
            self.animateDownBottom(isdownward: false)
              self.scrollViewSetPostion(postion: .upward)
 
         }
        else
        {
            self.animateDownBottom(isdownward: true)
            self.scrollViewSetPostion(postion: .downward)
        }

    }
    func SetViewData()
    {
        
        header_Lbl.text = "Ride Share Rental\nDRIVER"
    }
    func MovetoHome()
    {
        self.signup_Btn.startLoadingAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.signup_Btn.startFinishAnimation(0.1, completion: {
                
                
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
    override func viewWillAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
      
        self.navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.animateDownBottom(isdownward: true)
         }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.animateDownBottom(isdownward: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.scrollViewSetPostion(postion: .downward)

        }
        
        self.navigationController?.navigationBar.isHidden = false
     }

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func DidclickGoogle(_ sender: Any) {
         GIDSignIn.sharedInstance().signIn()

    }
    
    @IBAction func DidclickFb(_ sender: Any) {
    }
    @IBAction func DidclickLogin(_ sender: Any) {
        
        let objSigninVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninVCID") as! SigninVC
        self.navigationController?.pushViewController(objSigninVC, animated: true)

    }
    @IBAction func DidclickSignUp(_ sender: Any) {
        let objSignUp = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVCID") as! SignUpVC
        self.navigationController?.pushViewController(objSignUp, animated: true)
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
    
    @IBAction func Didclickinsta(_ sender: Any) {
        self.MovetoSafari(url: "https://www.instagram.com/?hl=en")

    }
    @IBAction func Didclickfacebook(_ sender: Any) {
 
        
        self.MovetoSafari(url: "https://www.facebook.com/ridesharerental/")

    }
    @IBAction func Dicliktwitter(_ sender: Any) {
         self.MovetoSafari(url: "https://twitter.com/RideShareCars")

    }
    
    func MovetoSafari(url:String)
    {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension InitialVC:GIDSignInDelegate,GIDSignInUIDelegate
    
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
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = Themes.sharedInstance.CheckNullvalue(Passed_value: user.profile.name)
            let givenName = Themes.sharedInstance.CheckNullvalue(Passed_value: user.profile.givenName)
            let familyName = user.profile.familyName
            let email = Themes.sharedInstance.CheckNullvalue(Passed_value: user.profile.email)
            
            let URl = Themes.sharedInstance.CheckNullvalue(Passed_value: user.profile.imageURL(withDimension: 150).absoluteString)
            
            // let email = user.profile.email
            let loginPram:[String:String] = ["login_type":"google","facebookId":"","googleImage":URl,"firstname":fullName,"lastname":"","email":email,"password":"","deviceToken":Themes.sharedInstance.getDeviceToken(),"mobile_key":""]
            Login(Param: loginPram)
            // ...
        } else {
        }
    }
}

