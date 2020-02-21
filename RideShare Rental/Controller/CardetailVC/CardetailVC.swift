//
//  CardetailVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 08/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage


class CardetailVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var book_btn: UIButton!

    @IBOutlet var ownername: CustomLabel!
    @IBOutlet var fav_Btn: WCLShineButton!
    @IBOutlet var share_Btn: UIButton!
    
    @IBOutlet var carname: CustomLabel!
    var objRecord:CarRecord = CarRecord()
    var objFilterRecord:FilterRecord = FilterRecord()

    var ExtraobjRecord:CarRecord = CarRecord()
    var DataSource:NSMutableArray = NSMutableArray()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 120, height: 50),type: .ballPulse)
    var viewheight:CGFloat = 1347
    var signature_image:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
         var param5 = WCLShineParams()
        param5.bigShineColor = UIColor(rgb: (255, 195, 55))
        param5.enableFlashing = true
        fav_Btn.image = .defaultAndSelect(#imageLiteral(resourceName: "heart"), #imageLiteral(resourceName: "heartselect"))
        fav_Btn.params = param5
        fav_Btn.addTarget(self, action: #selector(self.DIdclickFav(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
        self.GetHomedata(Param: ["carId":objRecord.id])
        carname.text = "\(objRecord.car_make) \(objRecord.car_model) \(objRecord.year)"
      }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    @IBAction func DidclickMake(_ sender: Any) {
    }
    func GetHomedata(Param:[String:String])
    {
        self.ShowSpinner()
        fav_Btn.isHidden = true
         share_Btn.isHidden = true
         tableView.isHidden = true
        book_btn.isHidden = true

        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.cardetail as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            self.StopSPinner()
             if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        let CommDict:NSDictionary =  responseObject?.value(forKey: "commonArr") as! NSDictionary
                        if(CommDict.count > 0)
                        {
                            self.signature_image =  Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "signature_image"))
                            Themes.sharedInstance.saveSign(user_id: self.signature_image)
                             self.ExtraobjRecord.minstay = Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "minimum_stay"))
                            print(self.ExtraobjRecord.minstay)
                        }
                        self.book_btn.isHidden = false
                         self.share_Btn.isHidden = false
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
    
    func Addwishlist(Param:[String:String])
    {
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.wishlist as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            self.StopSPinner()
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                 if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        
                    }
                    else
                    {
                   
                    }
                 }
                else
                {
                    Themes.sharedInstance.showErrorpopup(Msg: Constant.sharedinstance.errormessage)
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
        DataSource = NSMutableArray()
       
        let detailDictArr:NSDictionary = responseDict?.value(forKey: "car_details") as! NSDictionary
         if(detailDictArr.count > 0)
        {
            let dict:NSDictionary = detailDictArr
            let deductibleArr:[[String:Any]] = responseDict!.object(forKey: "deductibleArr") as! [[String:Any]]
            if(deductibleArr.count > 0)
            {
                ExtraobjRecord.deductibleArr = []
            deductibleArr.forEach { (dict) in
                let obj:DeductibleRecord = DeductibleRecord(id: Themes.sharedInstance.CheckNullvalue(Passed_value: dict["id"]), payable_amount: Themes.sharedInstance.CheckNullvalue(Passed_value: dict["payable_amount"]), price_per_day: Themes.sharedInstance.CheckNullvalue(Passed_value: dict["price_per_day"]), text: Themes.sharedInstance.CheckNullvalue(Passed_value: dict["text"]))
                 ExtraobjRecord.deductibleArr.append(obj)
            }
            }
            
              fav_Btn.isSelected = true
              ExtraobjRecord.car_images = dict.object(forKey: "car_images") as! NSArray
              ExtraobjRecord.car_make = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_make"))
            ExtraobjRecord.unlimited_mileage = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "unlimited_mileage"))
             ExtraobjRecord.car_make = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_make"))

              ExtraobjRecord.user_image  = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "profile_pic"))
              ExtraobjRecord.car_model = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_model"))
               ExtraobjRecord.city = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "city"))
                ExtraobjRecord.id = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "id"))
                ExtraobjRecord.latitude = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "latitude"))
                ExtraobjRecord.longitude = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "longitude"))
                ExtraobjRecord.rent_daily = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_daily"))
                ExtraobjRecord.rent_monthly = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_monthly"))
                ExtraobjRecord.tag = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "tag"))
                ExtraobjRecord.usage = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "usage"))
                ExtraobjRecord.v_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "v_no"))
            ExtraobjRecord.notes = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "notes"))
                ExtraobjRecord.year = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "year"))
                ExtraobjRecord.vin_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "vin_no"))
                ExtraobjRecord.rent_weekly = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_weekly"))
               ExtraobjRecord.daily_mileage = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "daily_mileage"))
            
               ExtraobjRecord.features =   dict.object(forKey: "features") as! NSArray
                  ExtraobjRecord.firstname = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "firstname"))
            ExtraobjRecord.ownername = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "ownername"))
            if(ExtraobjRecord.firstname == "")
            {
                ExtraobjRecord.firstname = ExtraobjRecord.ownername
            }
             ExtraobjRecord.ins = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "ins"))
                ExtraobjRecord.lastname = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "lastname"))
                 ExtraobjRecord.lift_uber = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "lift_uber"))
                ExtraobjRecord.ownerId = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "ownerId"))
               ExtraobjRecord.plat_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "plat_no"))
                ExtraobjRecord.rating = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rating"))
                ExtraobjRecord.rc = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rc"))
              ExtraobjRecord.reviews  = dict.object(forKey: "reviews") as! NSArray
                 ExtraobjRecord.status = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "status"))
                 ExtraobjRecord.verification = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "verification"))
             ExtraobjRecord.last_approval = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "last_approval"))
           ExtraobjRecord.response_percent = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "response_percent"))
           ExtraobjRecord.total_cars = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "total_cars"))
           ExtraobjRecord.total_rentals = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "total_rentals"))
            ExtraobjRecord.monthly_offer = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "monthly_offer"))
            ExtraobjRecord.weekly_offer = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "weekly_offer"))


            ExtraobjRecord.desc = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "description"))
            ExtraobjRecord.shareUrl = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "shareUrl"))
               self.tableView.isHidden = false
             DispatchQueue.main.async {
                let nibName = UINib(nibName: "ReviewtableViewCell", bundle:nil)
                self.tableView.register(nibName, forCellReuseIdentifier: "ReviewtableViewCellID")
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.estimatedRowHeight = 95
                self.tableView.rowHeight = UITableViewAutomaticDimension
                 self.tableView.reloadData()
                self.tableView.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now()+0.6, execute: {
                      self.tableView.reloadData()
                    self.tableView.isHidden = false

                  })
              
             }
         }
 
    }
    
    func ShowSpinner()
    {
        activityIndicatorView.color = Themes.sharedInstance.returnThemeColor()
        activityIndicatorView.center=CGPoint(x:UIScreen.main.bounds.size.width/2,y:  tableView.frame.origin.y+60);
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func StopSPinner()
    {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        tableView.layoutIfNeeded()
        tableView.reloadData()
     }

    @IBAction func DidclickFav_Btn(_ sender: Any) {
     }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func Didclickback(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func DIdclickFav(_ sender: Any) {
    }
    
    @IBAction func DidclickShare(_ sender: Any) {
        
        let textToShare = "Hey Checkout this car which I have found on \(Themes.sharedInstance.GetAppname())"
        print(ExtraobjRecord.shareUrl.removingPercentEncoding!)
        if let myWebsite = URL(string: ExtraobjRecord.shareUrl.removingPercentEncoding!) {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender as! UIButton
            self.present(activityVC, animated: true, completion: nil)
        }
        
 
        
    }
    @IBAction func DidclickBooknow(_ sender: Any) {
        if(Themes.sharedInstance.returnSign().count == 0)
        {
            let DocumentVC = storyboard?.instantiateViewController(withIdentifier:"SignatureVCID" ) as! SignatureVC
           DocumentVC.modalPresentationStyle = .overFullScreen
            self.present(DocumentVC, animated: false, completion: nil)
         }
        else
        {
        let Step1VC = storyboard?.instantiateViewController(withIdentifier:"Step1VCID" ) as! Step1VC
        Step1VC.objRecord = ExtraobjRecord
        Step1VC.objFilterRecord = objFilterRecord
        self.navigationController?.pushViewController(Step1VC, animated: true)
        }
     }
    
}



extension CardetailVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
          return viewheight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("CarDetailheaderView", owner: self, options: nil)?[0] as? CarDetailheaderView
        view?.objRecord = ExtraobjRecord
        view?.carnameLbl.text = "\(ExtraobjRecord.car_make) \(ExtraobjRecord.car_model) \(ExtraobjRecord.year)"
        view?.priceperdayLbl.text = Themes.sharedInstance.Getcurrency() + "\(ExtraobjRecord.rent_daily)"
        
        view?.priceperweekLbl.text = Themes.sharedInstance.Getcurrency() + "\(ExtraobjRecord.rent_weekly)"
        view?.pricepermonthLbl.text = Themes.sharedInstance.Getcurrency() + "\(ExtraobjRecord.rent_monthly)"
        view?.driverimg.sd_setImage(with: URL(string:ExtraobjRecord.user_image), placeholderImage: #imageLiteral(resourceName: "avatar"))
        if(ExtraobjRecord.unlimited_mileage == "Yes")
        {
            view?.milLbl.text = "Unlimited" + " mi/day " + "Unlimited" + " mi/week "+"Unlimited" + " mi/month"
        }
        else
        {
        view?.milLbl.text = ExtraobjRecord.daily_mileage + " mi/day " + "\(Int32(ExtraobjRecord.daily_mileage)!*7)" + " mi/week "+"\(Int32(ExtraobjRecord.daily_mileage)!*30)" + " mi/month"
        }
        view?.VIN_NUMBER.isHidden = true
        view?.VIN_NUMBER.text = "VIN Number: \(ExtraobjRecord.vin_no)"
        view?.vehnumber.text = "Vehicle Number: \(ExtraobjRecord.v_no)"
        view?.notes.text = "Notes: \(ExtraobjRecord.notes)"
         view?.Setmap()
        view?.pageControl.numberOfPages = ExtraobjRecord.car_images.count
        view?.drivername2Lbl.text = ExtraobjRecord.ownername
        ownername.text = ExtraobjRecord.ownername
        view?.SetRatingView(value: CGFloat(Double(ExtraobjRecord.rating)!))
        view?.rent_Lbl.attributedText = Themes.sharedInstance.ReturnAttributedText(color: UIColor.black, mainText: "Total cars for rent : \(ExtraobjRecord.total_cars)", attributeText: ": \(ExtraobjRecord.total_cars)")
        view?.weeekofferLbl.font = UIFont(name: Constant.sharedinstance.Regular, size: 9)
        view?.monthLbl.font = UIFont(name: Constant.sharedinstance.Regular, size: 9)
        
        
        if(ExtraobjRecord.weekly_offer.count == 0)
        {
          view?.weakWrapperView.isHidden = true
        }
        if(ExtraobjRecord.monthly_offer.count == 0)
        {
            view?.monthwrapperView.isHidden = true

        }

        view?.weeekofferLbl.text = ExtraobjRecord.weekly_offer + "%"
            view?.monthLbl.text = ExtraobjRecord.monthly_offer + "%"

        view?.rating_Lbl.attributedText = Themes.sharedInstance.ReturnAttributedText(color: UIColor.black, mainText: "Rating percentage : \(ExtraobjRecord.response_percent)%", attributeText: ": \(ExtraobjRecord.response_percent)%")
        view?.aboutcar.text = ExtraobjRecord.desc
        view?.CollectionView.reloadData()
        view?.pages = Int(ceil(CGFloat(objRecord.features.count) / 3.0))
        view?.aboutcar.sizeToFit()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            view?.wrapperView.autoresizesSubviews = false
            view?.bottomView.frame.origin.y = (view?.aboutcar.frame.origin.y)!+(view?.aboutcar.frame.size.height)!+2
            view?.wrapperView.frame.size.height =  (view?.bottomView.frame.origin.y)!+(view?.bottomView.frame.size.height)!
            view?.centreview.frame.origin.y = (view?.topview.frame.origin.y)!+(view?.topview.frame.size.height)!
            view?.wrapperView.frame.origin.y = (view?.centreview.frame.origin.y)!+(view?.centreview.frame.size.height)!-((view?.driver_name.frame.origin.y)!+(view?.driver_name.frame.size.height)!+55)
           view?.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: (view?.wrapperView.frame.origin.y)!+(view?.wrapperView.frame.size.height)!)
             self.tableView.sectionHeaderHeight = (view?.frame.size.height)!
            tableView.tableHeaderView?.frame.size.height =  (view?.frame.size.height)!
            self.viewheight =  (view?.frame.size.height)!
              view?.wrapperView.autoresizesSubviews = true
               view?.autoresizesSubviews = false

          }
        view?.reloadata()
          return view
     }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ExtraobjRecord.reviews.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReviewtableViewCell  = tableView.dequeueReusableCell(withIdentifier: "ReviewtableViewCellID") as! ReviewtableViewCell
        cell.selectionStyle = .none
        cell.message_Lbl.sizeToFit()
        let dict:NSDictionary = ExtraobjRecord.reviews[indexPath.row] as! NSDictionary
        
        cell.SetRatingView(value: CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rateVal")))!))
        cell.message_Lbl.text = (Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "review")))
        cell.name_Lbl.text = (Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "Drivername")))
            
        cell.user_image.sd_setImage(with: URL(string:Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "DriverProfile_pic"))), placeholderImage: #imageLiteral(resourceName: "avatar"))
           return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
