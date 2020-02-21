//
//  ExtendDetailVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 15/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class ExtendDetailVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    var bookingNo:String = String()
    var DateSource:NSMutableArray = NSMutableArray()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
     override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ExtendDetailtableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "ExtendDetailtableViewCellID")
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        let param:[String:String] = ["booking_no":bookingNo]
        self.GetextendDetail(Param: param)
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    func GetextendDetail(Param:[String:String])
    {
        DateSource = NSMutableArray()
         tableView.isHidden = true
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.extend_details as String, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Didclickback(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    
    func GetDetail(responseDict:NSDictionary?)
    {
        let pricingArr:NSArray = responseDict?.object(forKey: "exteded_details") as!  NSArray
        if(pricingArr.count > 0)
        {
            tableView.isHidden = false
            
            for i in 0..<pricingArr.count
            {
                let Dict:NSDictionary = pricingArr[i] as! NSDictionary
                let actRecord:ExtentRecord = ExtentRecord()
                actRecord.date_from = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "date_from"))
                actRecord.date_to = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "date_to"))
                actRecord.no_of_days = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "no_of_days"))
                actRecord.total_amount = "\(Themes.sharedInstance.Getcurrency()) \(Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "total_amount")))"

                 DateSource.add(actRecord)
                
            }
            tableView.reloadData()
        }
        else
        {
            tableView.isHidden = true
            
        }
        
    }
  
 }

extension ExtendDetailVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DateSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ExtendDetailtableViewCell  = tableView.dequeueReusableCell(withIdentifier: "ExtendDetailtableViewCellID") as! ExtendDetailtableViewCell
        cell.selectionStyle = .none
        let record:ExtentRecord = DateSource[indexPath.row] as! ExtentRecord
        cell.from_date.text = record.date_from
        cell.to_date.text = "\(record.date_to)"
        cell.noofDays.text = record.no_of_days
        cell.total_charge.text = record.total_amount
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
