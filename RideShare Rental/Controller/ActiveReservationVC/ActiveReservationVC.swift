//
//  ActiveReservationVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage
import TOWebViewController

class ActiveReservationVC: UIViewController {
    @IBOutlet var nodetailWrapperView: UIView!
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
     @IBOutlet var tableView: UITableView!
    var ActReservArray:NSMutableArray = NSMutableArray()
    var Appdel=UIApplication.shared.delegate as! AppDelegate
    var isloading:Bool = Bool()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ActiveReservationtableViewcell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "ActiveReservationtableViewcellID")
        tableView.estimatedRowHeight = 847
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear

        let param:[String : String] = [:]
             self.ShowSpinner()
        tableView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.GetReservationData(Param: param)

        }
        nodetailWrapperView.isHidden = true
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadData(notifi:)), name: NSNotification.Name(rawValue: "ReservationStatus"), object: nil)
        
        if(Themes.sharedInstance.Getactive_reservation() == "Yes")
        {
            
        }
    }
    
    @objc func ReloadData(notifi:NSNotification)
    {
        if(!isloading)
        {
            let param:[String : String] = [:]
            self.ShowSpinner()
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                self.GetReservationData(Param: param)
                
            }
        }
        
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    func GetReservationData(Param:[String:String])
    {
        ActReservArray = NSMutableArray()
        tableView.isHidden = true
        isloading = true
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.reservations as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            self.StopSPinner()
            self.isloading = false
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
        ActReservArray = NSMutableArray()
        let active_Array:NSArray = responseDict?.object(forKey: "active_reservations") as!  NSArray
        if(active_Array.count > 0)
        {
            Themes.sharedInstance.SaveReservationStatus(user_id: "Yes")

            tableView.isHidden = false

            for i in 0..<active_Array.count
            {
                let dict:NSDictionary = active_Array[i] as! NSDictionary
                let objRecord:ActiveRecord =  ActiveRecord()
               objRecord.allow_extend = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "allow_extend"))
               objRecord.booking_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "booking_no"))
                objRecord.carId = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "carId"))
                objRecord.car_make = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_make"))
                objRecord.car_model = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_model"))
               objRecord.city = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "city"))
                objRecord.dateAdded = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "dateAdded"))
                objRecord.date_from = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "date_from"))
                objRecord.date_to = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "date_to"))
                objRecord.deposit = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "deposit"))
                objRecord.email = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "email"))
                objRecord.extended = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "extended"))
               objRecord.extended_date = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "extended_date"))
              objRecord.ins = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "ins"))
              objRecord.lift_uber = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "lift_uber"))
               objRecord.no_of_days = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "no_of_days"))
              objRecord.ownername = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "ownername"))
                objRecord.phone_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "phone_no"))
                objRecord.profile_pic = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "profile_pic"))
                objRecord.progress = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "progress"))
                objRecord.rc = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rc"))
                objRecord.rent_daily = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_daily"))
               objRecord.rent_monthly = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_monthly"))
               objRecord.rent_weekly = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rent_weekly"))
               objRecord.state = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "state"))
              objRecord.status = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "status"))
                objRecord.street = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "street"))
               objRecord.total_amount = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "total_amount"))
                objRecord.vin_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "vin_no"))
                objRecord.year = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "year"))
                
                objRecord.car_image = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_image"))
                objRecord.plat_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "plat_no"))
                objRecord.v_no = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "v_no"))
                objRecord.notes = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "notes"))
                objRecord.timer_date = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "timer_date"))
                objRecord.booking_status = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "booking_status"))
                objRecord.DocArray = dict.object(forKey: "documents") as! NSArray
                if(!(dict.object(forKey: "bookingDocs") is NSNull))
                {
                    objRecord.bookingDocs = dict.object(forKey: "bookingDocs") as! NSArray
                }
                  ActReservArray.add(objRecord)
             }
            tableView.reloadData()
         
         }
        else
        {
            Themes.sharedInstance.SaveReservationStatus(user_id: "No")

            nodetailWrapperView.isHidden = false
            
        }

    }
    override func viewDidLayoutSubviews() {
         tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
 
        navigationController?.setNavigationBarHidden(true, animated: false)

    }

}
extension ActiveReservationVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ActReservArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1080
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ActiveReservationtableViewcell  = tableView.dequeueReusableCell(withIdentifier: "ActiveReservationtableViewcellID") as! ActiveReservationtableViewcell
        cell.selectionStyle = .none
        cell.extrent_Btn.tag = indexPath.row
        cell.doc_Btn.tag = indexPath.row
        cell.bookDoc.tag = indexPath.row
        cell.extrent_Btn.addTarget(self, action:
            #selector(self.MovetoExtendVC(sender:)), for: .touchUpInside)
        cell.doc_Btn.addTarget(self, action: #selector(self.MovetoDocVC(sender:)), for: .touchUpInside)
        cell.bookDoc.addTarget(self, action: #selector(self.MovetoBookDocVC(sender:)), for: .touchUpInside)

         cell.wrapperView.dropShadow()
        let record:ActiveRecord = ActReservArray[indexPath.row] as! ActiveRecord
        cell.car_Image.sd_setImage(with: URL(string:record.car_image), placeholderImage: #imageLiteral(resourceName: "carplaceholder"))
        cell.profpicimg.sd_setImage(with: URL(string:record.profile_pic), placeholderImage: #imageLiteral(resourceName: "avatar"))
        cell.carname.text = "  \(record.car_make) \(record.car_model) \(record.year)"
         if(record.no_of_days == "1" || record.no_of_days == "0")
        {
            cell.remain_Lbl.text =  record.no_of_days + " " + "day rental"
         }
        else
        {
            cell.remain_Lbl.text =  record.no_of_days + " " + "days rental"
        }
        cell.price_Lbl.text = Themes.sharedInstance.Getcurrency() + " " + record.total_amount + " " + "total price"
        cell.start_date.text = record.date_from
        cell.end_date.text = record.extended_date
        cell.name_Lbl.text = record.ownername
        cell.address.text = record.street
        cell.vin_Lbl.text = record.vin_no
        cell.vehicle_Lbl.text = record.v_no
        cell.plate_Lbl.text = record.plat_no
        cell.make_Lbl.text = record.car_make
        cell.model_Lbl.text = record.car_model
        cell.yearLbl.text = record.year
        cell.notes_Lbl.text = record.notes
      
       
        if(record.allow_extend == "Yes")
        {
          cell.extrent_Btn.isHidden = false
        }
        else
        {
            cell.extrent_Btn.isHidden = true

        }
        
        if(record.extended == "Yes")
        {
            if(record.allow_extend == "Yes")
            {
                cell.extrental2.isHidden = false
            }
            else
            {
                cell.extrental2.isHidden = true
                
            }
            cell.extendedwrapperView.isHidden = false
            
        }
        else
        {
            cell.extendedwrapperView.isHidden = true
            
        }
        cell.invoice.isHidden = true

        if(record.progress == "waiting")
        {
            cell.extrent_Btn.setTitle("Applied", for: .normal)
            cell.extrent_Btn.isUserInteractionEnabled = false
            cell.extrent_Btn.isHidden = false
            cell.extendedwrapperView.isHidden = true

            cell.waitimg.image = #imageLiteral(resourceName: "yellowring")
            cell.insimg.image = #imageLiteral(resourceName: "greenring")
            cell.spendimg.image = #imageLiteral(resourceName: "greenring")
            
            cell.waiting_Lbl.textColor = UIColor(red:1.00, green:0.75, blue:0.00, alpha:1.0)
            cell.insur_Lbl.textColor = Themes.sharedInstance.returnThemeColor()
            cell.spend_Lbl.textColor = Themes.sharedInstance.returnThemeColor()
        }
        else if(record.progress == "pickup")
        {
            cell.waitimg.image = #imageLiteral(resourceName: "greenring")
            cell.insimg.image = #imageLiteral(resourceName: "yellowring")
            cell.spendimg.image = #imageLiteral(resourceName: "greenring")
            
            cell.waiting_Lbl.textColor = Themes.sharedInstance.returnThemeColor()
            cell.insur_Lbl.textColor = UIColor(red:1.00, green:0.75, blue:0.00, alpha:1.0)
            
            
            cell.spend_Lbl.textColor = Themes.sharedInstance.returnThemeColor()
        }
        else if(record.progress == "running")
        {
            cell.waitimg.image = #imageLiteral(resourceName: "greenring")
            cell.insimg.image = #imageLiteral(resourceName: "greenring")
            cell.spendimg.image = #imageLiteral(resourceName: "yellowring")
            cell.waiting_Lbl.textColor = Themes.sharedInstance.returnThemeColor()
            cell.insur_Lbl.textColor = Themes.sharedInstance.returnThemeColor()
            cell.spend_Lbl.textColor = UIColor(red:1.00, green:0.75, blue:0.00, alpha:1.0)
            cell.invoice.isHidden = false

            
        }
        cell.reviewBtn.isHidden = true
        if(record.booking_status == "Booked")
        {
            cell.reviewBtn.isHidden = false

        }
        cell.reviewBtn.tag = indexPath.row
        cell.reviewBtn.addTarget(self, action: #selector(self.MovetoRatingVC(sender:)), for: .touchUpInside)

        cell.extdetail.tag = indexPath.row
        cell.extrental2.tag = indexPath.row
        cell.invoice.tag = indexPath.row

       cell.extrental2.addTarget(self, action: #selector(self.MovetoExtendVC(sender:)), for: .touchUpInside)
        cell.extdetail.addTarget(self, action: #selector(self.Movetoextedetail(sender:)), for: .touchUpInside)
        
        cell.invoice.addTarget(self, action: #selector(self.MovetoInvoice(sender:)), for: .touchUpInside)

        print(record.timer_date)
        cell.StartClock(date: Themes.sharedInstance.StrtoDate(str: record.timer_date, dateFormat: "yyyy-MM-dd HH:mm:ss", timeformat: "GMT"))
        cell.mytrans_Btn.addTarget(self, action: #selector(self.MovetoTransVC(sender:)), for: .touchUpInside)
        
        if(record.DocArray.count > 0)
        {
            cell.doc_Btn.isUserInteractionEnabled = true
            
            cell.doc_Btn.borderColor = Themes.sharedInstance.returnThemeColor()
            cell.doc_Btn.setTitleColor(Themes.sharedInstance.returnThemeColor(), for: .normal)
//            cell.doc_Btn.isHidden = false

        }
        else
        {
            cell.doc_Btn.isUserInteractionEnabled = false
            cell.doc_Btn.borderColor = UIColor.lightGray
            cell.doc_Btn.setTitleColor(UIColor.lightGray, for: .normal)
//            cell.doc_Btn.isHidden = true


 
        }
        
//        if(record.bookingDocs.count > 0)
//        {
//            cell.bookDoc.isHidden = false
//
//        }
//        else
//        {
//            cell.bookDoc.isHidden = true
//         }

          return cell
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
    
    @objc func MovetoRatingVC(sender:UIButton)
    {
        let record:ActiveRecord = ActReservArray[sender.tag] as! ActiveRecord
        let ReviewVC = storyboard?.instantiateViewController(withIdentifier:"ReviewVCID" ) as! ReviewVC
        ReviewVC.bookingNo = record.booking_no
        self.navigationController?.pushViewController(ReviewVC, animated: true)
    }

  
    @objc func MovetoInvoice(sender:UIButton)
    {
        navigationController?.setNavigationBarHidden(false, animated: true)
         let record:ActiveRecord = ActReservArray[sender.tag] as! ActiveRecord
 print("\(BaseUrl)app/driver/invoice/\(record.booking_no)?commonId=\(Themes.sharedInstance.GetuserID())")
let webViewController = TOWebViewController(url: (URL(string: "\(BaseUrl)app/driver/invoice/\(record.booking_no)?commonId=\(Themes.sharedInstance.GetuserID())"))!)
        navigationController?.pushViewController(webViewController!, animated: true)
    }
    
    @objc func Movetoextedetail(sender:UIButton)
    {
        let record:ActiveRecord = ActReservArray[sender.tag] as! ActiveRecord
         let ExtendDetailVC = storyboard?.instantiateViewController(withIdentifier:"ExtendDetailVCID" ) as! ExtendDetailVC
        ExtendDetailVC.bookingNo = record.booking_no
        self.navigationController?.pushViewController(ExtendDetailVC, animated: true)
        
        
    }
    
    @objc func MovetoTransVC(sender:UIButton)
    {
        let MytransactionVC = storyboard?.instantiateViewController(withIdentifier:"MytransactionVC" ) as! MytransactionVC
        MytransactionVC.isfromOtherpage = true
        self.navigationController?.pushViewController(MytransactionVC, animated: true)
        
        
    }
    @objc func MovetoDetailVC(sender:UIButton)
    {
        
        let UserdetailVC = storyboard?.instantiateViewController(withIdentifier:"UserdetailVCID" ) as! UserdetailVC
        UserdetailVC.modalPresentationStyle = .overFullScreen
         self.present(UserdetailVC, animated: false, completion: nil)


     }
    @objc func MovetoBookDocVC(sender:UIButton)
    {
        let record:ActiveRecord = ActReservArray[sender.tag] as! ActiveRecord

        if(record.bookingDocs.count > 0)
        {

        
        let DocumentVC = storyboard?.instantiateViewController(withIdentifier:"DocumentVCID" ) as! DocumentVC
        DocumentVC.docArray =  record.bookingDocs
        DocumentVC.bookingid = record.booking_no
         DocumentVC.isfromBookDoc = true
        DocumentVC.modalPresentationStyle = .overFullScreen
        self.present(DocumentVC, animated: false, completion: nil)
        }
        else
        {
            Themes.sharedInstance.showErrorpopup(Msg: "No Document")
        }
        
    }
    @objc func MovetoDocVC(sender:UIButton)
    {
        let record:ActiveRecord = ActReservArray[sender.tag] as! ActiveRecord
        if(record.DocArray.count > 0)
        {
         let DocumentVC = storyboard?.instantiateViewController(withIdentifier:"DocumentVCID" ) as! DocumentVC
        DocumentVC.docArray =  record.DocArray
        DocumentVC.bookingid = record.booking_no
        DocumentVC.modalPresentationStyle = .overFullScreen
        self.present(DocumentVC, animated: false, completion: nil)
        }
        else
        {
            Themes.sharedInstance.showErrorpopup(Msg: "No Document")

        }

    }
    @objc func MovetoExtendVC(sender:UIButton)
    {
        let record:ActiveRecord = ActReservArray[sender.tag] as! ActiveRecord

        let ExtendRentalVC = storyboard?.instantiateViewController(withIdentifier:"ExtendRentalVCID" ) as! ExtendRentalVC
        ExtendRentalVC.bookID = record.booking_no
        ExtendRentalVC.fromdate = record.date_from
        ExtendRentalVC.todate = record.extended_date
        ExtendRentalVC.car_name = "\(record.car_make) \(record.car_model) \(record.year)"
        self.navigationController?.pushViewController(ExtendRentalVC, animated: true)


    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ActiveReservationVC: OTPVerifyVCDelegate
{
    func reloaddata() {
        
    }
}
