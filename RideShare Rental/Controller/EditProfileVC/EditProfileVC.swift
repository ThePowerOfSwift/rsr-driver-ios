//
//  EditProfileVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 15/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import ActionSheetPicker_3_0
import GooglePlaces
import GoogleMaps
import SDWebImage
import  CoreLocation
import MapKit
import SwiftValidators
import Alamofire
import SwiftyJSON


class EditProfileVC: UIViewController {
    @IBOutlet var bottomView: UIView!
    @IBOutlet var emailFld: CustomTextfield!
    @IBOutlet var licenseimg: UIButton!

    @IBOutlet var state_Fld: CustomTextfield!
    @IBOutlet var city_fld: CustomTextfield!
    @IBOutlet var lastnameFld: CustomTextfield!
    @IBOutlet var stateFld: CustomTextfield!
    @IBOutlet var expDate_fld: CustomTextfield!
    @IBOutlet var licenseFld: CustomTextfield!
    @IBOutlet var DobFld: CustomTextfield!
    @IBOutlet var nameFld: CustomTextfield!
    @IBOutlet var ZipFld: CustomTextfield!
    @IBOutlet var phoneFld: CustomTextfield!
    @IBOutlet var houseFld: CustomTextfield!
    @IBOutlet var streetFld: CustomTextfield!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var userimg: CustomimageView!
    
    var picker = UIImagePickerController()
    var isFromProfile:Bool!
    var objRecord:ProfileRecord  = ProfileRecord()
    
    var isimageChanged:Bool = Bool()
    var isfromBuild:Bool = Bool()

    var profPicData:Data?
    var LicenseData:Data?
    override func viewDidLoad() {
        super.viewDidLoad()
        userimg.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapProfPic(_:)))
        userimg.addGestureRecognizer(tapGesture)
        picker.delegate = self
        isFromProfile = false
        DobFld.isEnabled = false
        emailFld.isEnabled = false
        expDate_fld.isEnabled = false
        emailFld.textColor = UIColor.lightGray
        if(isfromBuild)
        {
           GetData()
        }
        else
        {
            SetView()

        }
        phoneFld.doneAccessory = true
        }
    
    
    func GetData()
    {
        scrollView.isHidden = true
        Themes.sharedInstance.activityView(View: self.view)
        
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.profile as String, param: [:], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                self.scrollView.isHidden = false
                
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
                        self.scrollView.isHidden = true
                        
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
        objRecord.address = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "address"))
        objRecord.apt_no = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "apt_no"))
        objRecord.background_check = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "background_check"))
        objRecord.id = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "id"))
        objRecord.id_verified = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "id_verified"))
        objRecord.licence_exp_date = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "licence_exp_date"))
        objRecord.licence_image = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "licence_image"))
        objRecord.licence_number = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "licence_number"))
        objRecord.licence_state = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "licence_state"))
        objRecord.phone_no = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "phone_no"))
        objRecord.profile_pic = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "profile_pic"))
        objRecord.state = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "state"))
        objRecord.zip = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "zip"))
        
        objRecord.firstname = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "firstname"))
        objRecord.birthday = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "birthday"))
        objRecord.city = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "city"))
        objRecord.country = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "country"))
        objRecord.lastname = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "lastname"))
        
      SetView()
        
    }
    func SetView()
    {
        nameFld.text = objRecord.firstname
        emailFld.text = Themes.sharedInstance.Getemail()
        phoneFld.text = objRecord.phone_no
        DobFld.text = objRecord.birthday
        streetFld.text = objRecord.address
        houseFld.text = objRecord.apt_no
        ZipFld.text = objRecord.zip
        licenseFld.text = objRecord.licence_number
        expDate_fld.text = objRecord.licence_exp_date
        stateFld.text = objRecord.state
        lastnameFld.text = objRecord.lastname
        city_fld.text = objRecord.city
        state_Fld.text = objRecord.state

        if(objRecord.licence_image != "")
        {
             licenseimg.sd_setImage(with: URL(string: objRecord.licence_image), for: .normal, placeholderImage: #imageLiteral(resourceName: "licence"))
        }
        if(objRecord.profile_pic != "")
        {
         userimg.sd_setImage(with: URL(string: objRecord.profile_pic), placeholderImage: #imageLiteral(resourceName: "avatar"))
        }
        
        licenseimg.imageView?.contentMode = .scaleAspectFill;
        licenseimg.clipsToBounds = true

     }
    @objc func tapProfPic(_ sender: UITapGestureRecognizer) {
        isFromProfile = true
        self.openPicker()

        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize.height = bottomView.frame.origin.y+bottomView.frame.size.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Didclickback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func DidclickSave(_ sender: Any) {
        if(Validator.isEmpty().apply(nameFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter First name")

        }
      else if(Validator.isEmpty().apply(lastnameFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter Last name")
            
        }
        else if(Validator.isEmpty().apply(lastnameFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter Last name")
            
        }
        else if(Validator.isEmpty().apply(phoneFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter phone number")
            
        }
        else if(Validator.maxLength(9).apply(phoneFld.text) || Validator.minLength(15).apply(phoneFld.text))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter valid phone number")
        }
        else if(Validator.isEmpty().apply(streetFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter street address")
            
        }
            
//        else if(Validator.isEmpty().apply(city_fld.text!))
//        {
//            Themes.sharedInstance.showErrorpopup(Msg: "Enter city")
//
//        }
//
//        else if(Validator.isEmpty().apply(state_Fld.text!))
//        {
//            Themes.sharedInstance.showErrorpopup(Msg: "Enter state")
//
//        }
       
        else if(Validator.isEmpty().apply(ZipFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the zip code")
            
        }
        else if(Validator.isEmpty().apply(expDate_fld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the expiration date")
            
        }
        else if(Validator.isEmpty().apply(licenseFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the license number")
            
        }
        else if(Validator.isEmpty().apply(stateFld.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the state")
            
        }
        else if(Validator.isEmpty().apply(objRecord.licence_image))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Upload the license document")
            
        }
        else if(Validator.isEmpty().apply(objRecord.profile_pic))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Upload the profile picture")
            
        }
        else
        {
            
     self.view.endEditing(true)
            
            let param:NSDictionary = ["firstname":Themes.sharedInstance.CheckNullvalue(Passed_value: nameFld.text!),"lastname":Themes.sharedInstance.CheckNullvalue(Passed_value: lastnameFld.text!),"gender":"","phone_no":Themes.sharedInstance.CheckNullvalue(Passed_value: phoneFld.text!),"birthday":Themes.sharedInstance.CheckNullvalue(Passed_value: DobFld.text!),"apt_no":Themes.sharedInstance.CheckNullvalue(Passed_value: houseFld.text!),"address":Themes.sharedInstance.CheckNullvalue(Passed_value: streetFld.text!),"zip":Themes.sharedInstance.CheckNullvalue(Passed_value: ZipFld.text!),"licence_number":Themes.sharedInstance.CheckNullvalue(Passed_value: licenseFld.text!),"licence_exp_date":Themes.sharedInstance.CheckNullvalue(Passed_value: expDate_fld.text!),"licence_state":Themes.sharedInstance.CheckNullvalue(Passed_value: stateFld.text!),"city":Themes.sharedInstance.CheckNullvalue(Passed_value: city_fld.text!),"state":Themes.sharedInstance.CheckNullvalue(Passed_value: objRecord.address)]
            
 
            self.UploadDetail(Param: param)

        }
    }
 
    
    func UploadDetail(Param:NSDictionary)
    {
        
           Themes.sharedInstance.activityView(View: self.view)
         URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.save_profile as String, param: Param as! [String : String], completionHandler: {(responseObject, error) ->  () in
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
    
    func UploadProfile()
        
    {
        var Dict:[String:Data] = [:]
        
        Dict.updateValue(profPicData!, forKey: "profile_image")
        
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.Upload_File(url: Constant.sharedinstance.save_profile_image as String, parameters: [:], imageparam: Dict, completionHandler: {(responseObject, error) ->  () in
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
    
    
    @IBAction func DidClickUpload(_ sender: Any) {
        isFromProfile = false
        openPicker()
    }
    @IBAction func Didclickhelp(_ sender: Any) {
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
    
    @IBAction func DidclickLicense(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "Choose Expiry date", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            dateFormatter.dateFormat = "MM/dd/yyyy"
            var date:Date = value as! Date
            self.expDate_fld.text = dateFormatter.string(from: date)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        
        datePicker?.minimumDate = Date()
        datePicker?.maximumDate = self.generateDates(fromDate:  Date(), value: 30)
        datePicker?.show()
        
    }

    @IBAction func DidclickDob(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "Choose DOB", datePickerMode: UIDatePickerMode.date, selectedDate: self.generateDates(fromDate: Date(), value: -18), doneBlock: {
            picker, value, index in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            dateFormatter.dateFormat = "MM/dd/yyyy"
            var date:Date = value as! Date
            self.DobFld.text = dateFormatter.string(from: date)
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        datePicker?.minimumDate = self.generateDates(fromDate: Date(), value: -100)

        datePicker?.maximumDate = Date()
        datePicker?.show()

    }
    
    func generateDates(fromDate:Date,value : Int) -> Date {
        
        let today = fromDate
        let tomorrow = Calendar.current.date(byAdding: .year, value: value, to: today)
        
        return tomorrow!
    }
    @IBAction func DidclickStreet(_ sender: Any) {
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
    
 }
extension EditProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
    
        
        AJAlertController.initialization().showAlert(aStrMessage: "Are you sure you want to upload?",
                                                     aCancelBtnTitle: "NO",
                                                     aOtherBtnTitle: "YES")
        { (index, title) in
            if(index == 1)
            {
                let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
                let data = UIImageJPEGRepresentation(image, 0.7)
                
                if(self.isFromProfile)
                {
                    self.self.profPicData = data
                    self.userimg.image = image
                    self.UploadProfile()
                    
                }
                else
                {
                    self.LicenseData = data
                    self.licenseimg.setImage(image, for: .normal)
                    self.UploadLicense()

                }
                self.isimageChanged = true

                 picker .dismiss(animated: true, completion: nil)

            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
         let addressComponents = place.addressComponents
        let street_Fld:String = place.formattedAddress!
          if(addressComponents != nil)
        {
           for component in addressComponents! {
                print(component.name)
                print(component.type)
                if component.type == "locality" {
                    city_fld.text = component.name
                 }
                else if component.type == "administrative_area_level_1" {
                    state_Fld.text = component.name
                 }
                else if component.type == "postal_code" {
                    ZipFld.text = component.name
                 
                }
              }
              streetFld.text = street_Fld
            objRecord.address = place.formattedAddress!
        }
        dismiss(animated: true, completion: nil)
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
extension EditProfileVC:LocationVCProtocol
{
    func passingLocationData(addrLocation: String) {
        
        getAddress(address: addrLocation)
        streetFld.text = addrLocation
        objRecord.address = addrLocation
        
    }
    
    func getAddress(address:String){
        Themes.sharedInstance.activityView(View: self.view)
        let postParameters:[String: Any] = [ "address": address,"key":googleApiKey]
        let url : String = "https://maps.googleapis.com/maps/api/geocode/json"
        
        Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in
            
            if let receivedResults = response.result.value
            {
                let resultParams = JSON(receivedResults)
                print(resultParams) // RESULT JSON
                print(resultParams["status"]) // OK, ERROR
                print(resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue) // approximately latitude
                print(resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue) // approximately longitude
                
                self.getAddressFromLatLong(latitude: resultParams["results"][0]["geometry"]["location"]["lat"].doubleValue, longitude: resultParams["results"][0]["geometry"]["location"]["lng"].doubleValue)
            }else{
                Themes.sharedInstance.RemoveactivityView(View: self.view)
            }
        }
    }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        
//        Themes.sharedInstance.activityView(View: self.view)
        
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
                                        self.ZipFld.text = pincode ?? ""
                                    }
                                    if (temp[0] == "locality") {
                                        let city = component["long_name"] as? String
                                        print(city ?? "")
                                        self.city_fld.text = city ?? ""
                                    }
                                    if (temp[0] == "administrative_area_level_1") {
                                        let state = component["long_name"] as? String
                                        print(state ?? "")
                                        self.state_Fld.text = state ?? ""
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

