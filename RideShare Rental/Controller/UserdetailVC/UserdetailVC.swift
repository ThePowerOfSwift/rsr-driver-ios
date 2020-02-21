//
//  UserdetailVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class UserdetailVC: UIViewController {
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var name_Lbl: CustomLabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var addressLbl: CustomLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        wrapperView.layer.cornerRadius = 3.0
        let nibName = UINib(nibName: "UserDetailtableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "UserDetailtableViewCellID")
        tableView.estimatedRowHeight = 32
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in
            self.wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
                self.wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
                    self.wrapperView.transform = .identity
                })
            })
        })
    }
    
    func DismissView()
    {
        self.wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in
            self.wrapperView.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            
        }, completion: {(_ finished: Bool) -> Void in
            
            self.dismiss(animated:false, completion: nil)
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DidClickClose(_ sender: Any) {
   DismissView()
     }
 
}

extension UserdetailVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserDetailtableViewCell  = tableView.dequeueReusableCell(withIdentifier: "UserDetailtableViewCellID") as! UserDetailtableViewCell
        cell.selectionStyle = .none
         return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        
     }
 }
