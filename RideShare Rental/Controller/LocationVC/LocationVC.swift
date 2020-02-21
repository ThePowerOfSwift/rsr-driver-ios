//
//  LocationVC.swift
//  RideShare Rental
//
//  Created by Dhiravida Mac Mini on 16/12/19.
//  Copyright © 2019 RideShare Rental. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

protocol LocationVCProtocol {
    func passingLocationData(addrLocation:String)
}


struct googleAddressData {
    var placeId: String
    var formattedAddress: String
    var addressName:String
    var secondaryAddress:String
    var latitude:Double
    var longitude:Double
    var addressIcon:String
    var stopCode:String
    var stopStatus:String
    
    var locationKey:String
}

class LocationVC: UIViewController {
    
    var delegate:LocationVCProtocol?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var locationTxtFld: UITextField!
    @IBOutlet weak var locationTableView: UITableView!
    
    let placesClient:GMSPlacesClient = GMSPlacesClient()
    let filter = GMSAutocompleteFilter()
    var userCoordinateBounds:GMSCoordinateBounds=GMSCoordinateBounds()
    var addressArray:NSMutableArray=[]
    
    let googleAutoCompeteApi = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment|geocode&location=%@,%@&radius=500&language=en&key=%@"
    var arrPlaces = NSMutableArray(capacity: 100)
    let operationQueue = OperationQueue()
    let googleServerkey = googleApiKey

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTableView()
    }
    
    func setTableView(){
        let nibName = UINib(nibName: "AddressDisplayCell", bundle:nil)
        locationTableView.register(nibName, forCellReuseIdentifier: "AddressDisplayCellSID")
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTxtFld.delegate = self
        searchBar.delegate = self
        locationTableView.tableFooterView = UIView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didClickBackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension LocationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(addressArray.count>0){
            return addressArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressDisplayCellSID", for: indexPath)
                as! AddressDisplayCell
            cell.selectionStyle = .none
        if (addressArray.count > 0){
            cell.formattedAddressLbl.text = self.addressArray[indexPath.row] as? String
        }
        
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (addressArray.count > 0){
            
            self.delegate?.passingLocationData(addrLocation: Themes.sharedInstance.CheckNullvalue(Passed_value: addressArray[indexPath.row] as? String ?? ""))
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
extension LocationVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        let typedAddrStr = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if(typedAddrStr.count>0){
//            self.beginSearching(searchText: typedAddrStr)
            self.getGoogleAddress(input: typedAddrStr)
            
        }else{
        }
        return true
    }
    
    func beginSearching(searchText:String) {
        if searchText.count == 0 {
            //self.arrPlaces.removeAllObjects()
            // self.tblOfflineCity.reloadData()
            return
        }
        
        operationQueue.addOperation { () -> Void in
            self.forwardGeoCoding(searchTexts:searchText)
        }
    }
    
    func forwardGeoCoding(searchTexts:String) {
        googlePlacesResult(input: searchTexts) { (result) -> Void in
            let searchResult:NSDictionary = ["keyword":searchTexts,"results":result]
            if result.count > 0
            {
                let features = searchResult.value(forKey: "results") as! [AnyObject]
                let addressArray:NSMutableArray=[]
                
                for dictAddress in features   {
                    if let content = dictAddress.value(forKey:"description") as? String {
//                        self.addressArray.addObjects(content)
                    }
                }
                DispatchQueue.main.async {
                    self.locationTableView.reloadData()
                }
            }
        }
    }
    
    
    func googlePlacesResult(input: String, completion: @escaping (_ result: NSArray) -> Void) {
        let searchWordProtection = input.replacingOccurrences(of: " ", with: "")
        if searchWordProtection.count != 0 {
            let urlString = NSString(format: googleAutoCompeteApi as NSString,input,LocationService.sharedInstance.currentLocation?.coordinate.latitude ?? 0,LocationService.sharedInstance.currentLocation?.coordinate.longitude ?? 0,googleServerkey)
            
            let url = NSURL(string: urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
            let defaultConfigObject = URLSessionConfiguration.default
            let delegateFreeSession = URLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: OperationQueue.main)
            let request = NSURLRequest(url: url! as URL)
            let task =  delegateFreeSession.dataTask(with: request as URLRequest,completionHandler: {
                (data, response, error) -> Void in
                if let data = data {
                    do {
                        let jSONresult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                        let results:NSArray = jSONresult["predictions"] as! NSArray
                        let status = jSONresult["status"] as! String
                        
                        if status == "NOT_FOUND" || status == "REQUEST_DENIED" {
                            let userInfo:NSDictionary = ["error": jSONresult["status"]!]
                            
                            let newError = NSError(domain: "API Error", code: 666, userInfo: userInfo as [NSObject : AnyObject] as [NSObject : AnyObject] as? [String : Any])
                            let arr:NSArray = [newError]
                            completion(arr)
                            return
                        } else {
                            completion(results)
                        }
                    }
                    catch {
                        print("json error: \(error)")
                    }
                } else if error != nil {
                    // print(error.description)
                }
            })
            task.resume()
        }
    }
    
}

extension LocationVC: UISearchBarDelegate{
    
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.location == 0 && text == " " {
            self.addressArray = NSMutableArray()
            self.locationTableView.reloadData()
            return false
        }
        
        let typedAddrStr = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        if(typedAddrStr.count>0){
            //            self.beginSearching(searchText: typedAddrStr)
            self.getGoogleAddress(input: typedAddrStr)
            
        }else{
            self.addressArray = NSMutableArray()
            self.locationTableView.reloadData()
        }
        
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func getGoogleAddress(input: String){
        
        let param:[String: Any] = ["input":input,
                                   "language":"en",
                                   "key":googleServerkey,
                                   "radius":"10000",
                                   "sensor":"true"
        ]
        
        URLhandler.sharedinstance.makeGetCall(url: "https://maps.googleapis.com/maps/api/place/autocomplete/json?", param: param as NSDictionary, completionHandler:{ (response, error) in
            
            if (error == nil){
                
                self.addressArray = NSMutableArray()
                
                if (response?["predictions"]) != nil  {
                    let prdict = response?.object(forKey: "predictions") as? [[String:Any]]
                    if((prdict?.count)! > 0)
                    {
                        for Dict in prdict!
                        {
                            self.addressArray.add(Themes.sharedInstance.CheckNullvalue(Passed_value: Dict["description"]))
                        }
                    }
                }
                if(self.addressArray.count > 0){
                    self.locationTableView.reloadData()
                }
            }else{
                self.view.makeToast("Can't find address")
            }
            
        })
        
        
    }
    
}
