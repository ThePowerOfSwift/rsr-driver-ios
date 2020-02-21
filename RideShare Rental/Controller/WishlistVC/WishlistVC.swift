//
//  WishlistVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 23/01/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
var Appdel=UIApplication.shared.delegate as! AppDelegate

class WishlistVC: UIViewController {
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    var Datasource:NSMutableArray = NSMutableArray()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nodetailView: UIView!
     override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "WishlisttableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "WishlisttableViewCellID")
        tableView.estimatedRowHeight = 269
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        nodetailView.isHidden = true

        self.Getwishlist(Param: [:])

        // Do any additional setup after loading the view.
    }
    
    
    func Getwishlist(Param:[String:String])
    {
        self.ShowSpinner()
        tableView.isHidden = true
         URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.wishlists as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
                        self.nodetailView.isHidden = false
                        Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "msg")), isSuccess: false)
                    }
                    
                }
            }
            else
            {
                self.nodetailView.isHidden = false

                 Themes.sharedInstance.showErrorpopup(Msg: Constant.sharedinstance.errormessage)
            }
        })
    }
    func GetDetail(responseDict:NSDictionary?)
    {
   let detailDictArr:NSArray = responseDict?.value(forKey: "wishlistCars") as! NSArray
        if(detailDictArr.count > 0)
        {
            tableView.isHidden = false

        }
        else
        {
            self.nodetailView.isHidden = false

        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickMenuBtn(_ sender: Any) {
        self.findHamburguerViewController()?.showMenuViewController()

    }
    @IBAction func DidclickFindCar(_ sender: Any) {
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
    
   
}

extension WishlistVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 269
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WishlisttableViewCell  = tableView.dequeueReusableCell(withIdentifier: "WishlisttableViewCellID") as! WishlisttableViewCell
        cell.selectionStyle = .none
        cell.userimage.tag = indexPath.row
        cell.wrapperView.dropShadow()
 
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     }
}
