//
//  InboxVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 15/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage


class InboxVC: UIViewController, UISearchControllerDelegate,UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet var newmessageBtn: CustomButton!
    @IBOutlet var edit_Btn: CustomButton!
    var iswithowner:Bool = Bool()
    var iswithadmin:Bool = Bool()
    var iswithdirectowner:Bool = Bool()
    var iswithdirectadmin:Bool = Bool()
    var isnewMessage:Bool = Bool()
    var receiver_arr:NSArray = NSArray()
    
    @IBOutlet var nodetailView: UIView!
    @IBOutlet var tableView: UITableView!
    var dataSourceArr:NSMutableArray = NSMutableArray()
    var orgdatasource:NSMutableArray = NSMutableArray()
    
    lazy fileprivate var searchController = UISearchController(searchResultsController: nil)
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    var isEditable:Bool = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "messagetableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "messagetableViewCellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 95
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        nodetailView.isHidden = true
        isEditable = false
        edit_Btn.isHidden = false
        newmessageBtn.isHidden = false
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        tableView.isEditing = false
        searchController.delegate=self
        searchController.searchBar.delegate=self
        searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func DidclickEdit(_ sender: Any) {
        isEditable = !isEditable
        
        tableView.setEditing(isEditable, animated: true)
        edit_Btn.setTitle(isEditable == true ? "Done":"Edit", for: .normal)
        if(isnewMessage)
        {
            newmessageBtn.setTitle(isEditable == true ? "Delete":"New message", for: .normal)
        }
        else
        {
            newmessageBtn.setTitle("Delete", for: .normal)
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.Inboxdata(Param: [:])
        
    }
    @IBAction func didclicknewmessage(_ sender: Any) {
        let Btn:UIButton = sender as! UIButton
        print(Btn.titleLabel?.text as Any)
        if((Btn.titleLabel?.text)! == "New message")
        {
            let DocumentVC = storyboard?.instantiateViewController(withIdentifier:"NewMessageVCID" ) as! NewMessageVC
            DocumentVC.isfromowner =  iswithdirectowner
            DocumentVC.isfromAdmin = iswithdirectadmin
            DocumentVC.delegate = self
            DocumentVC.driverArr = NSMutableArray(array: receiver_arr as! [Any])
            DocumentVC.modalPresentationStyle = .overFullScreen
            self.present(DocumentVC, animated: false, completion: nil)
        }
        else if((Btn.titleLabel?.text)!  == "Delete")
        {
            if(!isEditable)
            {
                isEditable = !isEditable
                tableView.setEditing(isEditable, animated: true)
                edit_Btn.setTitle(isEditable == true ? "Done":"Edit", for: .normal)
                
            }
            else
            {
                if let selectedIndex = tableView.indexPathsForSelectedRows
                {
                    
                    if(selectedIndex.count > 0)
                    {
                        AJAlertController.initialization().showAlert(aStrMessage: "Are you sure you want to delete?",
                                                                     aCancelBtnTitle: "NO",
                                                                     aOtherBtnTitle: "YES")
                        { (index, title) in
                            if(index == 1)
                            {
                                var idArr:[String] = [String]()
                                selectedIndex.forEach { (index) in
                                    let dict:NSDictionary =  self.dataSourceArr[index.row] as! NSDictionary
                                    idArr.append(Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "booking_no")))
                                }
                                if(idArr.count > 0)
                                {
                                    self.DeleteMessages(Param: ["booking_nos":idArr])
                                }
                            }
                        }
                        
                    }
                }
                else
                {
                    Themes.sharedInstance.showErrorpopup(Msg: "Kindly choose the message to delete")
                }
            }
            
        }
        
    }
    
    
    
    
    
    func DeleteMessages(Param:[String:Any])
    {
        
        
        var url = ""
        if(iswithowner)
        {
            url =  Constant.sharedinstance.delete_messages as String
            newmessageBtn.setTitle("Delete", for: .normal)
            isnewMessage = false
        }
        if(iswithadmin)
        {
            url =  Constant.sharedinstance.delete_admin_messages as String
            newmessageBtn.setTitle("Delete", for: .normal)
            isnewMessage = false
            
            
        }
        if(iswithdirectowner)
        {
            url =  Constant.sharedinstance.delete_direct_messages as String
            isnewMessage = true
        }
        if(iswithdirectadmin)
        {
            url =  Constant.sharedinstance.delete_direct_messages as String
        }
        Themes.sharedInstance.activityView(View: self.view)
        URLhandler.sharedinstance.makeCall(url:url, param: Param, completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "msg")), isSuccess: true)
                        self.isEditable = !self.isEditable
                        self.tableView.setEditing(self.isEditable, animated: true)
                        self.Inboxdata(Param: [:])
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
    func Inboxdata(Param:[String:String])
    {
        
        
        var url = ""
        if(iswithowner)
        {
            url =  Constant.sharedinstance.inbox as String
            newmessageBtn.setTitle("Delete", for: .normal)
            isnewMessage = false
        }
        if(iswithadmin)
        {
            url =  Constant.sharedinstance.inbox_admin as String
            newmessageBtn.setTitle("Delete", for: .normal)
            isnewMessage = false
            
            
        }
        if(iswithdirectowner)
        {
            url =  Constant.sharedinstance.inbox_direct as String
            isnewMessage = true
            
            
        }
        if(iswithdirectadmin)
        {
            url =  Constant.sharedinstance.inbox_direct_admin as String
        }
        edit_Btn.isHidden = true
        newmessageBtn.isHidden = true
        
        self.ShowSpinner()
        tableView.isHidden = true
        URLhandler.sharedinstance.makeCall(url:url, param: Param, completionHandler: {(responseObject, error) ->  () in
            self.StopSPinner()
            
            if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        let CommDict:NSDictionary = responseObject?.value(forKey: "commonArr") as! NSDictionary
                        let unread_message_count:String =  Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "unread_message_count"))
                        if(unread_message_count != "" && unread_message_count != "0")
                        {
                            //                            self.msg_Lbl.text = "Message (\(unread_message_count))"
                        }
                        else
                        {
                            //                            self.msg_Lbl.text = "Message"
                            
                        }
                        Themes.sharedInstance.SavemessageCount(user_id: Themes.sharedInstance.CheckNullvalue(Passed_value: CommDict.value(forKey: "unread_message_count")))
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
        let active_Array:NSArray = responseDict?.object(forKey: "messages") as!  NSArray
        
        
        if(active_Array.count > 0)
        {
            
            
            dataSourceArr.removeAllObjects()
            tableView.isHidden = false
            dataSourceArr = NSMutableArray(array: active_Array as! [Any])
            orgdatasource = NSMutableArray(array: active_Array as! [Any])
            
            tableView.reloadData()
            nodetailView.isHidden = true
            edit_Btn.isHidden = false
            newmessageBtn.isHidden = false
            
            tableView.tableHeaderView = searchController.searchBar
            
            
            if(iswithdirectadmin)
            {
                newmessageBtn.isHidden = true
                edit_Btn.isHidden = true
                tableView.frame = CGRect.init(x: tableView.frame.origin.x, y: 20, width: tableView.frame.size.width, height: self.view.frame.size.height)
                
            }
        }
        else
        {
            tableView.tableHeaderView = nil
            
            if(iswithdirectadmin)
            {
                newmessageBtn.isHidden = false
                isnewMessage = false
            }
            
            
            tableView.isHidden = true
            nodetailView.isHidden = false
        }
        
        if(iswithdirectowner)
        {
            receiver_arr = responseDict?.object(forKey: "receiversArr") as!  NSArray
            if(receiver_arr.count > 0)
            {
                isnewMessage = true
                newmessageBtn.isHidden = false
                
                
            }
            else
            {
                newmessageBtn.isHidden = false
                isnewMessage = false
                newmessageBtn.setTitle("Delete", for: .normal)
                
            }
            
        }
        
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSourceArr = NSMutableArray(array: orgdatasource.mutableCopy() as! [[String:Any]])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        // searchController.responds(to: )
        // searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        if (searchController.searchBar.text?.count)! > 0 {
            let searchText = searchController.searchBar.text!
            print(searchText)
            if(iswithdirectowner || iswithdirectadmin)
            {
                
                
                
                dataSourceArr = NSMutableArray(array:  (orgdatasource.mutableCopy() as! [[String:Any]]).filter{($0["sender_name"] as! String).lowercased().localizedCaseInsensitiveContains(searchText.lowercased()) || ($0["message"] as! String).lowercased().localizedCaseInsensitiveContains(searchText.lowercased())})
                
                
            }
            else
            {
                dataSourceArr = NSMutableArray(array:  (orgdatasource.mutableCopy() as! [[String:Any]]).filter{($0["sender_name"] as! String).lowercased().localizedCaseInsensitiveContains(searchText.lowercased()) || ($0["booking_no"] as! String).lowercased().localizedCaseInsensitiveContains(searchText.lowercased()) || ($0["message"] as! String).lowercased().localizedCaseInsensitiveContains(searchText.lowercased()) || ($0["car_make"] as! String).lowercased().localizedCaseInsensitiveContains(searchText.lowercased()) || ($0["car_model"] as! String).lowercased().localizedCaseInsensitiveContains(searchText.lowercased()) || ($0["year"] as! String).lowercased().localizedCaseInsensitiveContains(searchText.lowercased())})
                
            }
            
            
            
            
        }
        else {
            
            dataSourceArr = NSMutableArray(array: orgdatasource.mutableCopy() as! [[String:Any]])
            
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.layoutIfNeeded()
        tableView.reloadData()
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickInbox(_ sender: Any) {
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
    
}

extension InboxVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:messagetableViewCell  = tableView.dequeueReusableCell(withIdentifier: "messagetableViewCellID") as! messagetableViewCell
        //        cell.selectionStyle = .none
        cell.message_Lbl.sizeToFit()
        let dic:NSDictionary = dataSourceArr[indexPath.row] as! NSDictionary
        cell.name_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "sender_name"))
        cell.user_img.sd_setImage(with: URL(string: Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "sender_pic"))), placeholderImage: #imageLiteral(resourceName: "avatar"))
        if(iswithdirectadmin || iswithdirectowner)
        {
            cell.message_Lbl.text = "\(Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "message")))"
        }
        else
        {
            cell.message_Lbl.text = "\(Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "car_make"))) \(Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "car_model"))) \(Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "year")))\nBOOKING NO:\n\(Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "booking_no")))\n\(Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "message")))"
        }
        cell.date_Lbl.text = Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "dateAdded"))
        if(Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "read_status")) == "No")
        {
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        }
        else
        {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.dismiss(animated: true, completion: nil)
        searchController.searchBar.resignFirstResponder()

        if(!isEditable)
        {
            let ChatVC = storyboard?.instantiateViewController(withIdentifier:"ChatVCID" ) as! ChatVC
            let dic:NSDictionary = dataSourceArr[indexPath.row] as! NSDictionary
            ChatVC.bookingNo = Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "booking_no"))
            ChatVC.user_name =    Themes.sharedInstance.CheckNullvalue(Passed_value: dic.object(forKey: "sender_name"))
            
            ChatVC.iswithowner = iswithowner
            ChatVC.iswithadmin = iswithadmin
            ChatVC.iswithdirectowner = iswithdirectowner
            ChatVC.iswithdirectadmin = iswithdirectadmin
            
            self.navigationController?.pushViewController(ChatVC, animated: true)
        }
        
    }
    
}

extension InboxVC:NewMessageVCDelegate
{
    func Updatemessage() {
        self.Inboxdata(Param: [:])
    }
}



