//
//  ChatModel.swift
//  ChatApp
//
//  Created by Casp iOS on 29/12/16.
//  Copyright © 2016 Casp iOS. All rights reserved.
//

import UIKit

class ChatModel: NSObject {
    var dataSource = [Any]()
    var isGroupChat = false
    var isReceive = false
    
    var common_group_id:String!
    var conv_id:String!
    var message:String!
    var status:String!
    var time:String!
    var type:String!
    var con_id:String!

    
 var previousTime: String? = nil
 func populateRandomDataSource() {
    self.dataSource = [Any]()
    //[self.dataSource addObjectsFromArray:[self additems:5]];
}
 func addSpecifiedItem(_ dic: [AnyHashable: Any]) {
    let messageFrame = UUMessageFrame()
    let message = UUMessage()
    var dataDic = dic
      dataDic["strName"] = ""
      if (self.isReceive == true) {
        dataDic["from"] = "1"

    }
     else if (self.isReceive == false)
     {
        dataDic["from"] = "0"

     }
    dataDic["strTime"] = Date().description
 
    print(dataDic)
    
    message.setWithDict(dataDic)
    message.minuteOffSetStart(previousTime, end: dataDic["strTime"] as! String!)
    messageFrame.showTime = message.showDateLabel
    messageFrame.message = message
    if message.showDateLabel {
        previousTime = dataDic["strTime"] as! String?
    }
     self.dataSource.append(messageFrame)
}
 
    
}
