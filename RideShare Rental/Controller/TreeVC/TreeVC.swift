//
//  TreeVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 14/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView
import ObjectMapper

class TreeVC: UIViewController {
    @IBOutlet var headerwrapperView: CustomView!
    @IBOutlet var sub_lbl: CustomLabel!

    @IBOutlet var name_lbl: CustomLabel!
    @IBOutlet var nodetailWrapperView: UIView!
    @IBOutlet var tableView: UITableView!
    var treeViewDataSource = [TreeViewNodeItem]()
    var dataHandler: TreeViewDataHandler? = TreeViewDataHandler()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    var rootRelation:RelationshipDetails!
      override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "FamilyTreetableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "FamilyTreetableViewCell")
        tableView.estimatedRowHeight = 65
         tableView.separatorColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(TreeVC.relodeTreeView(_:)), name: NSNotification.Name(rawValue: "RelodeTreeView"), object: nil)
        self.Gettreedata(Param: [:])


      }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        // Loading and converting JSON data
      
    }
    
    func Gettreedata(Param:[String:String])
    {
        self.ShowSpinner()
         tableView.isHidden = true
       headerwrapperView.isHidden = true
        headerwrapperView.isHidden = true
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
            let treeArr:NSArray = responseDict?.object(forKey: "treeArr") as! NSArray
            if(treeArr.count > 0)
            {
            print(treeArr)
            let relationObjects = Relations(JSON:treeArr[0]  as! [String : Any])!
            tableView.isHidden = false
                headerwrapperView.isHidden = false
                rootRelation = Mapper<RelationshipDetails>().map(JSON: treeArr[0]  as! [String : Any])
                 name_lbl.text = rootRelation.name!
                sub_lbl.text = rootRelation.rank!
                if(rootRelation.color_code != nil)
                {
                    self.headerwrapperView.backgroundColor =  Themes.sharedInstance.colorWithHexString(hex: rootRelation.color_code!)

                }
                else
                {
                    self.headerwrapperView.backgroundColor =  UIColor.red

                }
 
             if let object = responseDict as? [String: Any] {
                // json is a dictionary
                   let relations: [RelationshipDetails]? = relationObjects.relations!
                  if (relations != nil) {
                    //  Creating tree datasource here.
                    self.treeViewDataSource = (dataHandler?.configureTreeViewDatasource(relations!,is_expand:false))!
                }
                print(self.treeViewDataSource.count)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
                }
            else
            {
                self.nodetailWrapperView.isHidden = false

            }
            
        }
        else
        {
            self.nodetailWrapperView.isHidden = false

        }
     }
    func ShowSpinner()
    {
        activityIndicatorView.color = Themes.sharedInstance.returnThemeColor()
        activityIndicatorView.center=CGPoint(x:UIScreen.main.bounds.size.width/2,y:  tableView.frame.origin.y-10);
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
    }
    func StopSPinner()
    {
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    @IBAction func DidclickRoot(_ sender: Any) {
        let treeUserDetailVC = storyboard?.instantiateViewController(withIdentifier:"treeUserDetailVCID" ) as! treeUserDetailVC
        treeUserDetailVC.objRecord =  rootRelation
        treeUserDetailVC.modalPresentationStyle = .overFullScreen
        self.present(treeUserDetailVC, animated: false, completion: nil)
    }
    
    //MARK: RATreeView delegate
    
 }
extension TreeVC:UITableViewDataSource,UITableViewDelegate
{
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Tableview methodes
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treeViewDataSource.count;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView()
         return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = (self.tableView.dequeueReusableCell(withIdentifier: "FamilyTreetableViewCell") as! FamilyTreetableViewCell)
//        if(indexPath.row == 0)
//        {
//            cell.isHeaderCell = true
//            let relation = rootRelation
//            cell.titleLable.text = relation?.name
//            cell.subTitleLable.text = relation?.rank
//             if(relation?.color_code != nil)
//            {
//                cell.wrapperView.backgroundColor =  Themes.sharedInstance.colorWithHexString(hex: (relation?.color_code)!)
//            }
//            cell.selectionStyle = .none
//            cell.treeButton.isHidden = true
//        }
//        else
//        {
            let node: TreeViewNodeItem = self.treeViewDataSource[indexPath.row]
            let relation = node.nodeObject

            cell.isHeaderCell = false

            cell.treeNode = node
            cell.titleLable.text = relation?.name
            cell.subTitleLable.text = relation?.rank
            cell.selectionStyle = .none
            if (node.isExpanded == true)
            {
                cell.setTheButtonBackgroundImage(UIImage(named: "arrow_down")!)
            }
            else
            {
                cell.setTheButtonBackgroundImage(UIImage(named: "arrow_right")!)
            }
            if(node.nodeChildren != nil)
            {
                cell.treeButton.isHidden = false
            }
            else
            {
                cell.treeButton.isHidden = true
            }
            if(relation?.color_code != nil)
            {
                cell.wrapperView.backgroundColor =  Themes.sharedInstance.colorWithHexString(hex: (relation?.color_code)!)
            }
        cell.detailBtn.tag = indexPath.row
        cell.detailBtn.addTarget(self, action: #selector(self.movetodetail(sender:)), for: .touchUpInside)
//         }
      
         cell.setNeedsDisplay()
     
        return cell
    }
    @objc func movetodetail(sender:UIButton)
    {
        let node: TreeViewNodeItem = self.treeViewDataSource[sender.tag]
        
        let treeUserDetailVC = storyboard?.instantiateViewController(withIdentifier:"treeUserDetailVCID" ) as! treeUserDetailVC
        treeUserDetailVC.objRecord =  node.nodeObject!
        treeUserDetailVC.modalPresentationStyle = .overFullScreen
        self.present(treeUserDetailVC, animated: false, completion: nil)

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
     }
     // MARK: - Utility methodes
     @objc func relodeTreeView(_ notification: Notification) {
        self.treeViewDataSource = (dataHandler?.refreshNodes())!
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

