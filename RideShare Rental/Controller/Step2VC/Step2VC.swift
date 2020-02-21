//
//  Step2VC
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import ActionSheetPicker_3_0
import GooglePlaces
import GoogleMaps
import SwiftValidators
import MapKit
import Alamofire
import SwiftyJSON



class Step2VC: UIViewController {
    @IBOutlet var centreView: UIView!
    @IBOutlet var from_date: CustomLabel!
    @IBOutlet var city_Fld: CustomTextfield!
    @IBOutlet var state_fld: CustomTextfield!
    @IBOutlet var check_box: UIButton!
    @IBOutlet var bythis: CustomLabel!
    @IBOutlet var zip_fld: CustomTextfield!
     @IBOutlet var street_fld: CustomTextfield!
    @IBOutlet var house_Fld: CustomTextfield!
    @IBOutlet var phone_Fld: CustomTextfield!
    @IBOutlet var last_fld: CustomTextfield!
    @IBOutlet var first_fld: CustomTextfield!
    @IBOutlet var detail_upload_Lbl: CustomLabel!
    @IBOutlet var upload_btn: UIButton!
    @IBOutlet var end_date: UITextField!
    @IBOutlet var start_date: CustomLabel!
    @IBOutlet var license_Fld: CustomTextfield!
    @IBOutlet var price_Lbl: CustomLabel!
    @IBOutlet var bottom_View: UIView!
    @IBOutlet var scroll_View: TPKeyboardAvoidingScrollView!
    @IBOutlet var to_date: CustomLabel!
    @IBOutlet var fromdate: CustomTextfield!
    @IBOutlet var carowner_Lbl: CustomLabel!
    @IBOutlet var carname_lbl: CustomLabel!
     var licenseimg:String = String()
    
    var objBookRecord:BookRecord = BookRecord()
    var carRecord:CarRecord = CarRecord()
    
     var picker = UIImagePickerController()
    var LicenseData:Data?
    var isacceptfee:Bool = Bool()
    
    var priceArr:NSMutableArray = NSMutableArray()
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fromDate:String = objBookRecord.fromdate.replacingOccurrences(of: "-", with: "/")
        let Todate:String = objBookRecord.todate.replacingOccurrences(of: "-", with: "/")
        
        from_date.text = fromDate
        to_date.text = Todate
        
        objBookRecord.fromdate = fromDate
        objBookRecord.todate = Todate
        
        let param:[String : String] = ["date_from":fromDate,"date_to":Todate,"carId":objBookRecord.carid,"deductible":objBookRecord.deductid]
        picker.delegate = self

        self.GetHomedata(Param: param)
        street_fld.isEnabled = false

          street_fld.isEnabled = false
        self.upload_btn.layer.cornerRadius = 3.0

        upload_btn.imageView?.contentMode = .scaleAspectFill;
        upload_btn.clipsToBounds = true
        
        phone_Fld.doneAccessory = true
        
    self.fromdate.isEnabled = false

license_Fld.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func GetHomedata(Param:[String:String])
    {
        scroll_View.isHidden = true
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.pricing as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
             if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        self.scroll_View.isHidden = false
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
    
    func UploadLicense()
    
    {
        var Dict:[String:Data] = [:]
        
            Dict.updateValue(LicenseData!, forKey: "licence_image")
            
         Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.Upload_File(url: Constant.sharedinstance.save_licence_image as String, parameters: [:], imageparam: Dict, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "msg")), isSuccess: true)
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
        let driverDetails:NSDictionary = responseDict?.object(forKey: "driverDetails") as!  NSDictionary
        if(driverDetails.count > 0)
        {
            first_fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "firstname"))
            last_fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "lastname"))
            phone_Fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "phone_no"))
            house_Fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "apt_no"))
            street_fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "address"))
            
             zip_fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "zip"))
            
            carname_lbl.text = "\(carRecord.car_make) \(carRecord.car_model) \(carRecord.year)"
            carowner_Lbl.text = "\(carRecord.firstname) \(carRecord.lastname)"

            license_Fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "licence_number"))
            upload_btn.sd_setImage(with: URL(string:Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "licence_image"))), for: .normal, placeholderImage: #imageLiteral(resourceName: "upload"))
            fromdate.text  = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "birthday"))
            end_date.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "licence_exp_date"))
            licenseimg = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "licence_image"))
            state_fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "state"))
            city_Fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: driverDetails.object(forKey: "city"))
        }
        
        let pricingDetails:NSArray = responseDict?.object(forKey: "pricingArr") as!  NSArray
        if(pricingDetails.count > 0)
        {
            for i in 0..<pricingDetails.count
            {
                let dict:NSDictionary = pricingDetails[i] as! NSDictionary
                if(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "key")) == "Total")
                {
                    objBookRecord.total_amount = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "value"))
                    price_Lbl.text = Themes.sharedInstance.Getcurrency() + " " + objBookRecord.total_amount
                    bythis.text = "By checking this box you agree to pay \(price_Lbl.text!) and agree to the terms and conditions."
                 }
                
            }
            
            priceArr = NSMutableArray(array: pricingDetails as! [Any])
        }
 
        
     }
    override func viewDidLayoutSubviews() {
        bottom_View.frame.origin.y = centreView.frame.size.height+centreView.frame.origin.y+1
        scroll_View.contentSize.height = self.bottom_View.frame.origin.y+self.bottom_View.frame.size.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickCheckBox(_ sender: Any) {
        isacceptfee = !isacceptfee
        check_box.setImage(isacceptfee == true ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "uncheck"), for: .normal)
    }
    @IBAction func DidclcikBack(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    @IBAction func DidClickPriceBreakDown(_ sender: Any) {
        let PriceBreakDownVC = storyboard?.instantiateViewController(withIdentifier:"PriceBreakDownVCID" ) as! PriceBreakDownVC
        PriceBreakDownVC.carRecord = carRecord
        PriceBreakDownVC.objBookRecord = objBookRecord
        PriceBreakDownVC.priceArr = NSMutableArray(array: priceArr.mutableCopy() as! [Any])
   
        self.navigationController?.present(PriceBreakDownVC, animated: true, completion: nil)
    }
    
    @IBAction func DidclickFrom(_ sender: Any) {
        self.view.endEditing(true)
         if((sender as! UIButton).tag == 0)
        {
             let datePicker = ActionSheetDatePicker(title: "Choose Expiry date", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
                picker, value, index in
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
                dateFormatter.dateFormat = "MM/dd/yyyy"
                var date:Date = value as! Date
                self.fromdate.text = dateFormatter.string(from: date)

                return
            }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
            
            datePicker?.minimumDate = Date()
            datePicker?.maximumDate = self.generateDates(fromDate:  Date(), value: 30)
            datePicker?.show()
        }
        else if((sender as! UIButton).tag == 1)
        {
            let datePicker = ActionSheetDatePicker(title: "Choose DOB", datePickerMode: UIDatePickerMode.date, selectedDate: self.generateYear(fromDate: Date(), value: -18), doneBlock: {
                picker, value, index in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
                dateFormatter.dateFormat = "MM/dd/yyyy"
              
                 let date:Date = value as! Date
                  self.end_date.text = dateFormatter.string(from: date)
                return
            }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
            datePicker?.minimumDate = self.generateDates(fromDate: Date(), value: -100)
             datePicker?.maximumDate = Date()
            datePicker?.show()

        }
    }
    
    func generateDates(fromDate:Date,value : Int) -> Date {
        
        let today = fromDate
        let tomorrow = Calendar.current.date(byAdding: .year, value: value, to: today)
       return tomorrow!
    }
    @IBAction func DidclickState(_ sender: Any) {
        
        /*
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        if(LocationService.sharedInstance.currentLocation?.coordinate != nil)
        {
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake((LocationService.sharedInstance.currentLocation?.coordinate.latitude)!, (LocationService.sharedInstance.currentLocation?.coordinate.longitude)!)
        let radius: Float = 25 * 1000
        //radius in meters (25km)
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(center, CLLocationDistance(radius * 2), CLLocationDistance(radius * 2))
        let northEast: CLLocationCoordinate2D = CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta / 2, region.center.longitude - region.span.longitudeDelta / 2)
        let southWest: CLLocationCoordinate2D = CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta / 2, region.center.longitude + region.span.longitudeDelta / 2)
        
        let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            autocompleteController.autocompleteBounds = bounds

        }
 
        present(autocompleteController, animated: true, completion: nil)
 */
        
        let locVC = storyboard?.instantiateViewController(withIdentifier:"LocationVCID" ) as! LocationVC
        locVC.delegate = self
        self.navigationController?.pushViewController(locVC, animated: true)
    }
    
    @IBAction func DidclickUploadLicense(_ sender: Any) {
        
        self.openPicker()

    }
    func openPicker()
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
        }
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    func openGallary()
    {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func DidclickNext(_ sender: Any) {
        
        if(Validator.isEmpty().apply(license_Fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the license number")
         }
        else if(Validator.isEmpty().apply(end_date.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter dob")

         }
        else if(Validator.isEmpty().apply(fromdate.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter expire date")

         }
        else if(Validator.isEmpty().apply(first_fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter First name")

        }
        else if(Validator.isEmpty().apply(last_fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter last name")
            
        }
        else if(Validator.maxLength(9).apply(phone_Fld.text) || Validator.minLength(15).apply(phone_Fld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter valid phone number")
        }
         else if(Validator.isEmpty().apply(street_fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter street address")
            
        }
       else if(Validator.isEmpty().apply(zip_fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the zip code")
            
        }
      
        else if(!isacceptfee)
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly accept the fee")
        }
        else
        {
            let profReocrd:ProfileRecord = ProfileRecord()
            profReocrd.firstname = first_fld.text!
            profReocrd.lastname = last_fld.text!
            profReocrd.licence_number =  license_Fld.text!
            profReocrd.licence_exp_date = fromdate.text!
            profReocrd.phone_no = phone_Fld.text!
            profReocrd.apt_no = house_Fld.text!
            profReocrd.birthday = end_date.text!
            profReocrd.address = street_fld.text!
            profReocrd.state = state_fld.text!
            profReocrd.city = city_Fld.text!
            profReocrd.zip = zip_fld.text!
            objBookRecord.carname = carRecord.car_make
            objBookRecord.carmodel = carRecord.car_model
            objBookRecord.caryear = carRecord.year
          let PaymentVC = storyboard?.instantiateViewController(withIdentifier:"Step3VCID" ) as! Step3VC
        PaymentVC.profReocrd = profReocrd
        PaymentVC.objBookRecord = objBookRecord
        self.navigationController?.pushViewController(PaymentVC, animated: true)
        }

    }
}

extension Step2VC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        let data = UIImageJPEGRepresentation(image, 0.7)
             LicenseData = data
            upload_btn.setImage(image, for: .normal)
        AJAlertController.initialization().showAlert(aStrMessage: "Are you sure you want to upload the document?",
                                                     aCancelBtnTitle: "NO",
                                                     aOtherBtnTitle: "YES")
        { (index, title) in
            if(index == 1)
            {
                 picker .dismiss(animated: true, completion: nil)
                self.UploadLicense()
             }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension Step2VC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        var streetFld:String = place.formattedAddress!
 
        let addressComponents = place.addressComponents
        if(addressComponents != nil)
        {
            
        for component in addressComponents! {
            print(component.name)
            print(component.type)

            if component.type == "locality" {
                city_Fld.text = component.name
                
             }
           else if component.type == "administrative_area_level_1" {
                state_fld.text = component.name
                
            }
            else if component.type == "postal_code" {
                zip_fld.text = component.name
                
            }

         }
  

            street_fld.text = streetFld

        }

        dismiss(animated: true, completion: nil)
    }
    
    func generateYear(fromDate:Date,value : Int) -> Date {
        
        let today = fromDate
        let tomorrow = Calendar.current.date(byAdding: .year, value: value, to: today)
        return tomorrow!
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

extension Step2VC:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == license_Fld)
        {
             self.view.endEditing(true)
             return false

        }
        return true
    }
}
extension Step2VC:LocationVCProtocol
{
    func passingLocationData(addrLocation: String) {
        
        getAddress(address: addrLocation)
        street_fld.text = addrLocation
        
    }
    
    func getAddress(address:String){
        Themes.sharedInstance.activityView(View: self.view)
        let postParameters:[String: Any] = [ "address": address,"key":googleApiKey]
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        
        Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if let receivedResults = response.result.value
            {
                let resultParams = JSON(receivedResults)
                print(resultParams) // RESULT JSON
                print(resultParams["status"]) // OK, ERROR
                print(resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue) // approximately latitude
                print(resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue) // approximately longitude
                
                self.getAddressFromLatLong(latitude: resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue, longitude: resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue)
            }
        }
    }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        
        Themes.sharedInstance.activityView(View: self.view)
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(googleApiKey)"
        
        Alamofire.request(url).validate().responseJSON { response in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            switch response.result {
            case .success:
                
                let responseJson = response.result.value! as! NSDictionary
                
                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
                            let address = results[0]["formatted_address"] as? String
                            print(address ?? "")
                            for component in addressComponents {
                                if let temp = component.object(forKey: "types") as? [String] {
                                    if (temp[0] == "postal_code") {
                                        let pincode = component["long_name"] as? String
                                        print(pincode ?? "")
                                        self.zip_fld.text = pincode ?? ""
                                    }
                                    if (temp[0] == "locality") {
                                        let city = component["long_name"] as? String
                                        print(city ?? "")
                                        self.city_Fld.text = city ?? ""
                                    }
                                    if (temp[0] == "administrative_area_level_1") {
                                        let state = component["long_name"] as? String
                                        print(state ?? "")
                                        self.state_fld.text = state ?? ""
                                    }
                                    if (temp[0] == "country") {
                                        let country = component["long_name"] as? String
                                        print(country ?? "")
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
                Themes.sharedInstance.RemoveactivityView(View: self.view)
            }
        }
    }
    
    
}
