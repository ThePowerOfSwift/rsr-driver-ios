//
//  ExtendRentalVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 15/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import SwiftValidators
import NVActivityIndicatorView

class ExtendRentalVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var extendDate_Lbl: CustomTextfield!
    @IBOutlet var carname: CustomLabel!
    @IBOutlet var to_Lbl: CustomLabel!
    @IBOutlet var from_Lbl: CustomLabel!
    @IBOutlet var scroll_View: UIScrollView!
    var fromdate:String = String()
    var todate:String = String()
    var bookID:String = String()
    var car_name:String = String()
    var to_date:Date?
    var exttodate:Date?
    
    var total:String = String()

    var DateSource:NSMutableArray = NSMutableArray()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)

 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "PricetableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "PricetableViewCellID")
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        to_Lbl.text = ""
        from_Lbl.text = todate
        
        to_date = Themes.sharedInstance.StrtoDate(str: todate, dateFormat: "MM/dd/yyyy", timeformat: "PST")
        carname.text = car_name
        for i in 0...6
        {
            let actRecord:ExtentRecord = ExtentRecord()
            actRecord.desc = "0.0"

            if(i == 0)
            {
                actRecord.title = "Rental Length"
                actRecord.desc = "0"
             }
            
            if(i == 1)
            {
                actRecord.title = "Rental Price"
                
            }
            if(i == 2)
            {
                actRecord.title = "Insurance Fee"
                
            }
            if(i == 3)
            {
                actRecord.title = "Transaction Fee"
                
            }
            if(i == 4)
            {
                actRecord.title = "Late Fee"
                
            }
            if(i == 5)
            {
                actRecord.title = "Service Tax"
                
            }
            if(i == 6)
            {
                actRecord.title = "Total"
                
            }
            total = "0.0";
            DateSource.add(actRecord)
        }
        tableView.reloadData()
         // Do any additional setup after loading the view.
    }
    
    func ConfirmextendDetail(Param:[String:String])
    {
        Themes.sharedInstance.activityView(View: self.view)
         URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.proceed_extend_booking as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)

            if(error == nil)
            {
                 let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        let Bookrecord:BookRecord =  BookRecord()
                        Bookrecord.total_amount = self.total
                        let PaymentVC = self.storyboard?.instantiateViewController(withIdentifier:"PaymentVCID" ) as! PaymentVC
                        PaymentVC.Bookrecord = Bookrecord
                         PaymentVC.isFromextend = true
                        PaymentVC.extendID = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "extend_no"))
                        self.navigationController?.pushViewController(PaymentVC, animated: true)
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
    
    func GetextendDetail(Param:[String:String])
    {
        DateSource = NSMutableArray()
        self.ShowSpinner()
        tableView.isHidden = true
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.extend_pricing as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
                Themes.sharedInstance.showErrorpopup(Msg: Constant.sharedinstance.errormessage)
            }
        })
    }
    
    func GetDetail(responseDict:NSDictionary?)
    {
        let pricingArr:NSArray = responseDict?.object(forKey: "pricingArr") as!  NSArray
        if(pricingArr.count > 0)
        {
            tableView.isHidden = false

            for i in 0..<pricingArr.count
            {
                let Dict:NSDictionary = pricingArr[i] as! NSDictionary
                let actRecord:ExtentRecord = ExtentRecord()
                 actRecord.title = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "key"))
                actRecord.desc = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "value"))
                if(actRecord.title ==  "Total")
                {
                    total = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "value"))

                }
               
                DateSource.add(actRecord)

            }
            tableView.reloadData()
        }
        else
        {
            tableView.isHidden = true

        }
 
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
    
    func generateDates(fromDate:Date,value : Int) -> Date {
        let today = fromDate
        let tomorrow = Calendar.current.date(byAdding: .day, value: value, to: today)
        return tomorrow!
    }
    
    func ShowSpinner()
    {
        activityIndicatorView.color = Themes.sharedInstance.returnThemeColor()
        activityIndicatorView.center=CGPoint(x:UIScreen.main.bounds.size.width/2,y:  tableView.frame.origin.y+95);
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
    }
    func StopSPinner()
    {
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
   
    override func viewDidLayoutSubviews() {
        tableView.frame.size.height = tableView.contentSize.height
        scroll_View.contentSize.height = self.tableView.frame.origin.y+self.tableView.frame.size.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Didclickextend(_ sender: Any) {
        
        self.presentDateView(fromdate: self.generateDates(fromDate: to_date!, value: 1), todate: self.generateDates(fromDate: Date(), value: 365))

 
     }
    
    @IBAction func DidclickBack(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func DidclickConfirm(_ sender: Any) {
        
        if(Validator.isEmpty().apply(extendDate_Lbl.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "enter the extend date")
        }
        else
        {
            
            let param:[String:String] = ["booking_no":bookID,"extend_to":extendDate_Lbl.text!]
             self.ConfirmextendDetail(Param: param)

 
        }

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
extension ExtendRentalVC:WWCalendarTimeSelectorProtocol
{
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        let str:String = Themes.sharedInstance.convertDateFormater(date)
          extendDate_Lbl.text = str.replacingOccurrences(of: "-", with: "/")
        to_Lbl.text = extendDate_Lbl.text!
        let param:[String:String] = ["booking_no":bookID,"extend_to":extendDate_Lbl.text!]
        
  self.GetextendDetail(Param: param)

    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
 

        if(date.isBetween(self.generateDates(fromDate: to_date!, value: 1), and: self.generateDates(fromDate: to_date!, value: 365)))
        {
            
            return true
        }
        return false
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        print("Selected Multiple Dates \n\(dates)\n---")
    }
}

extension ExtendRentalVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DateSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PricetableViewCell  = tableView.dequeueReusableCell(withIdentifier: "PricetableViewCellID") as! PricetableViewCell
        cell.selectionStyle = .none
        let record:ExtentRecord = DateSource[indexPath.row] as! ExtentRecord
        
        if(indexPath.row == 0)
        {
            
            if(record.desc == "1" || record.desc == "0")
            {
                cell.right_Lbl.text = record.desc + " " + "day"
            }
            else
            {
                cell.right_Lbl.text = record.desc + " " + "days"
                
            }
          }
        else
        {
            cell.right_Lbl.text = "\(Themes.sharedInstance.Getcurrency()) \(record.desc)"

        }
        cell.left_Lbl.text = record.title
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
