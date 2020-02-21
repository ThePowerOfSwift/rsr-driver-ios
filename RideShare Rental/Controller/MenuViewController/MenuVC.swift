//
//  MenuViewController.swift
//  Plumbal
//
//  Created by Casperon Tech on 03/03/16.
//  Copyright © 2016 Casperon Tech. All rights reserved.
//


import UIKit
import MessageUI
import GoogleSignIn
import NVActivityIndicatorView

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate  {
  
     @IBOutlet weak var tableView: UITableView!
     var segues = [String]()
 
   var Appdel=UIApplication.shared.delegate as! AppDelegate
    var URL_handler:URLhandler=URLhandler()
    var themes:Themes=Themes()
       var GetReceipientMail : String = ""
    var Citylistarray:NSMutableArray=NSMutableArray()
    var Cityidarray:NSMutableArray=NSMutableArray()
    let activityTypes: [NVActivityIndicatorType] = [
        .ballPulse]
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 75, height: 100),
                                                        type: .ballSpinFadeLoader)
    var trimmed_Location:String=String()
     //MARK: - Override Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var messageStr:String = ""
        if(Themes.sharedInstance.GetmessageCount() != "" && Themes.sharedInstance.GetmessageCount()  != "0")
        {
            messageStr = "Message (\(Themes.sharedInstance.GetmessageCount()))"
        }
        else
        {
            messageStr = "Message"
            
        }
        segues = ["Dashboard","Find Cars","My Reservation","My Transaction",messageStr,"My Profile","Add/Update Signature","Add Credit Card","Change Password","Ambassador Referral Program","Contract History","Contact support","Leave Review","Report an accident","Logout"]

        let nibName = UINib(nibName: "SlideCustomTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "SlideCustomTableViewCell")
        let nibName1 = UINib(nibName: "LocationTableViewCell", bundle:nil)
        self.tableView.register(nibName1, forCellReuseIdentifier: "Cell")
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView=UIView()
        tableView.separatorColor=UIColor.clear
        Setdata()
         animateTable()
    }
    
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        for i in cells {
            let cell: SlideCustomTableViewCell = i as! SlideCustomTableViewCell
            cell.Menulist.transform = CGAffineTransform(translationX: -self.view.frame.size.width, y: 0)
        }
        var index = 0
        for a in cells {
            let cell: SlideCustomTableViewCell = a as! SlideCustomTableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
                cell.Menulist.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: -  Function
    
    func Setdata() {
        
 
    }
    
    
   
    
    func DismissProgress() {
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.removeFromSuperview()
    }
    
    func LogoutoftheApp()
    {
        Appdel.MakeRootVc("InitialVCID")
        
     }
    
    func LogoutMethod(){
        
    }
    
    func showSendMailErrorAlert() {
     }
    //MARK: - Button Function
    
    @IBAction func didClickoptions(_ sender: UIButton) {
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return segues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideCustomTableViewCell", for: indexPath) as! SlideCustomTableViewCell
        cell.Menulist.text = segues[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion(completion: {
            self.MoveToPage(indexPath: indexPath)
        })
       
    }
    
    func MoveToPage(indexPath: IndexPath)
    {
        if(indexPath.row == 0) {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "DashboardVCID")
        }
        if(indexPath.row == 1) {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "HomeVCID")
        }
        if(indexPath.row == 2) {
            
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "MyreservationVCID")

        }
        if(indexPath.row == 3)
        {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "MytransactionVCID")
        }
         if(indexPath.row == 4)
        {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "MessageHomeVCID")
 
        }
        if (indexPath.row == 5)
        {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "ProfileVCID")
            
            
        }
         if (indexPath.row == 6)
        {
            
            if let window = self.Appdel.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                let DocumentVC = storyboard?.instantiateViewController(withIdentifier:"SignatureVCID" ) as! SignatureVC
                DocumentVC.modalPresentationStyle = .overFullScreen
 
                currentController.present(DocumentVC, animated: true, completion: nil)
            }


      }
        
         if(indexPath.row == 7)
        {

            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "AddCardVCID")

            
         }
        
        if(indexPath.row == 8) {

            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "ChangepasswordVCID")

        }
        if (indexPath.row == 9){
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "ReferralMainVCID")

         }
        if (indexPath.row == segues.count-5){
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "ContractHistoryVCID")

           }
        else if (indexPath.row ==  segues.count-4)
        {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "ContactVCID")

         }
            
        else if (indexPath.row ==  segues.count-3)
        {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "LeaveReviewVCID")
         }
         else if (indexPath.row ==  segues.count-2)
        {
             Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "DriverClaimVCID")
        }
        else if (indexPath.row ==  segues.count-1)
        {
            
            AJAlertController.initialization().showAlert(aStrMessage: "Are you sure you want to logout?",
                                                         aCancelBtnTitle: "NO",
                                                         aOtherBtnTitle: "YES")
            { (index, title) in
                if(index == 1)
                {
                    LocationService.sharedInstance.stopUpdatingLocation()
                    let param:[String : String] = ["device":"ios"]
                    self.Logout(Param: param)
                    Filemanager.sharedinstance.DeleteFile(foldername: "Doc")
                    GIDSignIn.sharedInstance().signOut()
                    Themes.sharedInstance.ClearuserDetails()
                    self.LogoutoftheApp()

                    
                }
            }
 
         }
        
        else if (indexPath.row ==  11)
        {
           
        }
    }
    func Logout(Param:[String:String])
    {
         URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.logout as String, param: Param, completionHandler: {(responseObject, error) ->  () in
             print(error?.localizedDescription)
             if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {

                 }
            }
            else
            {
             }
        })
    }
    
    //MARK: - MFMailComposeViewController
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["\(self.GetReceipientMail)"])
         //            mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    func mainNavigationController() -> DLHamburguerNavigationController {
        return self.storyboard?.instantiateViewController(withIdentifier: "HomeVCID") as! DLHamburguerNavigationController
    }


    
}


