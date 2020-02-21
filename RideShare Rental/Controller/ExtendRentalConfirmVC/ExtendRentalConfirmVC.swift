//
//  ExtendRentalConfirmVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 14/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit

class ExtendRentalConfirmVC: UIViewController {
    @IBOutlet var todate_Lbl: CustomLabel!
     @IBOutlet var tableView: UITableView!
    @IBOutlet var scroll_View: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "PricetableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "PricetableViewCellID")
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self


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
    
    @IBAction func DidclickConfirm(_ sender: Any) {
        let PaymentSuccessVC = storyboard?.instantiateViewController(withIdentifier:"PaymentSuccessVCID" ) as! PaymentSuccessVC
        self.navigationController?.pushViewController(PaymentSuccessVC, animated: true)

    }
    
     @IBAction func DidclickDismiss(_ sender: Any) {
    self.navigationController?.popToRoot(animated: true)
    }
    
}
extension ExtendRentalConfirmVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PricetableViewCell  = tableView.dequeueReusableCell(withIdentifier: "PricetableViewCellID") as! PricetableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
