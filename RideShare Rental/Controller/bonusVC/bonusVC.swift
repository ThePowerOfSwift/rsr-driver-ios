//
//  bonusVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage

class bonusVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nodetailWrapperView: UIView!
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    var dataSourceArr:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "bonusTableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "bonusTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        Gettreedata(Param:[:])
        tableView.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    func Gettreedata(Param:[String:String])
    {
        self.ShowSpinner()
        tableView.isHidden = true
        self.nodetailWrapperView.isHidden = true
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.sample_tree as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
    func GetDetail(responseDict:NSDictionary?)
    {
        if(responseDict != nil)
        {
            let treeArr:NSArray = responseDict?.object(forKey: "bonuses") as! NSArray
             if(treeArr.count > 0)
            {
                dataSourceArr = NSMutableArray()
                self.tableView.isHidden = false
                dataSourceArr = NSMutableArray(array: treeArr as! Array)
                self.tableView.reloadData()
            }
            else
            {
                self.nodetailWrapperView.isHidden = false
                
            }
        }
    }
    func ShowSpinner()
    {
        activityIndicatorView.color = Themes.sharedInstance.returnThemeColor()
        activityIndicatorView.center=CGPoint(x:UIScreen.main.bounds.size.width/2,y:  tableView.frame.origin.y+20);
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension bonusVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSourceArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 219
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:bonusTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "bonusTableViewCell") as! bonusTableViewCell
        cell.selectionStyle = .none
        let dict:NSDictionary = dataSourceArr[indexPath.row] as! NSDictionary
        cell.dateLbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "dateAdded"))
        var type:String = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "type"))
        
        if(type != "Referral")
        {
            type = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rank"))
        }
        cell.rankLbl.text = type + "(\(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "drivername"))))"
        cell.bonusLbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "amount")) + " \(Themes.sharedInstance.Getcurrency())"
        cell.paymentLbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "status"))
         return cell
    }
   
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
 }
