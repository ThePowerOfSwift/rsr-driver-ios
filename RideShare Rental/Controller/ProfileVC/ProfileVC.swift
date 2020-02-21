//
//  ProfileVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 08/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileVC: UIViewController {

    @IBOutlet var number_Lbl: CustomLabel!
    @IBOutlet var email_Lbl: CustomLabel!
    @IBOutlet var name_Lbl: CustomLabel!
    @IBOutlet var profile_img: CustomimageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    var objRecord:ProfileRecord = ProfileRecord()
    var Perdatasource:NSMutableArray = NSMutableArray()
    var Licedatasource:NSMutableArray = NSMutableArray()
    var Adddatasource:NSMutableArray = NSMutableArray()
    var Contactdatasource:NSMutableArray = NSMutableArray()

     override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ProfiletableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "ProfiletableViewCellID")
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetData()
      }
    
    func GetData()
    {
        scrollView.isHidden = true
        Themes.sharedInstance.activityView(View: self.view)
        
        URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.profile as String, param: [:], completionHandler: {(responseObject, error) ->  () in
            Themes.sharedInstance.RemoveactivityView(View: self.view)
            if(error == nil)
            {
                self.scrollView.isHidden = false

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
                        self.scrollView.isHidden = true

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
        Perdatasource = NSMutableArray()
        Licedatasource = NSMutableArray()
        Adddatasource = NSMutableArray()
        Contactdatasource = NSMutableArray()

        let detailDict:NSDictionary = responseDict?.value(forKey: "driverDetails") as! NSDictionary
        objRecord.address = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "address"))
        objRecord.apt_no = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "apt_no"))
        objRecord.background_check = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "background_check"))
        objRecord.id = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "id"))
        objRecord.id_verified = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "id_verified"))
       objRecord.licence_exp_date = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "licence_exp_date"))
        objRecord.licence_image = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "licence_image"))
        objRecord.licence_number = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "licence_number"))
        objRecord.licence_state = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "licence_state"))
        objRecord.phone_no = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "phone_no"))
        objRecord.profile_pic = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "profile_pic"))
       objRecord.state = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "state"))
        objRecord.zip = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "zip"))
        
        objRecord.firstname = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "firstname"))
        objRecord.lastname = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "lastname"))

         objRecord.birthday = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "birthday"))
         objRecord.city = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "city"))
         objRecord.country = Themes.sharedInstance.CheckNullvalue(Passed_value: detailDict.value(forKey: "country"))
        for i in 0..<5
        {
            let Profobjrecord:ProfileRecord = ProfileRecord()
            
            if(i == 0)
            {
                Profobjrecord.title = "Street"
                Profobjrecord.desc = objRecord.address
 
            }
            else if(i == 1)
            {
                Profobjrecord.title = "H/Apt No"
                Profobjrecord.desc = objRecord.apt_no
                
            }
            else if(i == 2)
            {
                Profobjrecord.title = "City"
                Profobjrecord.desc = objRecord.city
 
            }
            else  if(i == 3)
            {
                Profobjrecord.title = "State"
                Profobjrecord.desc = objRecord.state
             }
            else  if(i == 4)
            {
                Profobjrecord.title = "Zip"
                Profobjrecord.desc = objRecord.zip
            }
            Adddatasource.add(Profobjrecord)
        }
        
        for i in 0..<2
        {
            let Profobjrecord:ProfileRecord = ProfileRecord()
            
            if(i == 0)
            {
                Profobjrecord.title = "Phone"
                Profobjrecord.desc = objRecord.phone_no

            }
            
            else if(i == 1)
            {
                Profobjrecord.title = "Email"
                Profobjrecord.desc = Themes.sharedInstance.Getemail()

            }
            Contactdatasource.add(Profobjrecord)
         }
        
        for i in 0..<3
        {
            let Profobjrecord:ProfileRecord = ProfileRecord()
            let Licenseobjrecord:ProfileRecord = ProfileRecord()

            if(i == 0)
            {
               Profobjrecord.title = "First Name"
               Profobjrecord.desc = objRecord.firstname
               Licenseobjrecord.title = "License Number"
               Licenseobjrecord.desc = objRecord.licence_number

            }
           else if(i == 1)
            {
                Profobjrecord.title = "Last Name"
                Profobjrecord.desc = objRecord.lastname
                Licenseobjrecord.title = "Expiration Date"
                Licenseobjrecord.desc = objRecord.licence_exp_date

              }
          else  if(i == 2)
            {
                Profobjrecord.title = "Date Of Birth"
                Profobjrecord.desc = objRecord.birthday
                Licenseobjrecord.title = "State"
                Licenseobjrecord.desc = objRecord.state
           }
            Perdatasource.add(Profobjrecord)
            Licedatasource.add(Licenseobjrecord)
         }
        let License_objrecord:ProfileRecord = ProfileRecord()
        License_objrecord.title = "License Image"
         if(objRecord.licence_image != "")
        {
            License_objrecord.desc = objRecord.licence_image

        }
        else
        {
           License_objrecord.desc = "No Document"
         }

        let Licenseobjrecord:ProfileRecord = ProfileRecord()
        Licenseobjrecord.title = "Background Check"
        Licenseobjrecord.desc = objRecord.background_check
        Licedatasource.add(Licenseobjrecord)
        Licedatasource.add(License_objrecord)


        name_Lbl.text = objRecord.firstname
        email_Lbl.text = Themes.sharedInstance.Getemail()
//        var color:UIColor = number_Lbl.textColor!
        
        
        if(objRecord.phone_no != "")
        {
            number_Lbl.text = objRecord.phone_no
        }
        else
        {
            number_Lbl.text = "Phone number NA"
         }
        profile_img.sd_setImage(with: URL(string: objRecord.profile_pic), placeholderImage: #imageLiteral(resourceName: "avatar"))
        tableView.reloadData()

    }
    override func viewDidLayoutSubviews() {
        self.tableView.frame.size.height = self.tableView.contentSize.height
        self.scrollView.contentSize.height = self.tableView.frame.origin.y+self.tableView.contentSize.height+10
    }
    @IBAction func DidclickEdit(_ sender: Any) {
        let EditProfileVC = storyboard?.instantiateViewController(withIdentifier:"EditProfileVCID" ) as! EditProfileVC
          EditProfileVC.objRecord = objRecord
        self.navigationController?.pushViewController(EditProfileVC, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuuact(_ sender: AnyObject) {
        self.findHamburguerViewController()?.showMenuViewController()
    }
 

}

extension ProfileVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let View:UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        let HeaderLbl:UILabel = UILabel()
        HeaderLbl.frame = CGRect(x: 11, y: 0, width: UIScreen.main.bounds.size.width-11, height: 48)
        HeaderLbl.textColor = Themes.sharedInstance.returnThemeColor()
        HeaderLbl.font = UIFont(name: Constant.sharedinstance.Medium,
                                size: 17.0)
         let lineLbl:UILabel = UILabel(frame: CGRect(x: 0, y: 49, width: UIScreen.main.bounds.size.width, height: 1))
        lineLbl.backgroundColor = UIColor.darkGray
        View.addSubview(lineLbl)
        View.addSubview(HeaderLbl)
        View.backgroundColor = UIColor.white
        if(section == 0)
        {
           HeaderLbl.text = "Personal Information"
        }
       else if(section == 1)
        {
            HeaderLbl.text = "Contact Information"

        }
       else if(section == 2)
        {
            HeaderLbl.text = "Address"

        }
       else if(section == 3)
        {
            HeaderLbl.text = "License Information"

        }
         return View
     }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if(section == 0)
        {
           return Perdatasource.count
        }
        if(section == 1)
        {
            return Contactdatasource.count
        }
        if(section == 2)
        {
            return Adddatasource.count
        }
        return Licedatasource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfiletableViewCell  = tableView.dequeueReusableCell(withIdentifier: "ProfiletableViewCellID") as! ProfiletableViewCell
        cell.selectionStyle = .none
        var ProobjRecord:ProfileRecord!
        cell.desc.textColor = UIColor.black
        if(indexPath.section == 0)
        {
            ProobjRecord  = Perdatasource[indexPath.row] as! ProfileRecord

        }
            
        if(indexPath.section == 1)
        {
            ProobjRecord  = Contactdatasource[indexPath.row] as! ProfileRecord
        }
        if(indexPath.section == 2)
        {
            ProobjRecord  = Adddatasource[indexPath.row] as! ProfileRecord
        }
        else if(indexPath.section == 3)
        {
            ProobjRecord  = Licedatasource[indexPath.row] as! ProfileRecord
 
            if(indexPath.row == Licedatasource.count-2)
            {
                cell.desc.text = ProobjRecord.title
                cell.desc.textColor = UIColor.red
            }
            
         }
        cell.title.text = ProobjRecord.title
        cell.desc.text = ProobjRecord.desc
        if(cell.desc.text == "")
        {
            cell.desc.text = "not specified"
        }
        cell.licenseimg.isHidden = true
         if(ProobjRecord.title == "License Image")
        {
            if(ProobjRecord.desc != "")
            {
                cell.licenseimg.isHidden = false
                cell.licenseimg.sd_setImage(with: URL(string: ProobjRecord.desc), placeholderImage: #imageLiteral(resourceName: "licence"))
                cell.desc.text = ""
            }
            
           
        }
       
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     }
    
}
