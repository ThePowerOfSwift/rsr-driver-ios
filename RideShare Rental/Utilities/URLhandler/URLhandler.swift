
//
//  URLhandler.swift
//  Plumbal
//
//  Created by Casperon Tech on 07/10/15.
//  Copyright © 2015 Casperon Tech. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SystemConfiguration


var Dictionary:NSDictionary!=NSDictionary()


class URLhandler: NSObject
{
    static let sharedinstance=URLhandler()
    var Dictionary:NSDictionary!=NSDictionary()
    var RetryValue:NSInteger!=3
    func isConnectedToNetwork() -> Bool {
        
        return (UIApplication.shared.delegate as! AppDelegate).IsInternetconnected
      }
    
    func makeCall(url: String,param:[String:Any], completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:NSError?  ) -> ()!)
     {
       print("the dictionary is \(param)....\(url)...\(self.Dictionary)")
       var HeaderDict:NSDictionary=NSDictionary()
        if isConnectedToNetwork() == true {
            if(Themes.sharedInstance.CheckLogin())
            {
//                HeaderDict = ["commonid":"579"/*Themes.sharedInstance.GetuserID()*/]
                HeaderDict = ["commonid":Themes.sharedInstance.GetuserID()]
             }
            print(HeaderDict)
             Alamofire.request("\(url)", method: .post, parameters: param, headers: HeaderDict as? HTTPHeaders)
                .responseJSON { response in
                    
                    if(response.result.error == nil)
                    {
                        do {
                             self.Dictionary = try JSONSerialization.jsonObject(
                                with: response.data!,
                                options: JSONSerialization.ReadingOptions.mutableContainers
                                ) as? NSDictionary
                            print("the dictionary is \(param)....\(url)...\(self.Dictionary)")

                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )

                        }
                        catch let error as NSError {
                            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                            print("A JSON parsing error occurred, here are the details:\n \(error)")
                            self.Dictionary=nil
                            completionHandler(self.Dictionary as NSDictionary?, error )
                        }

                    }
                    else
                    {
                        var i=0;
                        if(i<self.RetryValue)
                        {
                            print("the dictionary is \(param)....\(url)...\(self.Dictionary)")
                            
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                       }
                        else
                        {
                            
                            print("the dictionary is \(param)....\(url)...\(self.Dictionary)")
                            self.Dictionary=nil
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                            print("A JSON parsing error occurred, here are the details:\n \(response.result.error!)")
                        }
                        i=i+1
                        
                    }
            }
            
        }
         else {
              self.Dictionary=nil
             let userInfo: [AnyHashable : Any] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Request time out", comment: "") ,
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Request time out", comment: "")
            ]
            
            let error = NSError(domain: "Request time out", code: 401, userInfo: userInfo as! [String : Any])
             completionHandler(self.Dictionary as NSDictionary?, error as NSError? )

            
        }
    }
    func makeGetCall(url: String,param:NSDictionary, completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:NSError?  ) -> ())
    {
        if isConnectedToNetwork() == true {
            Alamofire.request("\(url)", method: .get, parameters: param as? Parameters, headers: nil)
                .responseJSON { response in
                    
                    
                    if(response.result.error == nil)
                    {
                        
                        do {
                            print("the dictionary is \(param)....\(url)...\(self.Dictionary)")
                            
                            self.Dictionary = try JSONSerialization.jsonObject(
                                with: response.data!,
                                
                                options: JSONSerialization.ReadingOptions.mutableContainers
                                
                                ) as? NSDictionary
                            
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                            
                        }
                        catch let error as NSError {
                            
                            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                            print("A JSON parsing error occurred, here are the details:\n \(error)")
                            self.Dictionary=nil
                            completionHandler(self.Dictionary as NSDictionary?, error )
                            
                        }
                        
                        
                    }
                    else
                    {
                        
                        var i=0;
                        if(i<self.RetryValue)
                        {
                            self.makeCall(url: url, param: param as! [String : String], completionHandler: { (Dictionary, nil) -> ()! in
                                return
                            })
 
                        }
                        else
                        {
                            
                            print("the dictionary is \(param)....\(url)...\(self.Dictionary)")
                            self.Dictionary=nil
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                            print("A JSON parsing error occurred, here are the details:\n \(response.result.error!)")
                        }
                        i=i+1
                        
                    }
            }
        }
        else
        {
        }
    }
    
    
    func Upload_img_File(url: String,parameters:[String:String],imageparam:[Dictionary<String,Any>], completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:NSError? ) -> ()!)
    {
        var HeaderDict:NSDictionary=NSDictionary()
        if(Themes.sharedInstance.CheckLogin())
        {
            HeaderDict = ["commonid":Themes.sharedInstance.GetuserID()]
        }
        Alamofire.upload(multipartFormData: { multipartFormData in
            var i = 0
            imageparam.forEach({ (Dict) in
                multipartFormData.append(Dict["data"] as! Data, withName: Dict["key"] as! String,fileName:Dict["name"] as! String, mimeType: "image/pdf")
                i = i+1
            })
            
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
        },
                         to:url,method:.post,headers:["commonid":Themes.sharedInstance.GetuserID()])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    if(response.result.error == nil)
                    {
                        do {
                            self.Dictionary = try JSONSerialization.jsonObject(
                                with: response.data!,
                                options: JSONSerialization.ReadingOptions.mutableContainers
                                ) as? NSDictionary
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                        }
                        catch let error as NSError {
                            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                            print("A JSON parsing error occurred, here are the details:\n \(error)")
                            self.Dictionary=nil
                            completionHandler(self.Dictionary as NSDictionary?, error )
                        }
                        print("the dictionary is \(parameters)....\(url)...\(self.Dictionary)")
                        
                    }
                    else
                    {
                        var i=0;
                        if(i<self.RetryValue)
                        {
                            print("the dictionary is \(parameters)....\(url)...\(self.Dictionary)")
                            
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                        }
                        else
                        {
                            
                            print("the dictionary is \(parameters)....\(url)...\(self.Dictionary)")
                            self.Dictionary=nil
                            completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                            print("A JSON parsing error occurred, here are the details:\n \(response.result.error!)")
                        }
                        i=i+1
                        
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }
    
    func Upload_File(url: String,parameters:[String:String],imageparam:[String:Data], completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:NSError?  ) -> ()!)
    {
        var HeaderDict:NSDictionary=NSDictionary()
        if(Themes.sharedInstance.CheckLogin())
        {
            HeaderDict = ["commonid":Themes.sharedInstance.GetuserID()]
        }
     Alamofire.upload(multipartFormData: { multipartFormData in
          for (key, value) in imageparam {
    multipartFormData.append(value, withName: key,fileName: "file.jpg", mimeType: "image/jpg")
        }
    for (key, value) in parameters {
    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
    }
    },
     to:url,method:.post,headers:["commonid":Themes.sharedInstance.GetuserID()])
    { (result) in
    switch result {
    case .success(let upload, _, _):
    
    upload.uploadProgress(closure: { (progress) in
    print("Upload Progress: \(progress.fractionCompleted)")
    })
    
    upload.responseJSON { response in
    print(response.result.value)
        if(response.result.error == nil)
        {
            do {
                self.Dictionary = try JSONSerialization.jsonObject(
                    with: response.data!,
                    options: JSONSerialization.ReadingOptions.mutableContainers
                    ) as? NSDictionary
                completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
            }
            catch let error as NSError {
                // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                print("A JSON parsing error occurred, here are the details:\n \(error)")
                self.Dictionary=nil
                completionHandler(self.Dictionary as NSDictionary?, error )
            }
            print("the dictionary is \(parameters)....\(url)...\(self.Dictionary)")
            
        }
        else
        {
            var i=0;
            if(i<self.RetryValue)
            {
                print("the dictionary is \(parameters)....\(url)...\(self.Dictionary)")
                
                completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
            }
            else
            {
                
                print("the dictionary is \(parameters)....\(url)...\(self.Dictionary)")
                self.Dictionary=nil
                completionHandler(self.Dictionary as NSDictionary?, response.result.error as NSError? )
                print("A JSON parsing error occurred, here are the details:\n \(response.result.error!)")
            }
            i=i+1
            
        }
        
    }
    
    case .failure(let encodingError):
    print(encodingError)
    }
    }

    }
    
    
    func makeGetCallString(url: String,param:NSDictionary, completionHandler: @escaping (_ responseObject: String,_ error:NSError?  ) -> ()!)
    {
        if isConnectedToNetwork() == true
        {
            Alamofire.request("\(url)", method: .get, parameters: param as? Parameters, headers: nil)
                .responseString { response in
                    
                    
                    if(response.result.error == nil)
                    {
                        
                        do {
                            print("the dictionary is \(param)....\(url)...\(self.Dictionary)")
                            
                            self.Dictionary = try JSONSerialization.jsonObject(
                                with: response.data!,
                                
                                options: JSONSerialization.ReadingOptions.mutableContainers
                                
                                ) as? NSDictionary
                            
                            completionHandler(String(describing: response.result) , response.result.error as NSError? )
                            
                        }
                        catch let error as NSError {
                            
                            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                            print("A JSON parsing error occurred, here are the details:\n \(error)")
                            self.Dictionary=nil
                            completionHandler(String(describing: response.result), error )
                            
                        }
                        
                        
                    }
                    else
                    {
                        
                        var i=0;
                        if(i<self.RetryValue)
                        {
                            self.makeCall(url: url, param: param as! [String : String], completionHandler: { (Dictionary, nil) -> ()! in
                                return
                            })
                            //                            self.makeCall(url: url, param: param, completionHandler: nil)
                            
                        }
                        else
                        {
                            
                            print("the dictionary is \(param)....\(url)...\(self.Dictionary)")
                            self.Dictionary=nil
                            completionHandler(String(describing: response.result), response.result.error as NSError? )
                            print("A JSON parsing error occurred, here are the details:\n \(response.result.error!)")
                        }
                        i=i+1
                        
                    }
            }
        }
        else
        {
        }
    }
    
    func DownloadFile(url: String,nameid:String,param:NSDictionary?,ismanual:Bool, completionHandler: @escaping (_ responseObject: DownloadResponse<Data>?,_ error:NSError?  ) -> ())
    {
        if isConnectedToNetwork() == true {

        var FolderPath:String = String()
        FolderPath = "Doc"
        let url:URL = URL(string:url)!
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("\(FolderPath)/\(nameid)-\(url.lastPathComponent)")
            return (documentsURL, [.removePreviousFile])
        }
            print(destination)
         Alamofire.download("\(url)", to: destination).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progress) in
            print("Completed Progress: \(progress.fractionCompleted)")
            print("Totaldddd Progress: \(progress.completedUnitCount)....\(url)")
            print("URL is: \(progress.localizedDescription)....\(url)")
            
                let Dict:NSDictionary = ["url":"\(url)","completed_progress":"\(progress.completedUnitCount)","total_progress":"\(progress.totalUnitCount)"]
                
             } .validate().responseData { ( response ) in
                
                if(response.error == nil)
                {
                    print(response.error)
                    completionHandler(response, response.error as NSError? )
                }
                else
                {
                    print(response.error)

                    completionHandler(response, response.error as NSError? )
                }
        }
        }
        else
        {
            
            let userInfo: [AnyHashable : Any] =
                [
                    NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Request time out", comment: "") ,
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Request time out", comment: "")
            ]
            
            let error = NSError(domain: "Request time out", code: 401, userInfo: userInfo as? [String : Any])

            completionHandler(nil, error )

        }



    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
