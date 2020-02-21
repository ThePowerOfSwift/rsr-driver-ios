//
//  FilterVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 14/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import TTRangeSlider
import TPKeyboardAvoiding
import RangeSeekSlider
import SwiftValidators
import ActionSheetPicker_3_0
protocol FilterVCDelegate {
    func AppplyFilter(objFilterRecord:FilterRecord)
 
}

class FilterVC: UIViewController {

    @IBOutlet var year_slider: RangeSeekSlider!
    @IBOutlet var price_slider: RangeSeekSlider!
    @IBOutlet var mileageSlider: RangeSeekSlider!
    @IBOutlet var featureCollectionView: UICollectionView!
    @IBOutlet var carmodel_Fld: CustomTextfield!
    @IBOutlet var selection_Fld: CustomTextfield!
//    @IBOutlet var reservation_Fld: CustomTextfield!
    @IBOutlet var centreView: UIView!

    @IBOutlet var bottomView: UIView!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    var car_makes:NSArray = NSArray()
    var car_models:NSDictionary = NSDictionary()
    var carFeature:NSMutableArray = NSMutableArray()
    var car_makesval:NSMutableArray = NSMutableArray()
    var car_modelsval:NSMutableArray = NSMutableArray()
    var objFilterRecord:FilterRecord = FilterRecord()
     var delegate: FilterVCDelegate?
    
    var pricemax:CGFloat = CGFloat()
    var pricemin:CGFloat = CGFloat()
    var yearmax:CGFloat = CGFloat()
    var yearmin:CGFloat = CGFloat()
     var milmin:CGFloat = CGFloat()
    var milmax:CGFloat = CGFloat()

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
        let FeaturenibName = UINib(nibName: "FeatureCollectionViewCell", bundle:nil)
         featureCollectionView.register(FeaturenibName, forCellWithReuseIdentifier: "FeatureCollectionViewCellID")
        featureCollectionView.dataSource = self
        featureCollectionView.delegate = self
        SetSlider()
        pricemax = 0.0
        pricemin  = 0.0
        yearmax  = 0.0
        milmin  = 0.0
        milmax  = 0.0
        yearmin = 0.0
      }
     override func viewWillAppear(_ animated: Bool) {
        self.GetData()
    }
    
    func SetSlider()
    {
  
        price_slider.handleImage = #imageLiteral(resourceName: "darkslider")
        price_slider.selectedHandleDiameterMultiplier = 1.0
        price_slider.colorBetweenHandles = UIColor.darkGray
        price_slider.lineHeight = 5.0
        price_slider.numberFormatter.positivePrefix = Themes.sharedInstance.Getcurrency()
        price_slider.delegate = self


        mileageSlider.handleImage = #imageLiteral(resourceName: "darkslider")
        mileageSlider.selectedHandleDiameterMultiplier = 1.0
        mileageSlider.colorBetweenHandles = UIColor.darkGray
        mileageSlider.lineHeight = 5.0
        mileageSlider.delegate = self
        mileageSlider.numberFormatter.negativePrefix = "mi"

     
        year_slider.handleImage = #imageLiteral(resourceName: "darkslider")
        year_slider.selectedHandleDiameterMultiplier = 1.0
        year_slider.colorBetweenHandles = UIColor.darkGray
        year_slider.lineHeight = 5.0
        year_slider.delegate = self
        


    }
    func GetData()
    {
        scrollView.isHidden = true
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.more_filter as String, param: [:], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                self.scrollView.isHidden = false
                
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    
                        self.GetDetail(responseDict: resDict)
 
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
          carFeature = NSMutableArray()
        
          let feauArr = responseDict?.object(forKey: "carFeature") as? [[String:Any]]
        if((feauArr?.count)! > 0)
        {
            for Dict in feauArr!
           {
            let filterRecord:FilterRecord =  FilterRecord()
            filterRecord.isSelelcted = false
            filterRecord.id = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["id"])
            filterRecord.name = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["name"])
            carFeature.add(filterRecord)
            }
            featureCollectionView.reloadData()
        }
        let car_makeArr = responseDict?.object(forKey: "car_makes") as? [[String:Any]]

        if((car_makeArr?.count)! > 0)
        {
            for Dict in car_makeArr!
            {
                car_makesval.add(Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["name"]))
            }
            car_makes = car_makeArr! as NSArray
        }
       
        let car_modelsArr = responseDict?.object(forKey: "car_models") as? NSDictionary

        if((car_modelsArr?.count)! > 0)
        {
            car_models = car_modelsArr! as NSDictionary
        }
 
            self.price_slider.minValue = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "min_price")))!)
            self.price_slider.maxValue = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "max_price")))!)
            self.mileageSlider.minValue = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "min_milege")))!)
            self.mileageSlider.maxValue = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "max_milege")))!)
            self.year_slider.maxValue = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "max_year")))!)
            self.year_slider.minValue = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "min_year")))!)
            
            self.price_slider.selectedMinValue = self.price_slider.minValue
            self.price_slider.selectedMaxValue = self.price_slider.maxValue
            self.mileageSlider.selectedMinValue = self.mileageSlider.minValue
            self.mileageSlider.selectedMaxValue = self.mileageSlider.maxValue
            self.year_slider.selectedMinValue = self.year_slider.minValue
            self.year_slider.selectedMaxValue = self.year_slider.maxValue


            
 
        pricemax = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "max_price")))!)
        pricemin  = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "min_price")))!)
        yearmax  = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "max_year")))!)
        yearmin  = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "min_year")))!)

        milmin  = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "min_milege")))!)
        milmax  = CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: responseDict?.object(forKey: "max_milege")))!)
        
        
        
        year_slider.numberFormatter.numberStyle = .none
        
 
        featureCollectionView.isScrollEnabled = false

        if(UIScreen.main.bounds.size.height == 568)
        {
            featureCollectionView.frame.size.height = featureCollectionView.frame.size.height + 80

        }
        else
        {
            featureCollectionView.frame.size.height = featureCollectionView.frame.size.height + 50

        }
        centreView.frame.size.height = featureCollectionView.frame.size.height+featureCollectionView.frame.origin.y
        bottomView.frame.origin.y = centreView.frame.origin.y+centreView.frame.size.height-40
        self.scrollView.contentSize.height = bottomView.frame.origin.y+bottomView.frame.size.height
 
       }
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize.height = bottomView.frame.origin.y+bottomView.frame.size.height
    }
    @IBAction func DidclickDone(_ sender: Any) {
        let featureArr:NSMutableArray = NSMutableArray()
        for i in 0..<carFeature.count
        {
            let reocrd:FilterRecord = carFeature[i] as! FilterRecord
            if(reocrd.isSelelcted)
            {
                featureArr.add(reocrd.id)
            }
            
        }
        if(featureArr.count > 0)
        {
            objFilterRecord.features = (featureArr.mutableCopy() as! [String]).joined(separator: ",")
        }
        self.delegate?.AppplyFilter(objFilterRecord: objFilterRecord)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DidclickDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func didclickReservation(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "Choose Reservation", rows: ["2 days", "4 days", "6 days", "1 week", "1 month", "1 year"], initialSelection: 0, doneBlock: {
            picker, value, index in
//            self.reservation_Fld.text = index as? String
            self.objFilterRecord.Reservation = "\(String(describing: index))"
             return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)

    }
    @IBAction func DidclickCarMake(_ sender: Any) {
        Showcarmake(sender)
     }
    
func Showcarmake(_ sender: Any)
{
    ActionSheetStringPicker.show(withTitle: "Choose Car make", rows: car_makesval.mutableCopy() as! [Any], initialSelection: 0, doneBlock: {
        picker, value, index in
        self.selection_Fld.text = index as? String
        let Dict:NSDictionary = self.car_makes[value] as! NSDictionary
        self.objFilterRecord.car_make = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "id"))
        let Array:NSArray = self.car_models[self.objFilterRecord.car_make] as! NSArray
         if(Array.count > 0)
        {
            let mutDict:NSDictionary =  Array[0] as! NSDictionary
            self.carmodel_Fld.text = Themes.sharedInstance.CheckNullvalue(Passed_value: mutDict["name"])
            self.objFilterRecord.car_model = Themes.sharedInstance.CheckNullvalue(Passed_value: mutDict.object(forKey: "id"))

         }
        return
    }, cancel: { ActionStringCancelBlock in return }, origin: sender)

    }
    @IBAction func DidclickCarModel(_ sender: Any) {
        if(!Validator.isEmpty().apply(selection_Fld.text!) && !(Validator.isEmpty().apply(self.objFilterRecord.car_make)))
        {
            let Array:NSArray = car_models[self.objFilterRecord.car_make] as! NSArray
            car_modelsval.removeAllObjects()
            if(Array.count > 0)
            {
                for i in 0..<Array.count
                {
                    let Dict:NSDictionary =  Array[i] as! NSDictionary
                    car_modelsval.add(Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["name"]))
                }
             }
            
            ActionSheetStringPicker.show(withTitle: "Choose Car model", rows: car_modelsval.mutableCopy() as! [Any], initialSelection: 0, doneBlock: {
                picker, value, index in
                 let Dict:NSDictionary = Array[value] as! NSDictionary
                self.carmodel_Fld.text = index as? String
                  self.objFilterRecord.car_model = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "id"))
                 return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender)

        }
        else
        {
            Showcarmake(sender)
         }
    }
    @IBAction func Didclickreset(_ sender: Any) {
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
        for i in 0..<carFeature.count
        {
            let reocrd:FilterRecord = carFeature[i] as! FilterRecord
            if(reocrd.isSelelcted)
            {
                reocrd.isSelelcted = !reocrd.isSelelcted
            }
            
        }
        featureCollectionView.reloadData()
         price_slider.minValue = pricemin
        price_slider.maxValue = pricemax
        mileageSlider.minValue = milmin
        mileageSlider.maxValue = milmax
        year_slider.minValue = yearmin
        year_slider.maxValue = yearmax
        price_slider.selectedMinValue = pricemin
        price_slider.selectedMaxValue = pricemax
        mileageSlider.selectedMinValue = milmin
        mileageSlider.selectedMaxValue = milmax
        year_slider.selectedMaxValue = yearmax
        year_slider.selectedMinValue = yearmin
        carmodel_Fld.text = ""
        selection_Fld.text = ""
//        reservation_Fld.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.reloadSlider()
        }
        
 
    }
    func reloadSlider()
    {
        price_slider.minValue = pricemin
        price_slider.maxValue = pricemax
        mileageSlider.minValue = milmin
        mileageSlider.maxValue = milmax
        year_slider.minValue = yearmin
        year_slider.maxValue = yearmax

        price_slider.selectedMinValue = pricemin
        price_slider.selectedMaxValue = pricemax
        mileageSlider.selectedMinValue = milmin
        mileageSlider.selectedMaxValue = milmax
        year_slider.selectedMaxValue = yearmax
        year_slider.selectedMinValue = yearmin

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
extension FilterVC: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === price_slider {
            objFilterRecord.max_price = String(describing:"\((Int(ceil(maxValue))))")
            objFilterRecord.min_price = String(describing:"\((Int(ceil(minValue))))")
 
         } else if slider === year_slider {
            print("Currency slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            objFilterRecord.max_year = String(describing:"\((Int(ceil(maxValue))))")
            objFilterRecord.min_year = String(describing:"\((Int(ceil(minValue))))")

        } else if slider === mileageSlider {
            print("Custom slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            objFilterRecord.max_milege = String(describing:"\((Int(ceil(maxValue))))")
            objFilterRecord.min_milege = String(describing:"\(Int(ceil(minValue)))")
         }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}

extension FilterVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
            return 0.0
     }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            return CGSize(width: collectionView.frame.size.width/3, height: 55)
            
     }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carFeature.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell:FeatureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCollectionViewCellID", for: indexPath) as! FeatureCollectionViewCell
        let filterRec:FilterRecord = carFeature[indexPath.row] as! FilterRecord
        cell.detail_Lbl.text = filterRec.name
        if(filterRec.isSelelcted)
        {
            cell.CheckBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }
        else
        {
            cell.CheckBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)

        }
          return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterRec:FilterRecord = carFeature[indexPath.row] as! FilterRecord
        filterRec.isSelelcted = !filterRec.isSelelcted
        collectionView.reloadData()
      }
 
}
