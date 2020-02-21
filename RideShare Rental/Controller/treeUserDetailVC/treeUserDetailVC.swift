//
//  treeUserDetailVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/02/18.
//  Copyright © 2018 RideShare Rental. All rights reserved.
//

import UIKit
import SDWebImage

class treeUserDetailVC: UIViewController {

    @IBOutlet var refLbl: CustomLabel!
    @IBOutlet var emailLbl: CustomLabel!
    @IBOutlet var nameLbl: CustomLabel!
    @IBOutlet var profpic: CustomimageView!
    @IBOutlet var wrapperView: UIView!
    var objRecord:RelationshipDetails!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refLbl.text = objRecord.referral_code!
        emailLbl.text  = objRecord.email!
        nameLbl.text = objRecord.name!
        print(objRecord.profile_pic)
        if(objRecord.profile_pic != nil)
        {
        profpic.sd_setImage(with: URL(string: objRecord.profile_pic!), placeholderImage: #imageLiteral(resourceName: "avatar"))
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    @IBAction func didClickClose(_ sender: UIButton) {
        DismissView()
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
