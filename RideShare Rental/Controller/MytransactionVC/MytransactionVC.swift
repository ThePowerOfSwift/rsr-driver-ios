//
//  MytransactionVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 15/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import LUExpandableTableView
import NVActivityIndicatorView

class MytransactionVC: UIViewController {

    @IBOutlet var findcarBtn: CustomButton!
    @IBOutlet var trans_Lbl: CustomLabel!

    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var tableView: LUExpandableTableView!
    var Appdel=UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var findcar_Btn: CustomButton!
    @IBOutlet var nodetailView: UIView!
    private let cellReuseIdentifier = "MytransactableViewCellID"
    private let sectionHeaderReuseIdentifier = "MytransactionView"
         var sectionArr:NSMutableArray = NSMutableArray()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    var isfromOtherpage:Bool = Bool()
     override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "MytransactableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "MytransactableViewCellID")
        tableView.register(UINib(nibName: "MytransactionView", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: sectionHeaderReuseIdentifier)
        tableView.expandableTableViewDataSource = self
        tableView.expandableTableViewDelegate = self
        tableView.separatorColor = UIColor.clear
         nodetailView.isHidden = true
        self.GettransData(Param: [:])
        if(isfromOtherpage)
        {
          menuBtn.setImage(#imageLiteral(resourceName: "back_arr"), for: .normal)
        }
        if(Themes.sharedInstance.Getactive_reservation() == "Yes")
        {
            findcarBtn.isHidden = true
            trans_Lbl.text = "No transaction yet"
        }
            
            // Do any additional setup after loading the view.
    }
    
    @IBAction func DidclickFindCar(_ sender: Any) {
        Appdel.Make_RootVc("DLDemoRootViewController", RootStr: "HomeVCID")
     }
    // Do any additional setup after loading the view.
 func GettransData(Param:[String:String])
{
    self.ShowSpinner()
    tableView.isHidden = true
    URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.transactions as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
        if((responseDict?.count)! > 0)
        {
             let transactionArr:NSArray = responseDict?.value(forKey: "transactions") as! NSArray
            if(transactionArr.count > 0)
            {
                tableView.isHidden = false
                sectionArr = NSMutableArray()
                sectionArr = NSMutableArray(array: transactionArr as! [Any])
                tableView.reloadData()
             }
            else
            {
                nodetailView.isHidden = false
                 tableView.isHidden = true
             }
         }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickMenu(_ sender: Any) {
        if(!isfromOtherpage)
        {
        self.findHamburguerViewController()?.showMenuViewController()
        }
        else
        {
            self.navigationController?.pop(animated: true)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
 

}


// MARK: - LUExpandableTableViewDataSource

extension MytransactionVC: LUExpandableTableViewDataSource {
    func numberOfSections(in expandableTableView: LUExpandableTableView) -> Int {
        return sectionArr.count
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        let Dict:NSDictionary = sectionArr[section] as! NSDictionary
        let array:NSArray = Dict.object(forKey: "extendDetails") as! NSArray
        return array.count
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? MytransactableViewCell else {
            assertionFailure("Cell shouldn't be nil")
            return UITableViewCell()
        }
        
        let Dict:NSDictionary = sectionArr[indexPath.section] as! NSDictionary
        let extendarray:NSArray = Dict.object(forKey: "extendDetails") as! NSArray
        let extendDict:NSDictionary = extendarray[indexPath.row] as! NSDictionary
        
        let days:String = (Themes.sharedInstance.CheckNullvalue(Passed_value:  extendDict.object(forKey: "no_of_days")))
        if(days == "1" || days == "0")
        {
            cell.cost_Lbl.text = "(Cost for \(Themes.sharedInstance.CheckNullvalue(Passed_value:  extendDict.object(forKey: "no_of_days"))) day)"

        }
        else
        {
            cell.cost_Lbl.text = "(Cost for \(Themes.sharedInstance.CheckNullvalue(Passed_value:  extendDict.object(forKey: "no_of_days"))) days)"
         }
        cell.header_Lbl.text = "\(Themes.sharedInstance.CheckNullvalue(Passed_value:  extendDict.object(forKey: "label")))"
        
        
        cell.amt_Lbl.text = Themes.sharedInstance.Getcurrency() +  " \(Themes.sharedInstance.CheckNullvalue(Passed_value:  extendDict.object(forKey: "total_amount")))"
        cell.dateadded.text =  "\(Themes.sharedInstance.CheckNullvalue(Passed_value:  extendDict.object(forKey: "dateAdded")))"


        return cell
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, sectionHeaderOfSection section: Int) -> LUExpandableTableViewSectionHeader {
        guard let sectionHeader = expandableTableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderReuseIdentifier) as? MytransactionView else {
            assertionFailure("Section header shouldn't be nil")
            return LUExpandableTableViewSectionHeader()
        }
        
        let Dict:NSDictionary = sectionArr[section] as! NSDictionary
        let array:NSArray = Dict.object(forKey: "extendDetails") as! NSArray
        if(array.count == 0)
        {
            sectionHeader.expandCollapseButton.isHidden = true
        }
        else
        {
            sectionHeader.expandCollapseButton.isHidden = false

        }
        sectionHeader.car_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value:  Dict.object(forKey: "carInfo"))
        let days:String = (Themes.sharedInstance.CheckNullvalue(Passed_value:  Dict.object(forKey: "no_of_days")))
//        if(days == "1" || days == "0")
//        {
//            sectionHeader.rent1_Lbl.text = "Rental Cost for \(Themes.sharedInstance.CheckNullvalue(Passed_value:  Dict.object(forKey: "no_of_days"))) day"
//
//        }
//        else
//        {
//            sectionHeader.rent1_Lbl.text = "Rental Cost for \(Themes.sharedInstance.CheckNullvalue(Passed_value:  Dict.object(forKey: "no_of_days"))) days"
//
//        }
//        sectionHeader.rent1Amt.text  = "\(Themes.sharedInstance.Getcurrency()) \(Themes.sharedInstance.CheckNullvalue(Passed_value:  Dict.object(forKey: "rental_cost")))"
        sectionHeader.totalAmt.text = "\(Themes.sharedInstance.Getcurrency()) \(Themes.sharedInstance.CheckNullvalue(Passed_value:  Dict.object(forKey: "total_amount")))"
        

        return sectionHeader
    }
}

// MARK: - LUExpandableTableViewDelegate

extension MytransactionVC: LUExpandableTableViewDelegate {
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
        return 99
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        /// Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
        return 113
    }
    
    // MARK: - Optional
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select cell at section \(indexPath.section) row \(indexPath.row)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectSectionHeader sectionHeader: LUExpandableTableViewSectionHeader, atSection section: Int) {
        print("Did select section header at section \(section)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Will display cell at section \(indexPath.section) row \(indexPath.row)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplaySectionHeader sectionHeader: LUExpandableTableViewSectionHeader, forSection section: Int) {
        print("Will display section header for section \(section)")
    }
}
