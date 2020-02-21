//
//  DocViewController.swift
//  SCIMBO
//
//  Created by MV Anand Casp iOS on 10/07/17.
//  Copyright © 2017 CASPERON. All rights reserved.
//

import UIKit
import SwiftValidators

class DocViewController: UIViewController {
    var webViewURL:String = String()
    var webViewTitle:String = String()

    @IBOutlet var webView: UIWebView!
    @IBOutlet var doc_nameLbl: CustomLabel!
    
    var isFrompayment:Bool = Bool()
    var isFromextension:Bool = Bool()
    var Bookrecord:BookRecord = BookRecord()
    var isfromdoc:Bool = Bool()

 
    override func viewDidLoad() {
        super.viewDidLoad()
        doc_nameLbl.text = webViewTitle
        if(isFrompayment || isfromdoc)
        {
            let targetURL:URL? = URL(string: webViewURL)
            webView.delegate = self
            if(targetURL != nil)
            {
             let request = NSURLRequest(url: targetURL!)
            webView.loadRequest(request as URLRequest)
            Themes.sharedInstance.activityView(View: self.view)
            }
         }
        else
        {
        let targetURL:URL = URL(fileURLWithPath: webViewURL)
        let request = NSURLRequest(url: targetURL)
        webView.loadRequest(request as URLRequest)
        }
        // Do any additional setup after loading the view.
    }
     func SetWebView(str:String)
    {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didclickBackBtn(_ sender: Any) {
        if(isfromdoc)
        {
            self.dismiss(animated: true, completion: nil)
        }
       else if(isFrompayment)
        {
            AJAlertController.initialization().showAlert(aStrMessage: "Do you wish to cancel the transaction?",
                                                         aCancelBtnTitle: "NO",
                                                         aOtherBtnTitle: "YES")
            { (index, title) in
                if(index == 1)
                {
                    
                    self.navigationController?.popToRoot(animated: true)
                }
            }
        }
        else
        {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.pop(animated: true)
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

extension DocViewController:UIWebViewDelegate
{
      func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
 
         if(request.url?.absoluteString.contains("app/driver/payment_status/success"))!
        {
             let PaymentSuccessVC = self.storyboard?.instantiateViewController(withIdentifier:"PaymentSuccessVCID" ) as! PaymentSuccessVC
            PaymentSuccessVC.isFromextend = isFromextension
            PaymentSuccessVC.objbookrecord = self.Bookrecord

            self.navigationController?.pushViewController(PaymentSuccessVC, animated: true)
              return false
         }
        else if(request.url?.absoluteString.contains("app/driver/payment_status/failed"))!
        {
            Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: "Payment Failed", isSuccess: false)
            self.navigationController?.pop(animated: true)
             return false
         }
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
    Themes.sharedInstance.RemoveactivityView(View: self.view)
    }
     func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
     {
        
     }
}
