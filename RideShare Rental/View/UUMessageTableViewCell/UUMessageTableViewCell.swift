//
//  UUMessageCell
//  ChatApp
//
//  Created by Casp iOS on 29/12/16.
//  Copyright © 2016 Casp iOS. All rights reserved.
//

import UIKit

protocol UUMessageCellDelegate: NSObjectProtocol {
    func headImageDidClick(_ cell: UUMessageCell, userId: String)
    func cellContentDidClick(_ cell: UUMessageCell, image contentImage: UIImage)
}
class UUMessageCell: UITableViewCell,UUAVAudioPlayerDelegate {
    
    
    
    var player: AVAudioPlayer!
    var voiceURL = ""
    var songData: Data!
    var audio: UUAVAudioPlayer!
    var headImageBackView: UIView!
    var contentVoiceIsPlaying = false
    
    var labelTime: UILabel!
    var labelNum: UILabel!
    var btnHeadImage: UIButton!
    var blueDot: UIImageView!
    
    var StatusMark: UIImageView!
    
    var btnContent: UUMessageContentButton!
    var messageFrame: UUMessageFrame!
    weak var delegate: UUMessageCellDelegate?
    let ChatMargin:CGFloat = 10
    let ChatIconWH:CGFloat = 0
    let ChatPicWH:CGFloat = 200
    let ChatContentW:CGFloat = 180
    let ChatTimeMarginW:CGFloat = 15
    let ChatTimeMarginH:CGFloat = 10
    let ChatContentTop:CGFloat = 15
    let ChatContentLeft:CGFloat = 50
    let  ChatContentBottom:CGFloat = 15
    let ChatContentRight:CGFloat = 15
    let ChatTimeFont:UIFont = UIFont.systemFont(ofSize: 11)
    let ChatContentFont:UIFont = UIFont.systemFont(ofSize: 14)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        // 1Created
        self.labelTime = UILabel()
        self.labelTime.textAlignment = .center
        self.labelTime.textColor = UIColor.gray
        self.labelTime.font = ChatTimeFont
        self.contentView.addSubview(self.labelTime)
        self.StatusMark = UIImageView()
        self.StatusMark.image = UIImage(named: "mic")!
        self.contentView.addSubview(self.labelTime)
        headImageBackView = UIView()
        headImageBackView.layer.masksToBounds = true
        headImageBackView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        self.btnHeadImage = UIButton(type: .custom)
        self.btnHeadImage.layer.cornerRadius = 20
        self.btnHeadImage.layer.masksToBounds = true
        self.btnHeadImage.addTarget(self, action: #selector(self.btnHeadImageClick), for: .touchUpInside)
        self.blueDot = UIImageView()
        self.blueDot.image = UIImage(named: "mic")!
        self.labelNum = UILabel()
        self.labelNum.textColor = UIColor.lightGray
        self.labelNum.backgroundColor = UIColor.clear
        self.labelNum.textAlignment = .left
        self.labelNum.font = ChatTimeFont
        self.btnContent = UUMessageContentButton(type: .custom)
        self.btnContent.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.contentView.frame.size.width - 50), height: CGFloat(60))
        self.btnContent.setTitleColor(UIColor.black, for: .normal)
        self.btnContent.titleLabel!.font = ChatContentFont
        self.btnContent.titleLabel!.numberOfLines = 0
        self.btnContent.addTarget(self, action: #selector(self.btnContentClick), for: .touchUpInside)
        
        
        self.contentView.addSubview(self.btnContent)
        self.contentView.addSubview(self.labelNum)
        self.contentView.addSubview(self.btnHeadImage)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.uuavAudioPlayerDidFinishPlay), name: NSNotification.Name(rawValue: "VoicePlayHasInterrupt"), object: nil)
        // Infrared sensor monitor
        NotificationCenter.default.addObserver(self, selector: #selector(self.sensorStateChange), name: NSNotification.Name.UIDeviceProximityStateDidChange, object: nil)
        contentVoiceIsPlaying = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func btnContentClick() {
        //play audio
        if (self.messageFrame.message.type == MessageType(rawValue: 2)!) {
            if !contentVoiceIsPlaying {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VoicePlayHasInterrupt"), object: nil)
                contentVoiceIsPlaying = true
                audio = UUAVAudioPlayer.sharedInstance()
                audio.delegate = self
                //        [audio playSongWithUrl:voiceURL];
                audio.playSong(with: songData)
            }
            else {
                self.uuavAudioPlayerDidFinishPlay()
            }
        }
        else if self.messageFrame.message.type == MessageType(rawValue: 1)! {
            if (self.btnContent.backImageView != nil) {
                UUImageAvatarBrowser.showImage(self.btnContent.backImageView)
            }
            if (self.delegate is UIViewController) {
                (self.delegate as! UIViewController).view.endEditing(true)
            }
        }
        else if self.messageFrame.message.type == MessageType(rawValue: 0)! {
            self.btnContent.becomeFirstResponder()
            let menu = UIMenuController.shared
            menu.setTargetRect(self.btnContent.frame, in: self.btnContent.superview!)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    func uuavAudioPlayerBeiginLoadVoice() {
        self.btnContent.benginLoadVoice()
    }
    func uuavAudioPlayerBeiginPlay() {
        UIDevice.current.isProximityMonitoringEnabled = true
        self.btnContent.didLoadVoice()
    }
    func uuavAudioPlayerDidFinishPlay() {
        UIDevice.current.isProximityMonitoringEnabled = false
        contentVoiceIsPlaying = false
        self.btnContent.stopPlay()
        UUAVAudioPlayer.sharedInstance().stopSound()
    }
    func makeMaskView(_ view: UIView, with image: UIImage) {
        let imageViewMask = UIImageView(image: image)
        imageViewMask.frame = view.frame.insetBy(dx: CGFloat(0.0), dy: CGFloat(0.0))
        view.layer.mask = imageViewMask.layer
    }
    @objc func sensorStateChange(_ notification: NotificationCenter) {
        if UIDevice.current.proximityState == true {
            print("Device is close to user")
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            }
            catch {
            }
        }
        else {
            print("Device is not close to user")
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
            }
        }
    }
    //   Avatar Click
    @objc func btnHeadImageClick(_ button: UIButton) {
        
    }
    func setSeenStatus(_ Status: String) {
    }
    @objc func tapProfPic(_ sender: UITapGestureRecognizer) {
        let Appdel=UIApplication.shared.delegate as! AppDelegate
        print("hello\(messageFrame.message.attachement)")
        if let window =  Appdel.window, let rootViewController = window.rootViewController {
            var currentController = rootViewController
            while let presentedController = currentController.presentedViewController {
                currentController = presentedController
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objVC:DocViewController = storyboard.instantiateViewController(withIdentifier: "DocViewControllerID") as! DocViewController
            objVC.webViewTitle = "Documents"
            objVC.isfromdoc = true
            objVC.webViewURL = messageFrame.message.attachement!
            currentController.present(objVC, animated: true, completion: nil)
        }
        
    }
    func set_MessageFrame(_ messageFrame: UUMessageFrame!) {
        self.messageFrame = messageFrame
        
        let message:UUMessage! = messageFrame.message
        self.labelTime.text = message?.strTime
        self.labelTime.frame = messageFrame.timeF
        headImageBackView.frame = messageFrame.iconF
        self.btnHeadImage.setBackgroundImageFor(.normal, with: URL(string: (message?.strIcon)!)!, placeholderImage: UIImage(named: "avatar")!)
        self.labelNum.text = "View"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapProfPic(_:)))
        labelNum.addGestureRecognizer(tapGesture)
        if(message.attachement != nil)
        {
            if(message.attachement.count == 0)
            {
                labelNum.isHidden = true
            }
            else
            {
                labelNum.isHidden = false
                
            }
        }
        else
        {
            labelNum.isHidden = true
            
        }
        
        self.labelNum.isUserInteractionEnabled = true
        //prepare for reuse
        self.btnContent.setTitle("", for: .normal)
        self.btnContent.voiceBackView.isHidden = true
        self.btnContent.backImageView.isHidden = true
        self.btnContent.frame = messageFrame.contentF
        if message?.from == MessageFrom(rawValue: 0)! {
            //syed
            self.btnContent.isMyMessage = true
            self.btnContent.setTitleColor(UIColor.white, for: .normal)
            self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft)
            self.blueDot.frame = CGRect(x: CGFloat(self.contentView.frame.size.width + 38), y: CGFloat(self.btnHeadImage.frame.size.height + 38), width: CGFloat(15), height: CGFloat(15))
            self.btnContent.setTitleColor(UIColor.black, for: .normal)
            self.btnHeadImage.frame = CGRect(x: self.btnContent.frame.origin.x+self.btnContent.frame.size.width+5, y: CGFloat(messageFrame.cellHeight-35), width: CGFloat(30.0), height: CGFloat(30))
            
        }
        else {
            self.btnContent.isMyMessage = false
            self.btnContent.setTitleColor(UIColor.black, for: .normal)
            
            //syed
            self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight)
            self.blueDot.frame = CGRect(x: CGFloat(25), y: CGFloat(self.btnHeadImage.frame.size.height + 38), width: CGFloat(15), height: CGFloat(15))
            self.btnHeadImage.frame = CGRect(x: 5, y: CGFloat(messageFrame.cellHeight-35), width: CGFloat(30.0), height: CGFloat(30))
            
            
        }
        btnHeadImage.layer.cornerRadius = btnHeadImage.frame.size.width/2
        btnHeadImage.clipsToBounds = true
        
        
        print(btnContent.frame)
        // Background bubble chart
        var normal: UIImage?
        if message?.from == MessageFrom(rawValue: 0)! {
            normal = UIImage(named: "chat")!
            normal = normal!.resizableImage(withCapInsets: UIEdgeInsetsMake(35, 15, 10, 10))
        }
        else {
            normal = UIImage(named: "recChat")!
            normal = normal!.resizableImage(withCapInsets: UIEdgeInsetsMake(35, 22, 10, 10))
        }
        
        if messageFrame.nameF.origin.x > 160 {
            self.btnContent.contentHorizontalAlignment = .left
            self.btnContent.contentVerticalAlignment = .top
            
            self.labelNum.frame = CGRect(x: CGFloat(self.btnContent.frame.origin.x + 10), y: CGFloat(btnContent.frame.size.height + btnContent.frame.origin.y - 25), width: CGFloat(100), height: CGFloat(messageFrame.nameF.size.height))
            self.labelNum.textAlignment = .left
            self.labelNum.textColor = self.tintColor
            
        }
        else {
            self.labelNum.textAlignment = .right
            self.labelNum.frame = CGRect(x: CGFloat(self.btnContent.frame.origin.x-30 ), y: CGFloat(btnContent.frame.size.height + btnContent.frame.origin.y - 25), width: CGFloat(100), height: CGFloat(messageFrame.nameF.size.height))
            self.labelNum.textColor = self.tintColor
            
            
        }
        
        
        
        self.btnContent.setBackgroundImage(normal, for: .normal)
        self.btnContent.setBackgroundImage(normal, for: .highlighted)
        switch message.type {
        case MessageType(rawValue: 0)!:
            self.btnContent.setTitle(message.strContent, for: .normal)
        case MessageType(rawValue: 1)!:
            self.btnContent.backImageView.isHidden = false
            self.btnContent.backImageView.image = message.picture
            self.btnContent.backImageView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.btnContent.frame.size.width), height: CGFloat(self.btnContent.frame.size.height))
            self.makeMaskView(btnContent.backImageView, with: normal!)
        case MessageType(rawValue: 2)!:
            self.btnContent.voiceBackView.isHidden = false
            self.btnContent.second!.text = "0.\(message.strVoiceTime)"
            //syed
            songData = message.voice
        //            voiceURL = [NSString stringWithFormat:@"%@%@",RESOURCE_URL_HOST,message.strVoice];
        default:
            break
        }
        
        
        self.btnContent.contentHorizontalAlignment = .right
        self.btnContent.contentVerticalAlignment = .top
        self.btnContent.titleLabel?.textAlignment = .left
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

