//
//  SearchBarViewController.swift
//  SCIMBO
//
//  Created by CASPERON on 27/12/16.
//  Copyright © 2016 CASPERON. All rights reserved.
//

import UIKit
protocol SearchDelegate {
    
    func didSelectLocation(countryName:String , countryCode:String)
    
    
}

class SearchBarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
   
    @IBOutlet var countryTable: UITableView!
    @IBOutlet weak var countrySearchController: UISearchBar!
    var searchArray = [String]()
    var themes = Themes()
    var  delegate:SearchDelegate!
    //MARK: - Override Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countrySearchController.backgroundImage = UIImage()
        for subView in countrySearchController.subviews {
            for secondLevelSubview in subView.subviews{
                if(secondLevelSubview.isKind(of:UITextField.self)){
                    if let searchBarTextField:UITextField = secondLevelSubview as? UITextField  {
                        searchBarTextField.becomeFirstResponder()
                        searchBarTextField.textColor = Themes.sharedInstance.returnThemeColor()
                        break;
                    }

                }

            }
        }
         countrySearchController.delegate  = self
         countryTable.reloadData()
        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        countrySearchController.barTintColor = Themes.sharedInstance.returnThemeColor()

         countrySearchController.showsCancelButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
   
    @IBAction func DidclickBack(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    
    
      @objc  func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            countryTable.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            countryTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(countrySearchController.text != ""){
            return searchArray.count
        }else{
            return themes.codename.count;
        }
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryTable.dequeueReusableCell(withIdentifier: "SearchBarTableViewCell") as! SearchBarTableViewCell
        cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        cell.textLabel?.text = ""
        cell.textLabel?.attributedText = NSAttributedString(string: "")
        
        if(countrySearchController.text != ""){
            if(indexPath.row <= searchArray.count-1)
            {
        cell.configureCellWith(searchTerm:countrySearchController.text!, cellText: searchArray[indexPath.row])
            }
            return cell
        }else{
            cell.textLabel?.text! = themes.codename[indexPath.row] as! String
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        var getCountry_Code:String = String()
        if(searchArray.count == 0){
            countrySearchController.text = themes.codename[indexPath.row] as? String
             getCountry_Code = (themes.code[indexPath.row] as? String)!
            
        }else{
            countrySearchController.text = searchArray[indexPath.row]
          getCountry_Code = themes.code[themes.codename.index(of: countrySearchController.text ?? "lafg")] as! String
            
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if  self.delegate != nil{
        
            delegate.didSelectLocation(countryName:countrySearchController.text!, countryCode: getCountry_Code)
        }
        self.navigationController?.pop(animated: true)
        
    }

    //MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        searchArray.removeAll(keepingCapacity: false)
         let NewText = (searchBar.text! as NSString).replacingCharacters(in: range, with:text)
        if(NewText != "")
        {

        print(NewText);
        let range = (NewText as String).startIndex ..< (NewText as String).endIndex
        var searchString = String()
        (NewText as String).enumerateSubstrings(in: range, options: .byComposedCharacterSequences,{ (substring, substringRange, enclosingRange, success) in
            searchString.append(substring!)
            searchString.append("*")
            
        })
        //        (NewText as String).enumerateSubstrings(range, options: .ByComposedCharacterSequences, { (substring, substringRange, enclosingRange, success) in
        //            searchString.appendContentsOf(substring!)
        //            searchString.appendContentsOf("*")
        //        })
        let searchPredicate = NSPredicate(format: "SELF LIKE[c] %@", searchString)
        let array = (themes.codename as NSArray).filtered(using: searchPredicate)
        searchArray = array as! [String]
        countryTable.reloadData()
        }
        else
        {
            countrySearchController.text = ""
            countryTable.reloadData()

        }
        return true

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.pop(animated: true)
    }
    
}
