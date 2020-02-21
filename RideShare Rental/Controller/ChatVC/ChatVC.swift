//
//  ChatVC.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 15/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

import PKCCrop

class ChatVC:UIViewController,UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDelegate,UITableViewDataSource
    
    
{
    var picker = UIImagePickerController()
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var attachementLbl: CustomLabel!
    @IBOutlet var attachmentView: CustomView!
    var iswithowner:Bool = Bool()
    var iswithadmin:Bool = Bool()
    var iswithdirectowner:Bool = Bool()
    var iswithdirectadmin:Bool = Bool()
    
    var dataSource:NSMutableArray=NSMutableArray()
    var chatModel:ChatModel=ChatModel()
    var IFView:UUInputFunctionView=UUInputFunctionView();
    
    var attachment:String = ""
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var username: CustomLabel!
    
    var imageData:Data?
    
    
    var ActualtableHeight:CGFloat!
    let refreshControl = UIRefreshControl()
    var dataSourceArr:NSMutableArray = NSMutableArray()
    var bookingNo:String = String()
    
    var user_name:String = String()
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 50),type: .ballPulse)
    
    var isattachementadded:Bool = Bool()
    var isimageadded:Bool = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActualtableHeight = chatTableView.frame.size.height
        addRefreshViews();
        loadBaseViewsAndData();
        chatTableView.backgroundColor=UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        // Do any additional setup after loading the view.
        let dict:[String:String] = ["booking_no":bookingNo]
        self.Chatdata(Param: dict)
        username.text = user_name
        
        chatTableView.frame.size.height = ActualtableHeight-60
        picker.delegate = self
        attachmentView.isHidden = true
        
        
        
        
    }
    
    @IBAction func didclickCloseattachement(_ sender: Any) {
        isattachementadded = false
        isimageadded = false
        imageData = nil
        attachmentView.isHidden = true
    }
    
    @IBAction func Didclickuploadimg(_ sender: Any) {
        openPicker()
    }
    func openPicker()
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let FileAction = UIAlertAction(title: "Files", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.PresentDocumentPicker()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(FileAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
        }
    }
    func PresentDocumentPicker() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [ "public.data","public.pdf","public.doc"], in: .import)
        importMenu.delegate = self
        present(importMenu, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }
    }
    
    func openGallery()
    {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func sendmessage(Param:[String:String])
    {
        self.ShowSpinner()
        
        
        
        
        var url = ""
        if(iswithowner)
        {
            url =  Constant.sharedinstance.send_message as String
        }
        if(iswithadmin)
        {
            url =  Constant.sharedinstance.send_admin_message as String
            
        }
        if(iswithdirectowner)
        {
            url =  Constant.sharedinstance.send_direct_message as String
            
        }
        if(iswithdirectadmin)
        {
            url =  Constant.sharedinstance.send_direct_admin_message as String
            
        }
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
                        Themes.sharedInstance.shownotificationBanner(Msg: "Message Sent")
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
    
    func Chatdata(Param:[String:String])
    {
        chatTableView.isHidden = true
        Themes.sharedInstance.activityView(View: self.view)
        
        
        
        
        var url = ""
        if(iswithowner)
        {
            url =  Constant.sharedinstance.message as String
        }
        if(iswithadmin)
        {
            url =  Constant.sharedinstance.admin_message as String
            
        }
        if(iswithdirectowner)
        {
            url =  Constant.sharedinstance.direct_message as String
            
        }
        if(iswithdirectadmin)
        {
            url =  Constant.sharedinstance.direct_admin_message as String
            
        }
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
        activityIndicatorView.center=CGPoint(x:UIScreen.main.bounds.size.width/2,y:  chatTableView.frame.origin.y+70);
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
        var active_Array:NSArray = responseDict?.object(forKey: "messages") as!  NSArray
        if(active_Array.count > 0)
        {
            active_Array = active_Array.reversed() as NSArray
            for i in 0..<active_Array.count
            {
                let dict:NSDictionary = active_Array[i] as! NSDictionary
                let senderId:String = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "senderId"))
                var pic:String = ""
                if(senderId != Themes.sharedInstance.GetuserID())
                {
                    self.chatModel.isReceive = true
                    pic = Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey:"sender_pic"))
                }
                else
                {
                    self.chatModel.isReceive = false
                    pic = Themes.sharedInstance.Getprofile_pic()
                    
                }
                let dic:[AnyHashable: Any] = ["strContent":  Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "message")), "type": 0,"strIcon":pic,"attachment":Themes.sharedInstance.CheckNullvalue(Passed_value: dict.object(forKey: "attachment"))]
                
                self.dealTheFunctionData(dic)
            }
            chatTableView.isHidden = false
            chatTableView.reloadData()
        }
        else
        {
            chatTableView.isHidden = true
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChange), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChange), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.tableViewScrollToBottom), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveMessage), name: NSNotification.Name(rawValue: "ReceiveMessage"), object: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    //tableView Scroll to bottom
    @objc  func tableViewScrollToBottom() {
        if self.chatModel.dataSource.count == 0 {
            return
        }
        
        let indexPath = IndexPath(row: self.chatModel.dataSource.count - 1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    @objc func receiveMessage(_ notify: Notification) {
        if (notify.object! is String) {
            let dic = ["strContent": notify.object!, "type": 0]
            self.chatModel.isReceive = true
            IFView.changeSendBtn(withPhoto: true)
            self.dealTheFunctionData(dic)
        }
    }
    func addRefreshViews() {
        
        //load more
        
        //    self.head = MJRefreshHeaderView.header()
        //    self.head.scrollView = self.chatTableView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            self.chatTableView.refreshControl = refreshControl
        } else {
            self.chatTableView.backgroundView = refreshControl
        }
        //    chatTableView.tableFooterView=UIView();
        chatTableView.separatorColor=UIColor.clear
        
    }
    
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        weak var weakSelf = self
        let pageNum = 3
        if (weakSelf?.chatModel.dataSource.count)! > pageNum {
            let indexPath = IndexPath(row: pageNum, section: 0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
                weakSelf?.chatTableView.reloadData()
                weakSelf?.chatTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            })
            
            
        }
        
        refreshControl.endRefreshing()
        
        // Do your job, when done:
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0;
    }
    @objc  func keyboardChange(_ notification: Notification) {
        var userInfo = notification.userInfo!
        let animationCurve: UIViewAnimationCurve=UIViewAnimationCurve(rawValue: Int(userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber))!
        
        let animationDuration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        //adjust ChatTableView's height
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
            chatTableView.frame.size.height = ActualtableHeight - ( keyboardEndFrame.size.height + 60)
        }
        else {
            chatTableView.frame.size.height = ActualtableHeight-60
        }
        self.view.layoutIfNeeded()
        //adjust UUInputFunctionView's originPoint
        var newFrame = IFView.frame
        newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height
        IFView.frame = newFrame
        UIView.commitAnimations()
    }
    
    func loadBaseViewsAndData() {
        self.chatModel = ChatModel()
        self.chatModel.isGroupChat = false
        self.chatModel.populateRandomDataSource()
        IFView = UUInputFunctionView(superVC: self)
        IFView.delegate = self
        IFView.btnCamera.isHidden = true
        if(iswithadmin)
        {
            IFView.btnCamera.isHidden = false
            
        }
        
        if(iswithdirectadmin)
        {
            IFView.btnCamera.isHidden = false
            
        }
        IFView.btnCamera.addTarget(self, action: #selector(self.Didclickuploadimg(_:)), for: .touchUpInside)
        self.view.addSubview(IFView)
        self.chatTableView.reloadData()
        self.tableViewScrollToBottom()
    }
    
    
    func uuInputFunctionView(_ funcView: UUInputFunctionView, sendMessage message: String) {
        if(isattachementadded)
        {
            let dict:[String:String] = ["booking_no":bookingNo,"message":message]
            self.sendmessagewithattchement(Param: dict, message: message)
            funcView.textViewInput.text = ""
            funcView.changeSendBtn(withPhoto: true)
            
            
        }
        else
        {
            let dic:[AnyHashable: Any] = ["strContent": message, "type": 0,"strIcon":Themes.sharedInstance.Getprofile_pic(),"attachment":""]
            funcView.textViewInput.text = ""
            self.chatModel.isReceive = false
            funcView.changeSendBtn(withPhoto: true)
            let sticks:String = String(Int(Date().timeIntervalSince1970))
            self.dealTheFunctionData(dic)
            
            let dict:[String:String] = ["booking_no":bookingNo,"message":message]
            self.sendmessage(Param: dict)
            
        }
    }
    
    
    func sendmessagewithattchement(Param:[String:String],message:String)
    {
        self.ShowSpinner()
        
        var url = ""
        if(iswithowner)
        {
            url =  Constant.sharedinstance.send_message as String
        }
        if(iswithadmin)
        {
            url =  Constant.sharedinstance.send_admin_message as String
            
        }
        if(iswithdirectowner)
        {
            url =  Constant.sharedinstance.send_direct_message as String
            
        }
        if(iswithdirectadmin)
        {
            url =  Constant.sharedinstance.send_direct_admin_message as String
            
        }
        
        URLhandler.sharedinstance.Upload_img_File(url: url, parameters: Param, imageparam: [["data":imageData!,"name":attachementLbl.text!,"key":"attachment"]], completionHandler:  {(responseObject, error) ->  () in
            self.StopSPinner()
            self.isattachementadded = false
            self.isimageadded = false
            self.imageData = nil
            self.attachmentView.isHidden = true
             if(error == nil)
            {
                let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                if(resDict.count > 0)
                {
                    let status:String = Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "status"))
                    if(status == "1")
                    {
                        
                        let dic:[AnyHashable: Any] = ["strContent": message, "type": 0,"strIcon":Themes.sharedInstance.Getprofile_pic(),"attachment":Themes.sharedInstance.CheckNullvalue(Passed_value: resDict.value(forKey: "attachment"))]
                        self.chatModel.isReceive = false
                        let sticks:String = String(Int(Date().timeIntervalSince1970))
                        self.dealTheFunctionData(dic)
                        Themes.sharedInstance.shownotificationBanner(Msg: "Message Sent")
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
    func uuInputFunctionView(_ funcView: UUInputFunctionView, sendPicture image: UIImage) {
        let dic:[AnyHashable: Any] = ["picture": image, "type": 1]
        self.dealTheFunctionData(dic)
    }
    func uuInputFunctionView(_ funcView: UUInputFunctionView, sendVoice voice: Data, time second: Int) {
        let dic:[AnyHashable: Any] = ["voice": voice, "strVoiceTime": "\(Int(second))", "type": 2]
        self.dealTheFunctionData(dic)
    }
    func dealTheFunctionData(_ dic: [AnyHashable: Any]) {
        self.chatModel.addSpecifiedItem(dic)
        self.chatTableView.reloadData()
        self.tableViewScrollToBottom()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatModel.dataSource.count
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UUMessageCell? = tableView.dequeueReusableCell(withIdentifier: "CellID") as! UUMessageCell!
        if cell == nil {
            cell = UUMessageCell(style: .default, reuseIdentifier: "CellID")
            cell?.delegate=self
        }
        cell?.set_MessageFrame(self.chatModel.dataSource[indexPath.row] as! UUMessageFrame)
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.chatModel.dataSource[indexPath.row] as AnyObject).cellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    func headImageDidClick(_ cell: UUMessageCell, userId: String)
    {        // headIamgeIcon is clicked
        let alert = UIAlertView(title: cell.messageFrame.message.strName, message: "headImage clicked", delegate: nil, cancelButtonTitle: "sure", otherButtonTitles: "")
        alert.show()
    }
    func cellContentDidClick(_ cell: UUMessageCell, image contentImage: UIImage)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Didclick_Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
extension ChatVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker.dismiss(animated: true) {
            let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            
            self.ShowCropVC(image: image)
        }
    }
    func ShowCropVC(image:UIImage)
    {
        PKCCropHelper.shared.degressBeforeImage = UIImage(named: "pkc_crop_rotate_left")
        PKCCropHelper.shared.degressAfterImage = UIImage(named: "pkc_crop_rotate_right")
        PKCCropHelper.shared.isNavigationBarShow = false
        let cropVC = PKCCrop().cropViewController(image)
        cropVC.delegate = self
        self.present(cropVC, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension ChatVC: PKCCropDelegate{
    //return Crop Image & Original Image
    func pkcCropImage(_ image: UIImage?, originalImage: UIImage?) {
        self.dismiss(animated: true, completion: nil)
        imageData = nil
        imageData = UIImageJPEGRepresentation(image!, 0.7)
        let timestamp:String = "\(Date().ticks)"
        self.attachementLbl.text = "\(timestamp).jpg"
        attachmentView.isHidden = false
        isattachementadded = true
        isimageadded = true
        IFView.textViewInput.becomeFirstResponder()
    }
    //If crop is canceled
    func pkcCropCancel(_ viewController: PKCCropViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    //Successful crop
    func pkcCropComplete(_ viewController: PKCCropViewController) {
        if viewController.tag == 0{
            viewController.navigationController?.popViewController(animated: true)
        }else{
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
extension ChatVC:UIDocumentMenuDelegate, UIDocumentPickerDelegate
{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let cico = url as URL
        print("The Url is : \(cico)")
        let Pathextension:String = "\(cico.pathExtension)"
        do
        {
            var Doc_data:NSData = try NSData(contentsOf: cico)
            imageData = Doc_data as Data
            attachementLbl.text = cico.lastPathComponent.lowercased()
            attachmentView.isHidden = false
            isattachementadded = true
            isimageadded = false
            IFView.textViewInput.becomeFirstResponder()
            
            
        }
        catch
        {
        }
        
    }
    
    @available(iOS 8.0, *)
    
    public func documentMenu(_ documentMenu:     UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController)  {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print("we cancelled")
        dismiss(animated: true, completion: nil)
    }
}

extension UINavigationController {
    override open var shouldAutorotate: Bool {
        return false
    }
}


