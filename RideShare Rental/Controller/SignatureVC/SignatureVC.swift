//
//  SignatureVC.swift
//  RideShare Rental
//
//  Created by CasperoniOS on 10/01/19.
//  Copyright © 2019 RideShare Rental. All rights reserved.
//

import UIKit
import SDWebImage

class SignatureVC: UIViewController {
    @IBOutlet var lineLbl: UILabel!
    @IBOutlet var signatureimg: UIImageView!
    @IBOutlet var headerLabel: CustomLabel!
    @IBOutlet var wrapperView: UIView!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
     var signatureimageView:String = String()
     override func viewDidLoad() {
        super.viewDidLoad()
         signatureView.layer.borderWidth = 1.0
        signatureView.layer.cornerRadius = 3.0
        signatureView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        signatureimg.sd_setImage(with: URL(string: Themes.sharedInstance.returnSign()))
        if(Themes.sharedInstance.returnSign().count == 0)
        {
            signatureView.frame.origin.y = signatureView.frame.origin.y - 20
            lineLbl.frame.origin.y = lineLbl.frame.origin.y - 20

        }
        
         // Do any additional setup after loading the view.
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
    @IBAction func didclickClear(_ sender: Any) {
        self.signatureView.clear()

    }
    @IBAction func didClickSubmit(_ sender: Any) {
        if let signatureImage = self.signatureView.getSignature(scale: 10) {
            
            // Saving signatureImage from the line above to the Photo Roll.
            // The first time you do this, the app asks for access to your pictures.
            let data = UIImageJPEGRepresentation(signatureImage, 0.7)
            self.uploadsign(imgdata: data!)
          //   self.signatureView.clear()
        }
        else
        {
            Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: "Kindly sign in the required space given", isSuccess: false)
        }
    }
    
    func uploadsign(imgdata:Data)
        
    {
        var Dict:[String:Data] = [:]
        
        Dict.updateValue(imgdata, forKey: "signature_image")
        
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.Upload_File(url: Constant.sharedinstance.upload_signature_image as String, parameters: [:], imageparam: Dict, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        var signature_image:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.object(forKey: "signature_image"))
                        var msg:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.object(forKey: "msg"))

                        Themes.sharedInstance.saveSign(user_id: signature_image)
                        self.signatureimg.sd_setImage(with: URL(string: Themes.sharedInstance.returnSign()))
                         Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: msg , isSuccess: true)
                        self.DismissView()
                       // self.MovetoHome()
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
    
    func MovetoHome()
    {
                  if(Themes.sharedInstance.Getactive_reservation() == "Yes")
                {
                    (UIApplication.shared.delegate as! AppDelegate).Make_RootVc("DLDemoRootViewController", RootStr: "MyreservationVCID")
                    
                }
                else
                {
                    (UIApplication.shared.delegate as! AppDelegate).Make_RootVc("DLDemoRootViewController", RootStr: "HomeVCID")
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
