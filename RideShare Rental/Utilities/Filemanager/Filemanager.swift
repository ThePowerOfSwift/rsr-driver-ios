//
//  Filemanager.swift
//  SCIMBO
//
//  Created by MV Anand Casp iOS on 18/05/17.
//  Copyright © 2017 CASPERON. All rights reserved.
//

import UIKit

class Filemanager: NSObject {
    static let sharedinstance=Filemanager()

    func CreateFolder(foldername:String)
    {
        
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let dataPath = documentsDirectory.appendingPathComponent("\(foldername)")
        if(!CheckDocumentexist(foldername: foldername))
        {
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
        }
        

    }
    
    func CheckDocumentexist(foldername:String)->Bool
    {
        
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                                       create: true)
       let databaseURL = documentDirectoryURL.appendingPathComponent("\(foldername)")
        print(databaseURL)
         var fileExists:Bool = Bool()
        
        do {
            fileExists = try databaseURL.checkResourceIsReachable()
            // handle the boolean result
        } catch let error as NSError {
            print(error)
        }
        return fileExists
     }
    
    func SaveImageFile(imagePath:String,imagedata:Data)->String
    {
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create a name for your image
        let fileURL = documentsDirectoryURL.appendingPathComponent(imagePath)
         var Filepath:String = ""
         if !FileManager.default.fileExists(atPath: fileURL.path) {
            do
            {
                
            try  imagedata.write(to: fileURL)
                print("file saved \(fileURL.path)")
                if FileManager.default.fileExists(atPath: fileURL.path)
                {
                     print("file saved \(imagePath)")
                }
                Filepath = imagePath;
             }
             catch
            {
            print("error saving file \(error.localizedDescription)")
            }
          
        } else {
            print("file already exists")
            return imagePath;

        }
        
        return Filepath;

    }
    
    func retrieveallFiles(directoryname:String)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        
        var documentDirectory:String = paths[0]
        
        documentDirectory = documentDirectory.appending("/\(directoryname)/");
        
        
        let manager = FileManager.default
        do {
        let allItems = try manager.contentsOfDirectory(atPath: documentDirectory)
            
            for i in 0..<allItems.count
            {
                print(documentDirectory.appending(allItems[i] as String))
                
//    let image    = UIImage(contentsOfFile: documentDirectory.appending(allItems[i] as String))
             }
            
 // for var path: String in allItems.filter({ predicate.evaluate(with: $0) }) {
//    
//    print(path)
//    
//    
//
//     // Enumerate each .png file in directory
//}

        } catch  {
            
            print(error.localizedDescription)
            
        }
      
    }
    func DeleteFile(foldername:String)
    {
        if(CheckDocumentexist(foldername: foldername))
        {
            let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory,
                                                                    in: .userDomainMask,
                                                                    appropriateFor: nil,
                                                                    create: true)
             let databaseURL = documentDirectoryURL.appendingPathComponent("\(foldername)")
            
     do
     {
         try FileManager.default.removeItem(at: databaseURL)
            
             }
     catch {
        print("the error is \(error.localizedDescription)")
            }
        
        }
    }

}

