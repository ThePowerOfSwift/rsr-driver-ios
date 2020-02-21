//
//  ContractHistoryVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/01/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import TOWebViewController


class ContractHistoryVC: UIViewController {
    @IBOutlet var searchbar: UISearchBar!
    @IBOutlet weak var searchView: CustomView!

     @IBOutlet var nodetailView: UIView!
    @IBOutlet var tableView: UITableView!
         let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    var orgdatasource:NSMutableArray = NSMutableArray()

    var dataSourceArr:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ContracttableVIewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "ContracttableVIewCellID")
         tableView.dataSource = self
        tableView.delegate = self
        nodetailView.isHidden = true
        self.Contractdata(Param: [:])
        searchbar.delegate = self
        if let textfield = searchbar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                // Background color
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10.0
                backgroundview.clipsToBounds = true
            }
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func DidclickClose(_ sender: Any)
    {
        searchView.isHidden = true
        searchbar.resignFirstResponder()
        dataSourceArr = NSMutableArray(array: orgdatasource.mutableCopy() as! [[String:Any]])
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    @IBAction func didclickSerach(_ sender: Any) {
        searchView.becomeFirstResponder()
        searchView.isHidden = false
    }

    
    func Contractdata(Param:[String:String])
    {
        dataSourceArr = NSMutableArray()
        self.ShowSpinner()
        tableView.isHidden = true
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.contract_history as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
        dataSourceArr = NSMutableArray()
        let active_Array:NSArray = responseDict?.object(forKey: "contract_history") as!  NSArray
        if(active_Array.count > 0)
        {
            tableView.isHidden = false
            dataSourceArr = NSMutableArray(array: active_Array as! [Any])
            orgdatasource = NSMutableArray(array: active_Array as! [Any])

            tableView.reloadData()
            nodetailView.isHidden = true

            
        }
        else
        {
            tableView.isHidden = true

            nodetailView.isHidden = false
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickMenu(_ sender: Any) {
        self.findHamburguerViewController()?.showMenuViewController()

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
extension ContractHistoryVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSourceArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 361
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ContracttableVIewCell  = tableView.dequeueReusableCell(withIdentifier: "ContracttableVIewCellID") as! ContracttableVIewCell
        cell.selectionStyle = .none
        let dict:NSDictionary = dataSourceArr[indexPath.row] as! NSDictionary
        cell.owner_name.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "ownername"))
        cell.SetRatingView(value:CGFloat(Double(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "rating")))!))
        cell.carinfo.text = "\(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_make"))) \(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "car_model"))) \(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "year")))"
        cell.bookinfo.text = "\(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "date_from"))) - \(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "date_to")))"
        cell.spent.text = Themes.sharedInstance.Getcurrency() + " " + Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "total_amount"))
        cell.insuranceDocBtn.tag = indexPath.row
        cell.insuranceDocBtn.addTarget(self, action: #selector(self.MovetoDocVC(sender:)), for: .touchUpInside)
 
        return cell
    }
    
    
    @objc func MovetoDocVC(sender:UIButton)
    {
        let dict:NSDictionary = dataSourceArr[sender.tag] as! NSDictionary
        let docArr:NSArray? = dict.object(forKey: "documents") as? NSArray
        if(docArr != nil)
        {
            if((dict.object(forKey: "documents") as! NSArray).count > 0)
            {
                let Dict = (dict.object(forKey: "documents") as! NSArray)[0] as! NSDictionary
                
                navigationController?.setNavigationBarHidden(false, animated: true)
                let webViewController = TOWebViewController(url: (URL(string: Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "link"))))!)
                navigationController?.pushViewController(webViewController!, animated: true)
            }
                
            else
            {
                Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: "No Documents", isSuccess: false)
            }
        }
        else
        {
            Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: "No Documents", isSuccess: false)
            
        }
    }
    
    
 
    @objc func MovetoDetailVC(sender:UIButton)
    {
        let UserdetailVC = storyboard?.instantiateViewController(withIdentifier:"UserdetailVCID" ) as! UserdetailVC
        UserdetailVC.modalPresentationStyle = .overFullScreen
        self.present(UserdetailVC, animated: false, completion: nil)
        
        
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
extension ContractHistoryVC:UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "")
        {
            dataSourceArr = NSMutableArray(array: orgdatasource.mutableCopy() as! [[String:Any]])
            
        }
        else
        {
            dataSourceArr = NSMutableArray(array:  (orgdatasource.mutableCopy() as! [[String:Any]]).filter{($0["ownername"] as! String).lowercased().localizedCaseInsensitiveContains(searchText.lowercased())})
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
}
