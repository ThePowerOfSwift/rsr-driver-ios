//
//  ReviewVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 10/01/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import SwiftValidators
import NVActivityIndicatorView
 class ReviewVC: UIViewController {
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    @IBOutlet var submit_Btn: CustomButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var rating_view: TPFloatRatingView!
    @IBOutlet var star_Lbl: CustomLabel!
    @IBOutlet var textview: UITextView!
    @IBOutlet var writereview: CustomLabel!
    var reviewText:String = String()
    var rating:Double = Double()
    var bookingNo:String = String()
    var rating_count:String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        textview.layer.cornerRadius = 3.0
        textview.layer.borderWidth = 1.0
        textview.layer.borderColor = UIColor.lightGray.cgColor
        rating = 3.0
        rating_count = "0"
         let dict:[String:String] = ["booking_no":bookingNo]
        self.Chatdata(Param: dict)

        
         // Do any additional setup after loading the view.
    }
    
    func sendmessage(Param:[String:String])
    {
        self.ShowSpinner()
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.add_review as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            self.StopSPinner()
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        self.view.endEditing(true)
                        self.submit_Btn.isHidden = true
                        self.rating_view.editable = false
                        self.textview.isEditable = false
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
    
    func Chatdata(Param:[String:String])
    {
        scrollView.isHidden = true
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.review as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
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
        self.scrollView.isHidden = false
        let past_Array:NSArray = responseDict?.object(forKey: "reviews") as!  NSArray
         if(past_Array.count > 0)
        {
            submit_Btn.isHidden = true

            let dic:NSDictionary = past_Array[0] as! NSDictionary
            self.SetRatingView(value: CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "review_count")))!))
            self.textview.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "review_text"))
            rating_view.editable = false
            self.textview.isEditable = false
            
            star_Lbl.text = "\(Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "review_count"))) star"


        }
        else
        {
            submit_Btn.isHidden = false
            star_Lbl.text = "0 star"
             self.rating_count = "0"
            self.textview.text = ""
            self.SetRatingView(value: 0.0)
             rating_view.editable = true


        }
    }
    func ShowSpinner()
    {
        activityIndicatorView.color = Themes.sharedInstance.returnThemeColor()
        activityIndicatorView.center=CGPoint(x:UIScreen.main.bounds.size.width/2,y:  scrollView.frame.origin.y+70);
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
    }
    func StopSPinner()
    {
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    func SetRatingView(value:CGFloat)
    {
        rating_view.emptySelectedImage = UIImage(named: "halfstar")
        rating_view.fullSelectedImage = UIImage(named: "fullstar")
        rating_view.contentMode = .scaleAspectFill
        rating_view.maxRating = 5
        rating_view.minRating = 0
        rating_view.rating = value
        rating_view.halfRatings = false
        rating_view.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func DidclickSubmit(_ sender: Any) {
        if(Validator.isEmpty().apply(textview.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "kindly write your review")
        }
        else
        {
            let dict:[String:String] = ["booking_no":bookingNo,"review_text":textview.text!,"review_count":rating_count]
            self.sendmessage(Param: dict)

        }
    }
    
    @IBAction func DidclickBack(_ sender: Any) {
        
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
extension ReviewVC:TPFloatRatingViewDelegate
{
    func floatRatingView(_ ratingView: TPFloatRatingView!, ratingDidChange rating: CGFloat) {
        if(rating <= 1)
        {
            star_Lbl.text = "\(Int(rating)) star"
         }
        else
        {
            star_Lbl.text = "\(Int(rating)) star"
         }
        
        rating_count = "\(Int(rating))"
    }
}
