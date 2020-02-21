//
//  HomeVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 08/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import GooglePlaces
import Toast_Swift
import CoreLocation
import GoogleMaps
import NVActivityIndicatorView
import SDWebImage
import SwiftValidators




class HomeVC: UIViewController {
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    @IBOutlet var car_no: CustomLabel!
    @IBOutlet var toLbl: CustomLabel!
    @IBOutlet var fromLbl: CustomLabel!
    @IBOutlet var loc_Lbl: CustomLabel!
    @IBOutlet var to_View: CustomView!
    @IBOutlet var from_View: CustomView!
    @IBOutlet var loc_View: CustomView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var advance_filter: CustomButton!
    @IBOutlet var mapBtn: UIButton!
    var Fromdate:Date?
    var Todate:Date?
    var isChoosenFromDate = Bool()
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    var Latitude:String = String()
    var Longitude:String = String()
    var current_Location:CLLocation?
    var objFilterRecord:FilterRecord = FilterRecord()
    var Datasource:NSMutableArray = NSMutableArray()
    var ispageLoading:Bool = Bool()
    var isUpdateAvailable:Bool = Bool()
     override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "HometableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "HometableViewCellID")
        let SecondnibName = UINib(nibName: "UpdatetableViewCell", bundle:nil)
        tableView.register(SecondnibName, forCellReuseIdentifier: "UpdatetableViewCellID")
 
        tableView.estimatedRowHeight = 380
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        LocationService.sharedInstance.delegate = self
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeGround), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        if(loc_Lbl.text == "")
        {
        loc_Lbl.text = "Fetching...."
        Latitude = ""
        Longitude = ""
         ShowSpinner()
            
            if(Themes.sharedInstance.Getactive_reservation() == "Yes")
            {
                LocationService.sharedInstance.startUpdatingLocation()
             }
            else
            {
                LocationService.sharedInstance.stopUpdatingLocation()
 
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                self.loc_Lbl.text  = "Los angeles,CA,United States"
                self.objFilterRecord.location = self.loc_Lbl.text!
                let param:[String:String] = ["max_milege":self.objFilterRecord.max_milege,
                                             "min_milege":self.objFilterRecord.min_milege,
                                             "min_year":self.objFilterRecord.min_year,
                                             "features":self.objFilterRecord.features,
                                             "location":self.objFilterRecord.location,
                                             "car_make":self.objFilterRecord.car_make,
                                             "min_price":self.objFilterRecord.min_price,
                                             "car_model":self.objFilterRecord.car_model,
                                             "max_year":self.objFilterRecord.max_year,
                                             "max_price":self.objFilterRecord.max_price]
                self.GetHomedata(Param: param)
            }
         }
         tableView.isHidden = true
         car_no.isHidden = true
        advance_filter.isHidden = true
       mapBtn.isHidden = true
      advance_filter.setTitle("Advance Filter", for: .normal)
      NotificationCenter.default.addObserver(self, selector: #selector(self.ReceiveFilterDetail(not:)), name: Constant.sharedinstance.similarcarsnotName, object: nil)
       }
    
    @objc func ReceiveFilterDetail(not:Notification)
    {
        ispageLoading = true
        self.ShowSpinner()
          let Dict:[String:String] = not.object as!  [String:String]
        objFilterRecord.location = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["location"])
        objFilterRecord.car_make = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["carmake"])
        objFilterRecord.car_model = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["carmodel"])
        loc_Lbl.text = objFilterRecord.location
         self.initialiseParam()
 
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func initialiseParam()
    {
        let param:[String:String] = ["max_milege":objFilterRecord.max_milege,
                                     "min_milege":objFilterRecord.min_milege,
                                     "min_year":objFilterRecord.min_year,
                                     "features":objFilterRecord.features,
                                     "location":objFilterRecord.location,
                                     "car_make":objFilterRecord.car_make,
                                     "min_price":objFilterRecord.min_price,
                                     "car_model":objFilterRecord.car_model,
                                     "max_year":objFilterRecord.max_year,
                                     "max_price":objFilterRecord.max_price]
        self.GetHomedata(Param: param)

    }
    
    func GetHomedata(Param:[String:String])
      {
        
        ispageLoading = true
        mapBtn.isHidden = true
        advance_filter.isHidden = true
        car_no.isHidden = true
        tableView.isHidden = true
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.find_a_car as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            self.StopSPinner()
             self.car_no.isHidden = false
            self.ispageLoading = false
               if(error == nil)
            {
                  let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    let CommDict:NSDictionary =  responseObject?.value(forKey: "commonArr") as! NSDictionary
                    if(CommDict.count > 0)
                    {
                        Themes.sharedInstance.saveSign(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "signature_image")))
                        Themes.sharedInstance.Saveemail_verified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "email_verified")))
                        Themes.sharedInstance.Savephone_verified(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "ph_verified")))
                        Themes.sharedInstance.SavePhone(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "phone_no")))
                        Themes.sharedInstance.Savecountry(str: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "ph_country")))
                         self.ShowPhoneNumberVerPopup()
                      }

                    if(status == "1")
                    {
                        
                        self.GetDetail(responseDict: resDict)
                     }
                    else
                    {
                        self.car_no.text = "No cars found"
                         Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "msg")), isSuccess: false)
                    }
                    
                }
            }
            else
            {
                self.car_no.text = "No cars found"
                Themes.sharedInstance.showErrorpopup(Msg: Constant.sharedinstance.errormessage)
            }
        })
    }
    
func ShowPhoneNumberVerPopup()
 {
    if(Themes.sharedInstance.Getphone_verified() == "No")
    {
        let OTPVerifyVC = storyboard?.instantiateViewController(withIdentifier:"OTPVerifyVCID" ) as! OTPVerifyVC
        OTPVerifyVC.delegate = self
        OTPVerifyVC.modalPresentationStyle = .overFullScreen
        var aObjNavi = UINavigationController(rootViewController: OTPVerifyVC)
        aObjNavi.setNavigationBarHidden(true, animated: false)
        aObjNavi.view.backgroundColor = UIColor.clear
        aObjNavi.modalPresentationStyle = .overFullScreen
        self.present(aObjNavi, animated: true, completion: nil)

    }
 }
    
    func GetDetail(responseDict:NSDictionary?)
    {
         advance_filter.isHidden = false

   let detailDictArr:NSArray = responseDict?.value(forKey: "cars_list") as! NSArray
        car_no.text = detailDictArr.count == 1 ? "\(detailDictArr.count) car found neary by":"\(detailDictArr.count) cars found neary by"
         if(detailDictArr.count > 0)
        {
            Datasource.removeAllObjects()
             mapBtn.isHidden = false
           for i in 0..<detailDictArr.count
           {
            let dict:NSDictionary = detailDictArr[i] as! NSDictionary
            var objRecord:CarRecord = CarRecord()
            
            objRecord.car_images = dict.object(forKey: "car_images") as! NSArray
            if(objRecord.car_images.count > 0)
            {
                let Dict:NSDictionary = objRecord.car_images[0] as! NSDictionary
                objRecord.car_singleimage = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "image"))
            }
            else
            {
                objRecord.car_singleimage = ""
            }
            objRecord.car_make = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_make"))
            objRecord.user_image  = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "profile_pic"))
            objRecord.rating  = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rating"))
             objRecord.car_model = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_model"))
            objRecord.city = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "city"))
            objRecord.id = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "id"))
              objRecord.latitude = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "latitude"))
            objRecord.longitude = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "longitude"))
            objRecord.rent_daily = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_daily"))
            objRecord.rent_monthly = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_monthly"))
            objRecord.tag = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "tag"))
            objRecord.usage = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "usage"))
            objRecord.v_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "v_no"))
            objRecord.year = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "year"))
            objRecord.vin_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "vin_no"))
             objRecord.rent_weekly = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_weekly"))
            Datasource.add(objRecord)
            }
            self.tableView.isHidden = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.frame.size.height = self.tableView.contentSize.height
                self.scrollView.contentSize.height = self.tableView.frame.origin.y+self.tableView.contentSize.height+10
              }
          }
        else
         {
            car_no.text = "no cars found neary by"
        }

    }
    @objc func appMovedToForeGround() {
        if(LocationService.sharedInstance.Locstatus == .authorizedWhenInUse || LocationService.sharedInstance.Locstatus == .authorizedWhenInUse)
        {
            self.dismiss(animated: true, completion: {
                if(Themes.sharedInstance.Getactive_reservation() == "Yes")
                {
                    LocationService.sharedInstance.startUpdatingLocation()
                }
                else
                {
                    LocationService.sharedInstance.stopUpdatingLocation()
                    
                }
//                LocationService.sharedInstance.startUpdatingLocation()
             })
 
        }
        Checkupdate()
    }
    
    override func viewWillAppear(_ animated: Bool)
     {
        if(LocationService.sharedInstance.Locstatus == .denied || LocationService.sharedInstance.Locstatus == .restricted)
        {
            let NoLocVC = storyboard?.instantiateViewController(withIdentifier:"NoLocVCID" ) as! NoLocVC
            self.navigationController?.present(NoLocVC, animated: true, completion: nil)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
     Checkupdate()
       
      }
 
    func Checkupdate()
    {
        _ = try? Themes.sharedInstance.isUpdateAvailable{ (update, error) in
            if let error = error {
                
                self.isUpdateAvailable = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
             } else if let update = update {
                print(update)
                let infoDictionary = Bundle.main.infoDictionary

                if let currentVersion = infoDictionary!["CFBundleShortVersionString"] as? String {
                     print("the updaet is\(currentVersion)...\(update)")
 
                    if (Double(currentVersion)! < Double(update)!) {
                        
                        self.isUpdateAvailable = true
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }
                    else
                    {
                         self.isUpdateAvailable = false
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
               self.tableView.frame.size.height = self.tableView.contentSize.height
        self.scrollView.contentSize.height = self.tableView.frame.origin.y+self.tableView.contentSize.height+10
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuuact(_ sender: AnyObject) {
        self.findHamburguerViewController()?.showMenuViewController()
    }

    @IBAction func DidclickFilter(_ sender: Any)
    {
        if(advance_filter.titleLabel?.text! == "Reset Filter")
        {
        objFilterRecord.max_price = ""
        objFilterRecord.min_price = ""
        objFilterRecord.max_year = ""
        objFilterRecord.min_year = ""
        objFilterRecord.max_milege = ""
        objFilterRecord.min_milege = ""
        objFilterRecord.Reservation = ""
        objFilterRecord.car_model = ""
        objFilterRecord.car_model = ""
        objFilterRecord.features = ""
        advance_filter.setTitle("Advance Filter", for: .normal)
            self.ShowSpinner()
            initialiseParam()
         }
        else
        {
        objFilterRecord.max_price = ""
        objFilterRecord.min_price = ""
        objFilterRecord.max_year = ""
        objFilterRecord.min_year = ""
        objFilterRecord.max_milege = ""
        objFilterRecord.min_milege = ""
        objFilterRecord.Reservation = ""
        objFilterRecord.car_model = ""
        objFilterRecord.car_model = ""
        objFilterRecord.features = ""
        let FilterVC = storyboard?.instantiateViewController(withIdentifier:"FilterVCID" ) as! FilterVC
        FilterVC.objFilterRecord = objFilterRecord
        FilterVC.delegate = self
        self.navigationController?.present(FilterVC, animated: true, completion: nil)
        }
    }
    func generateDates(fromDate:Date,value : Int) -> Date {
        let today = fromDate
        let tomorrow = Calendar.current.date(byAdding: .day, value: value, to: today)
        return tomorrow!
    }
    @IBAction func DidclickLoc(_ sender: Any)
     {
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        present(autocompleteController, animated: true, completion: nil)
        
        let locVC = storyboard?.instantiateViewController(withIdentifier:"LocationVCID" ) as! LocationVC
        locVC.delegate = self
        self.navigationController?.pushViewController(locVC, animated: true)
     }
    @IBAction func DidclickTodate(_ sender: Any) {
        if(fromLbl.text != "")
        {
            isChoosenFromDate = false
            let todate:Date = self.generateDates(fromDate: Fromdate!, value: 7)
            self.presentDateView(fromdate: todate, todate: self.generateDates(fromDate: todate, value: 7))
        }
        else
        {
            self.view.makeToast("Kindly Choose from date")
        }
     }
    @IBAction func DidclickFromDate(_ sender: Any) {
        isChoosenFromDate = true
        self.presentDateView(fromdate: Date(), todate: self.generateDates(fromDate: Date(), value: 7))

     }
    func presentDateView(fromdate:Date,todate:Date)
    {
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionTopPanelBackgroundColor = Themes.sharedInstance.returnThemeColor()
        selector.optionClockBackgroundColorFace  = Themes.sharedInstance.returnThemeColor()
        
        selector.optionCurrentDate = fromdate
        selector.optionCalendarFontColorPastDates = UIColor.lightGray
        selector.optionCalendarFontColorFutureDates = Themes.sharedInstance.returnThemeColor()
          selector.EndingDate = todate
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(false)
        selector.optionStyles.showTime(false)
        selector.optionButtonFontColorDone = Themes.sharedInstance.returnThemeColor()
        selector.optionButtonFontColorCancel = Themes.sharedInstance.returnThemeColor()
        present(selector, animated: true, completion: nil)
     }
    
    func GetAddressFromLatLong(Currentlocation:CLLocation)
    {
        if(!ispageLoading)
        {
        ShowSpinner()
        let geocoder = GMSGeocoder()
         geocoder.reverseGeocodeCoordinate(Currentlocation.coordinate) { response, error in
            if(!self.ispageLoading)
            {
            if let location = response?.firstResult() {
                 let lines = location.lines! as [String]
                if(lines.count > 0)
                {
//                    self.loc_Lbl.text = String(describing:"\(Themes.sharedInstance.CheckNullvalue(Passed_value: location.locality)),\(Themes.sharedInstance.CheckNullvalue(Passed_value: location.country))")
                    
                    
                    
                
                }
                print(lines)
               }
        }
            }

        }
    }
    
    func ShowSpinner()
    {
         activityIndicatorView.color = Themes.sharedInstance.returnThemeColor()
        activityIndicatorView.center=CGPoint(x:UIScreen.main.bounds.size.width/2,y:  tableView.frame.origin.y+70);
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
    }
    func StopSPinner()
    {
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    @IBAction func DidclickMap(_ sender: Any) {
        let MapVC = storyboard?.instantiateViewController(withIdentifier:"MapVCID" ) as! MapVC
        MapVC.carListArray = Datasource
        self.navigationController?.pushViewController(MapVC, animated: true)

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
extension HomeVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Datasource.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(isUpdateAvailable)
        {
            return 44
        }
        else
        {
            return 0.0001

        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(isUpdateAvailable)
        {
        let cell:UpdatetableViewCell  = tableView.dequeueReusableCell(withIdentifier: "UpdatetableViewCellID") as! UpdatetableViewCell
            
        return cell
        }
        return nil
     }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HometableViewCell  = tableView.dequeueReusableCell(withIdentifier: "HometableViewCellID") as! HometableViewCell
        cell.selectionStyle = .none
        cell.map_Btn.tag = indexPath.row
         cell.wrapperView.dropShadow()
        let objRecord:CarRecord = Datasource[indexPath.row] as! CarRecord
        cell.carname.text = "\(objRecord.car_make) \(objRecord.car_model) \(objRecord.year)"
 
        cell.SetRatingView(value: CGFloat(Double(objRecord.rating)!))
 
         cell.priceperday.text = Themes.sharedInstance.Getcurrency() + "\(objRecord.rent_daily)"
        cell.priceperweek.text = Themes.sharedInstance.Getcurrency() + "\(objRecord.rent_weekly)"
        cell.pricepermonth.text = Themes.sharedInstance.Getcurrency() + "\(objRecord.rent_monthly)"
        cell.carimage.sd_setImage(with: URL(string:objRecord.car_singleimage), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))
        cell.map_Btn.sd_setImage(with: URL(string:objRecord.user_image), for: .normal, placeholderImage: #imageLiteral(resourceName: "avatar"))
        cell.vin_number.text = "VIN Number: \(objRecord.vin_no)"
        cell.vehicle_no.isHidden =   Validator.isEmpty().apply(objRecord.v_no)
        cell.vehicle_no.text = "Vehicle Number: \(objRecord.v_no)"
        
        cell.bannerLbl.label.textColor = UIColor.white
        cell.bannerLbl.label.font = UIFont(name: Constant.sharedinstance.Regular, size: 11)
        cell.bannerLbl.rotate(angle: 310)

        if(objRecord.tag.count > 0)
        {
            cell.bannerLbl.labelText = objRecord.tag
            cell.bannerLbl.isHidden = false
            cell.offer_tag.isHidden = false
            cell.bannerLbl.startAnimate()
            cell.bannerLbl.resumeAnimate()
        }
        else
       {
        cell.bannerLbl.isHidden = true
        cell.offer_tag.isHidden = true
        cell.bannerLbl.pauseAnimate()
        }
          return cell
     }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        objFilterRecord.toDate = Themes.sharedInstance.CheckNullvalue(Passed_value: toLbl.text!)
        objFilterRecord.fromdate = Themes.sharedInstance.CheckNullvalue(Passed_value: fromLbl.text!)
        objFilterRecord.Fromdate = Fromdate
        objFilterRecord.Todate = Todate
          let objCardetailVC = storyboard?.instantiateViewController(withIdentifier:"CardetailVCID" ) as! CardetailVC
        objCardetailVC.objFilterRecord = objFilterRecord
        objCardetailVC.objRecord = Datasource[indexPath.row] as! CarRecord
          self.navigationController?.pushViewController(objCardetailVC, animated: true)
     }
 }
extension HomeVC:WWCalendarTimeSelectorProtocol
{

func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
 
    if(!isChoosenFromDate)
    {
        Todate = date
        toLbl.text = Themes.sharedInstance.convertDateFormater(date)
    }
    else
    {
        Fromdate = date
        toLbl.text = ""
        fromLbl.text = Themes.sharedInstance.convertDateFormater(date)
        Todate = self.generateDates(fromDate: Fromdate!, value: 7)
        toLbl.text = Themes.sharedInstance.convertDateFormater(Todate!)

    }
 }

func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
    
    if(!isChoosenFromDate)
    {
        let From_date:Date = self.generateDates(fromDate: Fromdate!, value: 7)
        if(date.isBetween(From_date, and: self.generateDates(fromDate: From_date, value: 7)))
    {
        return true
    }
    }
    else
    
    {
        if(date.isBetween(Date(), and: self.generateDates(fromDate: Date(), value: 7)))
        {
            
             return true
        }

    }
    return false
}
   
func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
    print("Selected Multiple Dates \n\(dates)\n---")
    multipleDates = dates
}
}
extension HomeVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        print(prediction.placeID)
        if(prediction.placeID != nil)
        {
           
                self.loc_Lbl.text = String(describing:"\(String(describing:  prediction.attributedFullText.string))")
                objFilterRecord.location = self.loc_Lbl.text!
                dismiss(animated: true) {
                    self.ShowSpinner()
                    self.initialiseParam()
                }
                dismiss(animated: true, completion: nil)
         }
     

        return true
    }
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
     }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
 }
extension HomeVC:LocationServiceDelegate
{
    func tracingLocation(_ currentLocation: CLLocation) {
        current_Location = currentLocation
        Latitude = "\(currentLocation.coordinate.latitude)"
        Longitude = "\(currentLocation.coordinate.longitude)"
     }
    
    func tracingLocationDidFailWithError(_ error: NSError) {
        
    }
    
    func ChangeStatus(_ Locstatus: CLAuthorizationStatus) {
        if(LocationService.sharedInstance.Locstatus == .denied || LocationService.sharedInstance.Locstatus == .restricted)
        {
            let NoLocVC = storyboard?.instantiateViewController(withIdentifier:"NoLocVCID" ) as! NoLocVC
            self.navigationController?.present(NoLocVC, animated: true, completion: nil)
         }
     }
 }

extension HomeVC: OTPVerifyVCDelegate
{
    func reloaddata() {
        
    }
}
extension HomeVC:FilterVCDelegate
{
    func AppplyFilter(objFilterRecord: FilterRecord) {
        tableView.isHidden = true
        self.ShowSpinner()
        advance_filter.setTitle("Reset Filter", for: .normal)
         initialiseParam()
    }
}
extension HomeVC:LocationVCProtocol
{
    func passingLocationData(addrLocation: String) {
        
        self.loc_Lbl.text = String(describing:"\(String(describing:  addrLocation))")
        objFilterRecord.location = self.loc_Lbl.text!
        self.ShowSpinner()
        self.initialiseParam()
    }
}
