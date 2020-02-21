//
//  DocumentVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 19/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import Alamofire
 
class DocumentVC: UIViewController {

    @IBOutlet var wrapperView: UIView!
    @IBOutlet var Doc_Lbl: CustomLabel!
    @IBOutlet var DownloadBtn: CustomButton!
    @IBOutlet var tableView: UITableView!
    var dataSource:NSMutableArray = NSMutableArray()
    var docArray:NSArray = NSArray()
    var bookingid:String = String()
    var isfromBookDoc:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        wrapperView.layer.cornerRadius = 3.0
        let nibName = UINib(nibName: "DoctableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "DoctableViewCellID")
        tableView.estimatedRowHeight = 32
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        ReloadData()
       
     }
    
    func ReloadData()
    {
        dataSource = NSMutableArray()
        if(docArray.count > 0)
        {
            for i in 0..<docArray.count
            {
                let Dict:NSDictionary = docArray[i] as! NSDictionary
                let actRecord:DocRecord = DocRecord()
                print(Dict)
                if(isfromBookDoc)
                {
                    actRecord.label = (Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "name")) as NSString).lastPathComponent
                    actRecord.link = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "name"))

                }
                else
                {
                    actRecord.label = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "label"))
                    actRecord.link = Themes.sharedInstance.CheckNullvalue(Passed_value: Dict.object(forKey: "link"))

                }
                let LastPath:NSString = "\(actRecord.link)" as NSString
                let path:String = "Doc/\(bookingid)-\(actRecord.label.removingandLowecasWhitespaces())-\(LastPath.lastPathComponent)"
                actRecord.DownloadPath = path

                if(Filemanager.sharedinstance.CheckDocumentexist(foldername: path))
                {
                    actRecord.isDownloaded = true

                }
                else
                {
                    actRecord.isDownloaded = false

                }
                dataSource.add(actRecord)
            }
            tableView.reloadData()
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
     }
    
    @IBAction func DidclickDownload(_ sender: Any)
    {
        let urlArray:NSMutableArray = NSMutableArray()
        for i in 0..<dataSource.count
        {
            let record:DocRecord = dataSource[i] as! DocRecord
            if(record.isSelected)
            {
                urlArray.add(record)
            }
         }
        if(urlArray.count > 0)
        {
            print(urlArray)

            self.downloadFile(urlArray: urlArray)
        }
        else
        {
            Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: "Kindly select the files to download", isSuccess: false)
        }
     }
    
    func downloadFile(urlArray:NSMutableArray)->Void{
        Themes.sharedInstance.activityView(View: self.view)
        print(urlArray)
        for i in 0..<urlArray.count
        {
            let actRecord:DocRecord = urlArray[i] as!  DocRecord
            let nameid:String = "\(bookingid)-\(actRecord.label.removingandLowecasWhitespaces())"
            
                URLhandler.sharedinstance.DownloadFile(url: actRecord.link , nameid: nameid, param: nil, ismanual: true, completionHandler: { (ResponseDict, error) in
                if(error == nil)
                {
                    let UrlStr:String =  (ResponseDict!.request?.url?.absoluteString)!
                    print(UrlStr)
                    for i in 0..<urlArray.count
                    {
                        let actRecord:DocRecord = urlArray[i] as!  DocRecord
                        if(actRecord.link == UrlStr)
                        {
                            urlArray.remove(actRecord)
                            break
                        }
                    }
                     let string:NSString = UrlStr as NSString
                    print(string)
                    if(string.pathExtension == "jpg" || string.pathExtension == "png" || string.pathExtension == "jpeg")
                    {
                        let  image:UIImage = UIImage(data: ResponseDict!.result.value!)!
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    }
                   
                    if(urlArray.count == 0)
                    {
                        self.ReloadData()
                        Themes.sharedInstance.RemoveactivityView(View: self.view)
                        Themes.sharedInstance.shownotificationBanner(Msg: "Successfully Downloaded")
                    }
                    
                }
                else
                {
                    self.ReloadData()
                    Themes.sharedInstance.showErrorpopup(Msg: "Error while downloading")
                    Themes.sharedInstance.RemoveactivityView(View: self.view)
                }
                
            })
        }
 
       }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print(error.localizedDescription)
        } else {
            print(error?.localizedDescription)
            
        }
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
    
    @IBAction func DidclickClose(_ sender: Any) {
  DismissView()
    }
 
}

extension DocumentVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DoctableViewCell  = tableView.dequeueReusableCell(withIdentifier: "DoctableViewCellID") as! DoctableViewCell
        cell.selectionStyle = .none
         let actRecord:DocRecord = dataSource[indexPath.row] as!  DocRecord
        cell.title.text = actRecord.label
        cell.selectBtn.image = actRecord.isSelected ? #imageLiteral(resourceName: "greenselect") : #imageLiteral(resourceName: "greenunselect")
        cell.view_Btn.tag = indexPath.row
        DownloadBtn.isHidden = true
        if(actRecord.isDownloaded)
        {
            cell.view_Btn.isHidden = false
            cell.selectBtn.isHidden = true
//            DownloadBtn.isHidden = false

         }
        else
        {
            cell.view_Btn.isHidden = true
            cell.selectBtn.isHidden = false
            DownloadBtn.isHidden = false

 
        }
        
        cell.view_Btn.tag = indexPath.row
        cell.view_Btn.addTarget(self, action: #selector(self.MovetoDocVC(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func MovetoDocVC(sender:UIButton)
    {
        let actRecord:DocRecord = dataSource[sender.tag] as!  DocRecord
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentsDirectoryURL.appendingPathComponent(actRecord.DownloadPath)
        let objVC:DocViewController = self.storyboard?.instantiateViewController(withIdentifier: "DocViewControllerID") as! DocViewController
        objVC.webViewTitle = "Documents"
        print(fileURL.path)
        objVC.webViewURL = fileURL.path
        self.present(objVC, animated: true, completion: nil)
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record:DocRecord = dataSource[indexPath.row] as! DocRecord
        if(!record.isDownloaded)
        {
        record.isSelected = !record.isSelected
        tableView.reloadData()
        }
    }
    
}
extension String {
    func removingandLowecasWhitespaces() -> String {
        struct Constants {
            static let validChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        }
        return String(components(separatedBy: .whitespaces).joined().lowercased().characters.filter { Constants.validChars.contains($0) })

     }
}
