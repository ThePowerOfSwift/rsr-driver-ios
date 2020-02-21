//
//  ClaimantClaimVC.swift
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


class ClaimantClaimVC: UIViewController {
    @IBOutlet weak var carowner: CustomTextfield!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var cityFld: CustomTextfield!
    @IBOutlet weak var stateFld: CustomTextfield!
    @IBOutlet weak var incidentdate: CustomTextfield!
    @IBOutlet weak var vin: CustomTextfield!
    @IBOutlet weak var licenseplate: CustomTextfield!
    @IBOutlet weak var licensedlf: CustomTextfield!
    @IBOutlet weak var vehicleFld: CustomTextfield!
    @IBOutlet weak var carseat: CustomTextfield!
    @IBOutlet weak var timeFld: CustomTextfield!

    @IBOutlet weak var airbagno: UIButton!
    @IBOutlet weak var airbagyes: UIButton!
    @IBOutlet weak var driveno: UIButton!
    @IBOutlet weak var driveyes: UIButton!
    @IBOutlet weak var injureFld: CustomTextfield!
    @IBOutlet weak var insurFld: CustomTextfield!
    @IBOutlet weak var dateFld: CustomTextfield!
    @IBOutlet weak var cellFld: CustomTextfield!
    @IBOutlet weak var phoneFld: CustomTextfield!
    @IBOutlet weak var emailFld: CustomTextfield!
    @IBOutlet weak var addFld: CustomTextfield!
    @IBOutlet weak var nameFld: CustomTextfield!
    var iscardrivable:Bool = Bool()
    var isairbag:Bool = Bool()
    var cardrivable:String = ""
    var airbag:String = ""
    var isAccept:Bool = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        addFld.isEnabled =  false
        dateFld.isEnabled =  false
        incidentdate.isEnabled =  false
        iscardrivable = true
        isairbag = false
        cardrivable  = "Yes"
        airbag  = "No"

       // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        scrollView.contentSize.height = wrapperView.frame.origin.y +  wrapperView.frame.size.height+70
    }
    @IBAction func didclickincidentdate(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "Choose DOB", datePickerMode: UIDatePickerMode.date, selectedDate: self.generateDates(fromDate: Date(), value: -18), doneBlock: {
            picker, value, index in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            dateFormatter.dateFormat = "MM/dd/yyyy"
            var date:Date = value as! Date
            self.incidentdate.text = dateFormatter.string(from: date)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        datePicker?.minimumDate = self.generateDates(fromDate: Date(), value: -100)
        
        datePicker?.maximumDate = Date()
        datePicker?.show()
    }
    @IBAction func didclickairbag(_ sender: Any) {
        isairbag = !isairbag
        airbagyes.setImage(isairbag == true ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        airbagno.setImage(isairbag == false ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        airbag  = (isairbag == true) ? "Yes":"No"

    }
    @IBAction func didclickdrive(_ sender: Any) {
        iscardrivable = !iscardrivable
        driveyes.setImage(iscardrivable == true ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        driveno.setImage(iscardrivable == false ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect"), for: .normal)
        cardrivable = (iscardrivable == true) ? "Yes":"No"

    }
    
    @IBAction func didclickdate(_ sender: Any) {
        
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
    @IBAction func didclickaddFld(_ sender: Any) {
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        present(autocompleteController, animated: true, completion: nil)
        
        let locVC = storyboard?.instantiateViewController(withIdentifier:"LocationVCID" ) as! LocationVC
        locVC.delegate = self
        self.navigationController?.pushViewController(locVC, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didclicksubmit(_ sender: Any) {
        
          if(Validator.isEmpty().apply(nameFld.text!))
        {
            nameFld.becomeFirstResponder()
            Themes.sharedInstance.showErrorpopup(Msg: "Enter the name")
            
        }
        else if(!isAccept)
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Kindly acknowledge the above mentined details is true")
            
        }
        else
        {
            let param:[String : String] = ["driver_name":Themes.sharedInstance.CheckNullvalue(Passed_value:nameFld.text),"address":Themes.sharedInstance.CheckNullvalue(Passed_value:addFld.text),"email":Themes.sharedInstance.CheckNullvalue(Passed_value:emailFld.text),"phone":Themes.sharedInstance.CheckNullvalue(Passed_value:phoneFld.text),"cell":Themes.sharedInstance.CheckNullvalue(Passed_value:cellFld.text),"date_of_birth":Themes.sharedInstance.CheckNullvalue(Passed_value:dateFld.text),"owner_of_the_car":Themes.sharedInstance.CheckNullvalue(Passed_value:carowner.text),"insurance_company":Themes.sharedInstance.CheckNullvalue(Passed_value:insurFld.text),"passengers":Themes.sharedInstance.CheckNullvalue(Passed_value:injureFld.text),"drivable":Themes.sharedInstance.CheckNullvalue(Passed_value:cardrivable),"air_bag_deployed":Themes.sharedInstance.CheckNullvalue(Passed_value:airbag),"car_seats":Themes.sharedInstance.CheckNullvalue(Passed_value:carseat.text),"make_model_year":Themes.sharedInstance.CheckNullvalue(Passed_value:vehicleFld.text),"licence_dl":Themes.sharedInstance.CheckNullvalue(Passed_value:licensedlf.text),"licence_plate":Themes.sharedInstance.CheckNullvalue(Passed_value:licenseplate.text),"vin":Themes.sharedInstance.CheckNullvalue(Passed_value:vin.text),"date_of_incident":Themes.sharedInstance.CheckNullvalue(Passed_value:incidentdate.text),"time_of_incident":Themes.sharedInstance.CheckNullvalue(Passed_value:timeFld.text),"state":Themes.sharedInstance.CheckNullvalue(Passed_value:stateFld.text),"city":Themes.sharedInstance.CheckNullvalue(Passed_value:cityFld.text)]
             self.addClaimantClaim(Param: param)
        }
    }
    
    @IBAction func didclickCheckbox(_ sender: Any) {
        isAccept = !isAccept
        checkbox.setImage(isAccept == true ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "uncheck"), for: .normal)
        
    }
    
    func addClaimantClaim(Param:[String:String])
    {
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.save_claimant_claim as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
    
    @IBAction func didclickback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
extension ClaimantClaimVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place address: \(place.formattedAddress)")
        let addressComponents = place.addressComponents
        let street_Fld:String = place.formattedAddress!
        if(addressComponents != nil)
        {
                 addFld.text = place.formattedAddress!
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
extension ClaimantClaimVC:LocationVCProtocol
{
    func passingLocationData(addrLocation: String) {
        addFld.text = String(describing:"\(String(describing:  addrLocation))")
    }
}
