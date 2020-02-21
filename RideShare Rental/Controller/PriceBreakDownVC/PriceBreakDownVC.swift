//
//  PriceBreakDownVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 13/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class PriceBreakDownVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var to_date: CustomLabel!
     @IBOutlet var scroll_View: UIScrollView!
    @IBOutlet var from_date: CustomLabel!
    @IBOutlet var owner_Lbl: CustomLabel!
    @IBOutlet var car_Lbl: CustomLabel!
 
    
    var objBookRecord:BookRecord = BookRecord()
    var carRecord:CarRecord = CarRecord()
    var priceArr:NSMutableArray = NSMutableArray()


    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "PricetableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "PricetableViewCellID")
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        
        owner_Lbl.text = "\(carRecord.firstname) \(carRecord.lastname)"
        car_Lbl.text = "\(carRecord.car_make) \(carRecord.car_model)"
        to_date.text = objBookRecord.todate
        from_date.text =  objBookRecord.fromdate
           // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        tableView.frame.size.height = tableView.contentSize.height
        scroll_View.contentSize.height = self.tableView.frame.origin.y+self.tableView.frame.size.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
extension PriceBreakDownVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return priceArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PricetableViewCell  = tableView.dequeueReusableCell(withIdentifier: "PricetableViewCellID") as! PricetableViewCell
        cell.selectionStyle = .none
        let dict:NSDictionary = priceArr[indexPath.row] as! NSDictionary
        if(indexPath.row == 0)
        {
            cell.right_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "value"))

        }
       else if(indexPath.row == 1)
        {
            cell.right_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "value"))

        }
        else if(indexPath.row == 2)
        {
            if(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "value")) == "1" || Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "value")) == "0")
            {
            cell.right_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "value")) + " " + "day"
            }
            else
            {
                cell.right_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "value")) + " " + "days"

            }
            
            
        }
        else
        {
        cell.right_Lbl.text =  Themes.sharedInstance.Getcurrency() + " " + Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "value"))
        }
        cell.left_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "key"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     }
    
}
