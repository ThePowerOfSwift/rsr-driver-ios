//
//  DriverClaimVC.swift
//  RideShare Rental
//
//  Created by CasperoniOS on 14/08/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import GooglePlaces
import GoogleMaps
import ActionSheetPicker_3_0
import SwiftValidators

class DriverClaimVC: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var claimcheckbox: UIButton!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var claimphone: CustomTextfield!
    @IBOutlet weak var claimdate: CustomTextfield!
    @IBOutlet weak var claimadd: CustomTextfield!
    @IBOutlet weak var claimname: CustomTextfield!
    @IBOutlet weak var descLbl: CustomTextfield!
    @IBOutlet weak var intersectionLbl: CustomTextfield!
    @IBOutlet weak var cartow: CustomTextfield!
    @IBOutlet weak var traffic: UIButton!
    @IBOutlet weak var moderate: UIButton!
    @IBOutlet weak var heavy: UIButton!
    @IBOutlet weak var sunny: UIButton!
    @IBOutlet weak var snow: UIButton!
    @IBOutlet weak var fog: UIButton!
    @IBOutlet weak var rain: UIButton!
    @IBOutlet weak var airbagno: UIButton!
    @IBOutlet weak var airbagyes: UIButton!
    @IBOutlet weak var cardrivableno: UIButton!
    @IBOutlet weak var cardrivableyes: UIButton!
    @IBOutlet weak var carvin: CustomTextfield!
    @IBOutlet weak var policedept: CustomTextfield!
    @IBOutlet weak var policereport: CustomTextfield!
    @IBOutlet weak var injuredFld: CustomTextfield!
    @IBOutlet weak var pasengerFld: CustomTextfield!
    @IBOutlet weak var driverlicenseFld: CustomTextfield!
    
     @IBOutlet weak var uberno: UIButton!
    @IBOutlet weak var uberyes: UIButton!
    @IBOutlet weak var dateFld: CustomTextfield!
    @IBOutlet weak var cellFld: CustomTextfield!
    @IBOutlet weak var phoneFld: CustomTextfield!
    @IBOutlet weak var emailFld: CustomTextfield!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet var date_timelbl: CustomTextfield!
    @IBOutlet var accidentaddress: CustomTextfield!
    @IBOutlet weak var addressFld: CustomTextfield!
    @IBOutlet weak var nameFld: CustomTextfield!
    @IBOutlet weak var lyftyes: UIButton!
    @IBOutlet weak var lyftno: UIButton!
    var isfromClaimAdd:Bool = Bool()
    var Accidentaddess:Bool = Bool()
    var isuberMode:Bool = Bool()
    var islyftmode:Bool = Bool()
    
    var iscardrivable:Bool = Bool()
    var isairbag:Bool = Bool()
    var isAccept:Bool = Bool()
    var isClaimAccept:Bool = Bool()


    var drivingcondition:String = ""
    var trafficcondition:String = ""
    var isfromLogin:Bool = Bool()

    
    var uberMode:String = ""
    var lyftMode:String = ""
    var cardrivable:String = ""
    var airbag:String = ""

    var pedestrian:String = ""

    @IBOutlet weak var HeaderLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addressFld.isEnabled = false
        dateFld.isEnabled = false
        isuberMode = true
        islyftmode = false
        iscardrivable = true
        isairbag = false
        phoneFld.doneAccessory = true
        claimphone.doneAccessory = true
        
        uberMode = "Yes"
        lyftMode  = "No"
        cardrivable  = "Yes"
        airbag  = "No"
        if(!isfromLogin)
        {
            backBtn.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
          HeaderLbl.text =  "Report an accident"
        }
        
        

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
    scrollView.contentSize.height = checkbox.frame.origin.y +  checkbox.frame.size.height+100
    }
    @IBAction func didclickclaimdate(_ sender: Any) {
        
        let datePicker = ActionSheetDatePicker(title: "Choose DOB", datePickerMode: UIDatePickerMode.date, selectedDate: self.generateDates(fromDate: Date(), value: -18), doneBlock: {
            picker, value, index in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            dateFormatter.dateFormat = "MM/dd/yyyy"
            var date:Date = value as! Date
            self.claimdate.text = dateFormatter.string(from: date)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        datePicker?.minimumDate = self.generateDates(fromDate: Date(), value: -100)
        
        datePicker?.maximumDate = Date()
        datePicker?.show()
        
    }
    @IBAction func didclickclaimcheckbox(_ sender: Any) {
        isClaimAccept = !isClaimAccept
        claimcheckbox.setImage(isClaimAccept == true ? #imageLiteral(resourceName: "check")  :#imageLiteral(resourceName: "uncheck"), for: .normal)
         pedestrian = (isClaimAccept == true) ? "Yes":"No"

     }
    
    @IBAction func didcliskAddress(_ sender: Any) {
    }
    
    @IBAction func didClickDateandtime(_ sender: Any) {
    }
    
    @IBAction func didclickclaimadd(_ sender: Any) {
        isfromClaimAdd = true

        
        let locVC = storyboard?.instantiateViewController(withIdentifier:"LocationVCID" ) as! LocationVC
        locVC.delegate = self
        self.navigationController?.pushViewController(locVC, animated: true)
        
        
        


    }
    @IBAction func didclicklyftmode(_ sender: Any) {
        islyftmode = !islyftmode
        lyftyes.setImage(islyftmode == true ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        lyftno.setImage(islyftmode == false ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        
        lyftMode  = (islyftmode == true) ? "Yes":"No"

    }
    @IBAction func didclickubermode(_ sender: Any) {
        isuberMode = !isuberMode
        uberyes.setImage(isuberMode == true ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        uberno.setImage(isuberMode == false ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        uberMode = (isuberMode == true) ? "Yes":"No"

     }
    
    @IBAction func didclickDate(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "Choose DOB", datePickerMode: UIDatePickerMode.date, selectedDate: self.generateDates(fromDate: Date(), value: -18), doneBlock: {
            picker, value, index in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            dateFormatter.dateFormat = "MM/dd/yyyy"
            var date:Date = value as! Date
            self.dateFld.text = dateFormatter.string(from: date)
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
    @IBAction func didclickAddress(_ sender: Any) {
        isfromClaimAdd = false
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        present(autocompleteController, animated: true, completion: nil)
        
        
        
        let locVC = storyboard?.instantiateViewController(withIdentifier:"LocationVCID" ) as! LocationVC
        locVC.delegate = self
        self.navigationController?.pushViewController(locVC, animated: true)
        
        
        
        
       
        

    }
    @IBAction func didclickdrivable(_ sender: Any) {
        iscardrivable = !iscardrivable
        cardrivableyes.setImage(iscardrivable == true ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        cardrivableno.setImage(iscardrivable == false ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        cardrivable = (iscardrivable == true) ? "Yes":"No"



    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didclickairbag(_ sender: Any) {
        isairbag = !isairbag
        airbagyes.setImage(isairbag == true ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        airbagno.setImage(isairbag == false ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        airbag  = (isairbag == true) ? "Yes":"No"
     }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
      */
    
    @IBAction func didclickback(_ sender: Any) {
        if(!isfromLogin)
        {
        self.findHamburguerViewController()?.showMenuViewController()
         }
        else{
        self.navigationController?.popViewController(animated: true)
         }
     }
    @IBAction func didclickdrivingcondtion(_ sender: Any) {
        let Btn:UIButton = sender as! UIButton
        heavy.setImage(#imageLiteral(resourceName: "greenunselect"), for: .normal)
        moderate.setImage(#imageLiteral(resourceName: "greenunselect"), for: .normal)
        traffic.setImage(#imageLiteral(resourceName: "greenunselect"), for: .normal)

        if(Btn.tag == 1)
        {
            trafficcondition = "Heavy"
            heavy.setImage(#imageLiteral(resourceName: "greenselect"), for: .normal)

        }
        if(Btn.tag == 2)
        {
            trafficcondition = "Moderate"
            moderate.setImage(#imageLiteral(resourceName: "greenselect"), for: .normal)


        }
        if(Btn.tag == 3)
        {
            trafficcondition = "No Traffic"
            traffic.setImage(#imageLiteral(resourceName: "greenselect"), for: .normal)


        }
        
    }
    @IBAction func didclickweather(_ sender: Any) {
        let Btn:UIButton = sender as! UIButton
        rain.setImage(#imageLiteral(resourceName: "greenunselect"), for: .normal)
        fog.setImage(#imageLiteral(resourceName: "greenunselect"), for: .normal)
        snow.setImage(#imageLiteral(resourceName: "greenunselect"), for: .normal)
        sunny.setImage(#imageLiteral(resourceName: "greenunselect"), for: .normal)

         if(Btn.tag == 1)
        {
            drivingcondition = "Raining"
            rain.setImage(#imageLiteral(resourceName: "greenselect"), for: .normal)

        }
        if(Btn.tag == 2)
        {
            drivingcondition = "Fog"
            fog.setImage(#imageLiteral(resourceName: "greenselect"), for: .normal)

        }
        if(Btn.tag == 3)
        {
            drivingcondition = "Snow"
            snow.setImage(#imageLiteral(resourceName: "greenselect"), for: .normal)


        }
        if(Btn.tag == 4)
        {
            drivingcondition = "Sunny"
            sunny.setImage(#imageLiteral(resourceName: "greenselect"), for: .normal)


        }
    }
    
    @IBAction func didclicksubmit(_ sender: Any) {
        if(Validator.isEmpty().apply(nameFld.text!))
        {
            nameFld.becomeFirstResponder()
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the name")

        }
        else if(Validator.isEmpty().apply(emailFld.text!))
        {
            emailFld.becomeFirstResponder()
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the email address")
            
        }
        else if(Validator.isEmpty().apply(carvin.text!))
        {
            carvin.becomeFirstResponder()
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the car vin no")
            
        }
        else if(!isAccept)
        {
             Themes.sharedInstance.showErrorpopup(Msg: "Kindly acknowledge the above mentined details is true")
            
        }
        else if(Validator.isEmpty().apply(date_timelbl.text!))
        {
            date_timelbl.becomeFirstResponder()
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the Date and Time of accident")
            
        }
        else if(Validator.isEmpty().apply(accidentaddress.text!))
        {
            accidentaddress .becomeFirstResponder()
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the Place of accident")
            
        }
            
            
        else
        {
             let param:[String : String] = ["driver_name":Themes.sharedInstance.CheckNullvalue(Passed_value:nameFld.text),"address":Themes.sharedInstance.CheckNullvalue(Passed_value:addressFld.text),"email":Themes.sharedInstance.CheckNullvalue(Passed_value:emailFld.text),"phone":Themes.sharedInstance.CheckNullvalue(Passed_value:phoneFld.text),"cell":Themes.sharedInstance.CheckNullvalue(Passed_value:cellFld.text),"date_of_birth":Themes.sharedInstance.CheckNullvalue(Passed_value:dateFld.text),"driver_licence":Themes.sharedInstance.CheckNullvalue(Passed_value:driverlicenseFld.text),"uber_mode":Themes.sharedInstance.CheckNullvalue(Passed_value:uberMode),"lyft_mode":Themes.sharedInstance.CheckNullvalue(Passed_value:lyftMode),"passengers":Themes.sharedInstance.CheckNullvalue(Passed_value:pasengerFld.text),"any_injuries":Themes.sharedInstance.CheckNullvalue(Passed_value:injuredFld.text),"police_report":Themes.sharedInstance.CheckNullvalue(Passed_value:policereport.text),"police_dept":Themes.sharedInstance.CheckNullvalue(Passed_value:policedept.text),"vin_no":Themes.sharedInstance.CheckNullvalue(Passed_value:carvin.text),"drivable":Themes.sharedInstance.CheckNullvalue(Passed_value:cardrivable),"air_bag_deployed":Themes.sharedInstance.CheckNullvalue(Passed_value:airbag),"drive_condition":Themes.sharedInstance.CheckNullvalue(Passed_value:drivingcondition),"traffic_condition":Themes.sharedInstance.CheckNullvalue(Passed_value:trafficcondition),"where_the_car_tow":Themes.sharedInstance.CheckNullvalue(Passed_value:cartow.text),"intersection_location":Themes.sharedInstance.CheckNullvalue(Passed_value:intersectionLbl.text),"description_of_incident":Themes.sharedInstance.CheckNullvalue(Passed_value:descLbl.text),"pedestrian":Themes.sharedInstance.CheckNullvalue(Passed_value:pedestrian),"pedestrian_name":Themes.sharedInstance.CheckNullvalue(Passed_value:claimname.text),"pedestrian_address":Themes.sharedInstance.CheckNullvalue(Passed_value:claimadd.text),"pedestrian_dob":Themes.sharedInstance.CheckNullvalue(Passed_value:claimdate.text),"pedestrian_phone":Themes.sharedInstance.CheckNullvalue(Passed_value:claimphone.text),"place_of_accident":Themes.sharedInstance.CheckNullvalue(Passed_value:accidentaddress.text),"date_of_accident":Themes.sharedInstance.CheckNullvalue(Passed_value:date_timelbl.text)]
            self.addDriverClaim(Param: param)
            
          

        }

    }
    func addDriverClaim(Param:[String:String])
    {
    Themes.sharedInstance.activityView(View: self.view)
    URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.save_driver_claim as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
        self.navigationController?.popViewController(animated: true)
        if(!self.isfromLogin)
        {
            Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "HomeVCID")

        }
    
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
    @IBAction func didclicktime_dateformat(_ sender: Any) {
        self.createDatePickerViewWithAlertController()
    }
    
    
    
    func SetDatePicker(Picker : UIDatePicker!){
        Picker.datePickerMode = .dateAndTime
        Picker.backgroundColor = .white
       
        let todaysDate = Date()
        Picker.maximumDate = todaysDate
      Picker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        
      
        
       
     
        
        
    }

      
        
        
   
    func createDatePickerViewWithAlertController()
    {
        let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        self.SetDatePicker(Picker: datePicker)
        var pickerFrame = datePicker.frame
        pickerFrame.size.height = datePicker.frame.size.height - 50
        pickerFrame.size.width = self.view.frame.size.width
        datePicker.frame = pickerFrame
        datePicker.datePickerMode = .dateAndTime
      
        alertController.view.addSubview(datePicker)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "Done", style: .default)
        { (action) in
            self.dateSelected(Picker: datePicker)
        }
        alertController.addAction(OKAction)
        view.window?.rootViewController?.present(alertController, animated: true)
    }
    func dateSelected(Picker : UIDatePicker!)
    {
        var selectedDate = String()
       
        selectedDate =  self.dateformatterDateTime(date: (Picker?.date)!)

       date_timelbl.text = selectedDate
    }
    func dateformatterDateTime(date: Date) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
      
        return dateFormatter.string(from: date)
    }
    
    
    
    
    
    @IBAction func didclickaddressaccident(_ sender: Any) {
     
        Accidentaddess = true
    
        
        let locVC = storyboard?.instantiateViewController(withIdentifier:"LocationVCID" ) as! LocationVC
        locVC.delegate = self
        self.navigationController?.pushViewController(locVC, animated: true)
    }
    @IBAction func didclickCheckbox(_ sender: Any) {
        isAccept = !isAccept
        checkbox.setImage(isAccept == true ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "uncheck"), for: .normal)

    }
}
extension DriverClaimVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
         print("Place address: \(place.formattedAddress)")
        let addressComponents = place.addressComponents
        let street_Fld:String = place.formattedAddress!
        if(addressComponents != nil)
        {
            if(!isfromClaimAdd)
            {
                addressFld.text = place.formattedAddress!

            }
            else
            {
                claimadd.text = place.formattedAddress!


            }

           
        dismiss(animated: true, completion: nil)
    }
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

extension DriverClaimVC:LocationVCProtocol
{
    func passingLocationData(addrLocation: String) {
        
        if(Accidentaddess)
        {
            accidentaddress.text = String(describing:"\(String(describing:  addrLocation))")
            Accidentaddess = false
            return
        }
        
        
        if(!isfromClaimAdd)
        {
            addressFld.text = String(describing:"\(String(describing:  addrLocation))")
            
        }
        else
        {
            claimadd.text = String(describing:"\(String(describing:  addrLocation))")
            
            
        }
    }
}
