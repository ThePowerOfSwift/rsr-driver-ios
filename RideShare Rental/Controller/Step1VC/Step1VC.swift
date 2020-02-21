//
//  Step1VC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import SwiftValidators
import Spring
import ActionSheetPicker_3_0

class Step1VC: UIViewController {
 
    @IBOutlet weak var pickuptimeFld: CustomTextfield!
    @IBOutlet var bottom_View: UIView!
    @IBOutlet var scroll_View: UIScrollView!
    @IBOutlet var offer3_Lbl: CustomLabel!
    @IBOutlet var offer2_Lbl: CustomLabel!
    
    @IBOutlet var from_date: CustomLabel!

     @IBOutlet var to_date: CustomLabel!
    @IBOutlet var offer1_Lbl: CustomLabel!
    @IBOutlet var car_owner: CustomLabel!
    @IBOutlet var carname_Lbl: CustomLabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var offer3selectimg: SpringImageView!
    @IBOutlet var offer2selectimg: SpringImageView!
    @IBOutlet var offer1selectimg: SpringImageView!
    
    var objRecord:CarRecord = CarRecord()
    var objFilterRecord:FilterRecord = FilterRecord()
     var objBookRecord:BookRecord = BookRecord()
    
    var Fromdate:Date?
    var Todate:Date?
    var isChoosenFromDate = Bool()
    var daycount:Int = Int()

      override func viewDidLoad() {
        super.viewDidLoad()
        SetData()
        let nibName = UINib(nibName: "deductibleTableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "deductibleTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()


           // Do any additional setup after loading the view.
    }
    func SetData()
    {
        from_date.text = ""
        to_date.text  = ""
        offer1_Lbl.text = "By day - " + Themes.sharedInstance.Getcurrency() + " \(objRecord.rent_daily)" + "/day"
        offer2_Lbl.text = "By week - " + Themes.sharedInstance.Getcurrency() + " \(objRecord.rent_weekly)" + "/week"
        offer3_Lbl.text = "By month - " + Themes.sharedInstance.Getcurrency() + " \(objRecord.rent_monthly)" + "/month"
        objBookRecord.fromdate = objFilterRecord.fromdate
        objBookRecord.todate = objFilterRecord.toDate
        if(Int(objRecord.minstay) != nil)
        {
            daycount = Int(objRecord.minstay)!
        }
        else
        {
            daycount = 0
        }
        if(objFilterRecord.fromdate  == "" ||  objBookRecord.todate == "")
        {
            Fromdate = Date()
            Todate = self.generateDates(fromDate: Fromdate!, value: daycount)
            from_date.text = Themes.sharedInstance.convertDateFormater(Fromdate!)
            to_date.text = Themes.sharedInstance.convertDateFormater(Todate!)
            objBookRecord.fromdate = from_date.text!
            objBookRecord.todate = to_date.text!
        }
        else
        {
            Fromdate = objFilterRecord.Fromdate
            Todate = objFilterRecord.Todate
            objBookRecord.fromdate = objFilterRecord.fromdate
            objBookRecord.todate = objFilterRecord.toDate
            from_date.text = objFilterRecord.fromdate
            to_date.text = objFilterRecord.toDate
        }
        carname_Lbl.text = "\(objRecord.car_make) \(objRecord.car_model) \(objRecord.year)"
        car_owner.text = objRecord.firstname + " " + objRecord.lastname
        offer1selectimg.image = #imageLiteral(resourceName: "selected")
        offer3selectimg.image = #imageLiteral(resourceName: "unselected")
        offer2selectimg.image = #imageLiteral(resourceName: "unselected")
        objBookRecord.selectedrent = "days"
        let objrecord:DeductibleRecord = objRecord.deductibleArr[0]
        objBookRecord.deductid = objrecord.id
        tableView.reloadData()

       
    }
    override func viewDidLayoutSubviews() {
//
        if(objRecord.deductibleArr.count > 0)
        {
            tableView.isHidden = false
              tableView.frame.origin.y = bottom_View.frame.origin.y+bottom_View.frame.size.height+15+pickuptimeFld.frame.size.height+15
            tableView.frame.size.height = tableView.contentSize.height+60
             scroll_View.contentSize.height = self.tableView.frame.origin.y+tableView.contentSize.height+60
       }
        else
        {
            tableView.isHidden = true
            scroll_View.contentSize.height = self.bottom_View.frame.origin.y+self.bottom_View.frame.size.height+pickuptimeFld.frame.size.height
         }
     }
    @IBAction func DidclcikBack(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickNext(_ sender: Any) {
        if(Validator.isEmpty().apply(from_date.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Choose from date")
        }
        else if(Validator.isEmpty().apply(to_date.text!))
        {
            Themes.sharedInstance.showErrorpopup(Msg: "Choose to date")
        }
        else if(Validator.isEmpty().apply(pickuptimeFld.text!))
        {
           Themes.sharedInstance.showErrorpopup(Msg: "Kindly choose the pickup time")
        }
        else
        {
        objBookRecord.pickuptime = pickuptimeFld.text!
        objBookRecord.carid = objRecord.id
        objBookRecord.fromdate = from_date.text!
        objBookRecord.todate = to_date.text!
        let Step2VC = storyboard?.instantiateViewController(withIdentifier:"Step2VCID" ) as! Step2VC
        Step2VC.objBookRecord = objBookRecord
        Step2VC.carRecord = objRecord
        self.navigationController?.pushViewController(Step2VC, animated: true)
        }
    }
    func AnimateView(offer1selectimg:SpringImageView)
    {
        offer1selectimg.animation = "pop"
        offer1selectimg.curve = "easeInOut"
        offer1selectimg.duration = 0.4
        offer1selectimg.animate()
     }
    @IBAction func Didclickoffer(_ sender: Any) {
        if((sender as! UIButton).tag == 0)
        {
            offer1selectimg.image = #imageLiteral(resourceName: "selected")
            offer3selectimg.image = #imageLiteral(resourceName: "unselected")
            offer2selectimg.image = #imageLiteral(resourceName: "unselected")
            objBookRecord.selectedrent = "days"
            AnimateView(offer1selectimg: offer1selectimg)
            Todate = self.generateDates(fromDate: Fromdate!, value: daycount)
             to_date.text = Themes.sharedInstance.convertDateFormater(Todate!)
              objBookRecord.todate = to_date.text!
         }
       else if((sender as! UIButton).tag == 1)
        {
            offer1selectimg.image = #imageLiteral(resourceName: "unselected")
            offer3selectimg.image = #imageLiteral(resourceName: "unselected")
            offer2selectimg.image = #imageLiteral(resourceName: "selected")
            objBookRecord.selectedrent = "week"
            AnimateView(offer1selectimg: offer2selectimg)
             Todate = self.generateDates(fromDate: Fromdate!, value: 7)
            to_date.text = Themes.sharedInstance.convertDateFormater(Todate!)
            objBookRecord.todate = to_date.text!
         }
       else if((sender as! UIButton).tag == 2)
        {
            offer1selectimg.image = #imageLiteral(resourceName: "unselected")
            offer3selectimg.image = #imageLiteral(resourceName: "selected")
            offer2selectimg.image = #imageLiteral(resourceName: "unselected")
            objBookRecord.selectedrent = "month"
            AnimateView(offer1selectimg: offer3selectimg)
            Todate = self.generateDates(fromDate: Fromdate!, value: 30)
            to_date.text = Themes.sharedInstance.convertDateFormater(Todate!)
            objBookRecord.todate = to_date.text!
          }
     }
    
    @IBAction func DidclickDate(_ sender: Any)
    {
        if((sender as! UIButton).tag == 0)
        {
            isChoosenFromDate = true
           self.presentDateView(fromdate: Date(), todate: self.generateDates(fromDate: Date(), value: 7))
          }
        else if((sender as! UIButton).tag == 1)
        {
            
            if(from_date.text != "")
            {
                isChoosenFromDate = false
                var todate:Date = Date()
                if(objBookRecord.selectedrent == "week")
                {
                    todate = self.generateDates(fromDate: Fromdate!, value: 7)
                    print(todate)
                    print(todate)

                    self.presentDateView(fromdate: todate, todate: self.generateDates(fromDate: todate, value: 365))
 
                }
                else if(objBookRecord.selectedrent == "month")
                {
                    todate = self.generateDates(fromDate: Fromdate!, value: 30)
                    
                    self.presentDateView(fromdate: todate, todate: self.generateDates(fromDate: todate, value: 365))

                 }
                
                else if(objBookRecord.selectedrent == "days")
                {
                    todate = self.generateDates(fromDate: Fromdate!, value: daycount)
                     self.presentDateView(fromdate: todate, todate: self.generateDates(fromDate: todate, value: 365))
                    
                }
            }
            else
            {
                self.view.makeToast("Kindly Choose from date")
            }
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
        selector.startingDate = fromdate
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
    @IBAction func didclickpickuptime(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Kindly Choose Pickup time", rows: ["08:00 am", "09:00 am", "10:00 am", "11:00 am", "Noon", "01:00 pm", "02:00 pm", "03:00 pm", "04:00 pm", "05:00 pm", "06:00 pm", "07:00 pm"], initialSelection: 0, doneBlock: {
            picker, value, index in
            if("\(String(describing: index!))" == "Noon")
            {
                self.pickuptimeFld.text = "12:00 pm"
             }
            else{
                self.pickuptimeFld.text = "\(String(describing: index!))"
             }
             return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        

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
extension Step1VC:WWCalendarTimeSelectorProtocol
{
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        
        if(!isChoosenFromDate)
        {
            Todate = date
            to_date.text = Themes.sharedInstance.convertDateFormater(date)
        }
        else
        {
            Fromdate = date
            

            if(objBookRecord.selectedrent == "week")
            {
                Todate = self.generateDates(fromDate: Fromdate!, value: 7)
             }
            else  if(objBookRecord.selectedrent == "month")
            {
                Todate = self.generateDates(fromDate: Fromdate!, value: 30)

            }
            else  if(objBookRecord.selectedrent == "days")
            {
                Todate = self.generateDates(fromDate: Fromdate!, value: daycount)
 
            }
            to_date.text = Themes.sharedInstance.convertDateFormater(Todate!)
              from_date.text = Themes.sharedInstance.convertDateFormater(date)
        }
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        
        if(!isChoosenFromDate)
        {
            if(objBookRecord.selectedrent == "week")
            {
            let From_date:Date = self.generateDates(fromDate: Fromdate!, value: 7)
          if(date.isBetween(From_date, and: self.generateDates(fromDate: From_date, value: 90)))
            {
                return true
            }
            }
            
          else  if(objBookRecord.selectedrent == "month")
            {
                let From_date:Date = self.generateDates(fromDate: Fromdate!, value: 30)
                if(date.isBetween(From_date, and: self.generateDates(fromDate: From_date, value: 365)))
                {
                    return true
                }
            }
            
            else  if(objBookRecord.selectedrent == "days")
            {
                let From_date:Date = self.generateDates(fromDate: Fromdate!, value: daycount)
                if(date.isBetween(From_date, and: self.generateDates(fromDate: From_date, value: 365)))
                {
                    return true
                }
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
     }
}

extension Step1VC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Choose the deductible on the insurance"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(objRecord.deductibleArr.count)
        return objRecord.deductibleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:deductibleTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "deductibleTableViewCell") as! deductibleTableViewCell
        let objrecord:DeductibleRecord = objRecord.deductibleArr[indexPath.row]
         cell.title.text = objrecord.text
        if(objBookRecord.deductid == objrecord.id)
        {
           cell.selectionimg.image = #imageLiteral(resourceName: "selected")
        }
        else
        {
            cell.selectionimg.image = #imageLiteral(resourceName: "unselected")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: Constant.sharedinstance.SemiBold, size: 13)!
        header.textLabel?.textColor = UIColor.black
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objrecord:DeductibleRecord = objRecord.deductibleArr[indexPath.row]
         objBookRecord.deductid = objrecord.id
        tableView.reloadData()
    }
    
}
