//
//  PastReservationVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage


class PastReservationVC: UIViewController {
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    var Appdel=UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var tableView: UITableView!
    @IBOutlet var nodetailWrapperView: UIView!

    var pastReservArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "PastReservationtableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "PastReservationtableViewCellID")
        tableView.estimatedRowHeight = 550
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        nodetailWrapperView.isHidden = true
        let param:[String : String] = [:]
       self.GetReservationData(Param: param)
        // Do any additional setup after loading the view.
    }
    
    func GetReservationData(Param:[String:String])
    {
        tableView.isHidden = true
        
        self.ShowSpinner()
       pastReservArray = NSMutableArray()
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.reservations as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            self.StopSPinner()
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
                self.nodetailWrapperView.isHidden = false
                Themes.sharedInstance.showErrorpopup(Msg: Constant.sharedinstance.errormessage)
            }
        })
    }
    @IBAction func DidclickFindcar(_ sender: Any) {
        Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "HomeVCID")
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
    
    func GetDetail(responseDict:NSDictionary?)
    {
        let past_Array:NSArray = responseDict?.object(forKey: "past_reservations") as!  NSArray
        pastReservArray = NSMutableArray()
        
        let active_Array:NSArray = responseDict?.object(forKey: "active_reservations") as!  NSArray
        if(active_Array.count > 0)
        {
            Themes.sharedInstance.SaveReservationStatus(user_id: "Yes")
        }
         else
      {
      Themes.sharedInstance.SaveReservationStatus(user_id: "No")
      }
        if(past_Array.count > 0)
        {
            tableView.isHidden = false
            
            for i in 0..<past_Array.count
            {
    let dict:NSDictionary = past_Array[i] as! NSDictionary
    let objRecord:PastRecord =  PastRecord()
            objRecord.allow_extend = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "allow_extend"))
             objRecord.booking_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "booking_no"))
             objRecord.carId = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "carId"))
           objRecord.car_image = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_image"))
           objRecord.car_make = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_make"))
            objRecord.car_model = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_model"))
             objRecord.city = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "city"))
            objRecord.dateAdded = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "dateAdded"))
             objRecord.date_to = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "date_to"))
            objRecord.deposit = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "deposit"))
          objRecord.extended = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "extended"))
            
            objRecord.email = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "email"))
           objRecord.extended_date = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "extended_date"))
          objRecord.ins = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "ins"))
           objRecord.insurance_doc = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "insurance_doc"))
            objRecord.no_of_days = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "no_of_days"))
          objRecord.notes = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "notes"))
          objRecord.ownername = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "ownername"))
           objRecord.phone_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "phone_no"))
           objRecord.plat_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "plat_no"))
          objRecord.profile_pic = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "profile_pic"))
            objRecord.rc = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rc"))
            objRecord.rent_daily = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_daily"))
            objRecord.rent_monthly = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_monthly"))
           objRecord.rent_weekly = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_weekly"))
           objRecord.similar_cars = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "similar_cars"))
           objRecord.state = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "object"))
           objRecord.status = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "status"))
           objRecord.street = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "street"))
           objRecord.timer_date = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "timer_date"))
            objRecord.total_amount = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "total_amount"))
           objRecord.v_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "v_no"))
            objRecord.vin_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "vin_no"))
           objRecord.year = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "year"))
            objRecord.date_from  = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "date_from"))
                objRecord.notes  = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "notes"))
                pastReservArray.add(objRecord)
            }
            tableView.reloadData()
            super.viewDidLayoutSubviews()
         }
        else
        {
    nodetailWrapperView.isHidden = false
        }
 
     }
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLayoutSubviews()
     {
        tableView.reloadData()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  }

extension PastReservationVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pastReservArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 759
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PastReservationtableViewCell  = tableView.dequeueReusableCell(withIdentifier: "PastReservationtableViewCellID") as! PastReservationtableViewCell
        cell.selectionStyle = .none
        cell.wrapperView.dropShadow(scale:true)
        let record:PastRecord = pastReservArray[indexPath.row] as! PastRecord
        cell.status_Lbl.text = record.status
        if(record.status == "Declined")
        {
        cell.status_Lbl.backgroundColor = UIColor.red
            cell.mytransBtn.isHidden = true
            cell.review_Btn.isHidden = true

        }
        else
        {
        cell.status_Lbl.backgroundColor = UIColor.orange
            cell.mytransBtn.isHidden = false
            cell.review_Btn.isHidden = false

        }
        cell.car_Image.sd_setImage(with: URL(string:record.car_image), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))
        cell.profpicimg.sd_setImage(with: URL(string:record.profile_pic), placeholderImage: #imageLiteral(resourceName: "avatar"))
         cell.carname_Lbl.text = "\(record.car_make) \(record.car_model) \(record.year)"
         cell.start_date.text = record.date_from
            cell.end_date.text = record.extended_date
        cell.price_Lbl.text = "\(Themes.sharedInstance.Getcurrency()) \(record.total_amount) total price"
        cell.vin_Lbl.text = record.vin_no
        cell.veh_Lbl.text = record.v_no
        cell.plate_Lbl.text = record.plat_no
        cell.make_Lbl.text = record.car_make
        cell.model_Lbl.text = record.car_model
        cell.year_Lbl.text = record.year
        cell.showsimcar_Btn.tag = indexPath.row
        cell.review_Btn.tag = indexPath.row
         cell.mytransBtn.addTarget(self, action: #selector(self.MovetoTransVC(sender:)), for: .touchUpInside)
        cell.showsimcar_Btn.addTarget(self, action: #selector(self.MovetoHome(sender:)), for: .touchUpInside)
        cell.review_Btn.addTarget(self, action: #selector(self.MovetoRatingVC(sender:)), for: .touchUpInside)
        cell.notes.text = record.notes
          return cell
    }
    
 @objc func MovetoRatingVC(sender:UIButton)
    {
        let record:PastRecord = pastReservArray[sender.tag] as! PastRecord
         let ReviewVC = storyboard?.instantiateViewController(withIdentifier:"ReviewVCID" ) as! ReviewVC
        ReviewVC.bookingNo = record.booking_no
         self.navigationController?.pushViewController(ReviewVC, animated: true)
 
    }
    @objc func MovetoHome(sender:UIButton)
    {
        let record:PastRecord = pastReservArray[sender.tag] as! PastRecord

        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            let Dict:[String:String] = ["location":record.street,"carmake":record.car_make,"carmodel":record.car_model,"caryear":record.year]
            NotificationCenter.default.post(name: Constant.sharedinstance.similarcarsnotName, object: Dict)
         }
        Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "HomeVCID")

        

    }
    
    @objc func MovetoTransVC(sender:UIButton)
    {
        let MytransactionVC = storyboard?.instantiateViewController(withIdentifier:"MytransactionVC" ) as! MytransactionVC
        MytransactionVC.isfromOtherpage = true
        self.navigationController?.pushViewController(MytransactionVC, animated: true)

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     }
    
}
