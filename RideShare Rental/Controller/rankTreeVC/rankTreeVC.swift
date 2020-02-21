//
//  rankTreeVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ObjectMapper
import SDWebImage

class rankTreeVC: UIViewController {
    
    @IBOutlet var headerwrapperView: CustomView!
    @IBOutlet var sub_lbl: CustomLabel!
    
    @IBOutlet var name_lbl: CustomLabel!
    @IBOutlet var nodetailWrapperView: UIView!
    @IBOutlet var tableView: UITableView!
    var treeViewDataSource = [TreeViewNodeItem]()
    var dataHandler: TreeViewDataHandler? = TreeViewDataHandler()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    var id:String = String()
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
        self.Gettreedata(Param: ["changeId":id])
    }
    @IBAction func Didclickback(_ sender: Any) {
        self.navigationController?.pop(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidclickRoot(_ sender: Any) {
        let treeUserDetailVC = storyboard?.instantiateViewController(withIdentifier:"treeUserDetailVCID" ) as! treeUserDetailVC
        treeUserDetailVC.objRecord =  rootRelation
        treeUserDetailVC.modalPresentationStyle = .overFullScreen
        self.present(treeUserDetailVC, animated: false, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func Gettreedata(Param:[String:String])
    {
        self.ShowSpinner()
        tableView.isHidden = true
        headerwrapperView.isHidden = true
        headerwrapperView.isHidden = true
        self.nodetailWrapperView.isHidden = true
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.tree_change as String, param: Param, completionHandler: {(responseObject, error) ->  () in
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
                        self.treeViewDataSource = (dataHandler?.configureTreeViewDatasource(relations!,is_expand:true))!
                    }
                    print(self.treeViewDataSource.count)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    for i in 0..<treeViewDataSource.count
                    {
                        print(treeViewDataSource.count)

                        let node: TreeViewNodeItem = self.treeViewDataSource[i]
                         let relation = node.nodeObject
                        if(relation?.ismodified == "Yes")
                        {

                            let index:IndexPath = IndexPath.init(row: i, section: 0)
 
                            self.scrolltoindex(index: index)
                        }
                     

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
        activityIndicatorView.center=CGPoint(x:UIScreen.main.bounds.size.width/2,y:  tableView.frame.origin.y+10);
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
    }
    func StopSPinner()
    {
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    
    //MARK: RATreeView delegate
    
}
extension rankTreeVC:UITableViewDataSource,UITableViewDelegate
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
        if(relation?.ismodified == "Yes")
        {
            cell.wrapperView.blink()

        }
        else
        {
            cell.wrapperView.layer.removeAllAnimations()
        }
        cell.detailBtn.tag = indexPath.row
        cell.detailBtn.addTarget(self, action: #selector(self.movetodetail(sender:)), for: .touchUpInside)
 
        cell.setNeedsDisplay()
        
        return cell
    }
    
    func scrolltoindex(index:IndexPath)
    {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.tableView.scrollToRow(at: index, at: .middle, animated: true)
        }
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

extension UIView {
    func blink() {
        UIView.animate(withDuration: 0.5, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })
//        dispatch_after(dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),Int64(2 * NSEC_PER_SEC)),dispatch_get_main_queue()){
//            [weak self] in
//            self?.layer.removeAllAnimations()
//        }
    }
}


