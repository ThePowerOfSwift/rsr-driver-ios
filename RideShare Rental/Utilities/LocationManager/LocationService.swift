//
//  LocationService.swift
//
//
//  Created by Anak Mirasing on 5/18/2558 BE.
//
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(_ currentLocation: CLLocation)
    func tracingLocationDidFailWithError(_ error: NSError)
    func ChangeStatus(_ Locstatus: CLAuthorizationStatus)

}
 class LocationService: NSObject, CLLocationManagerDelegate {
    static let sharedInstance: LocationService = {
        let instance = LocationService()
        return instance
    }()

    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    var Locstatus: CLAuthorizationStatus?
    var loctimer:Timer?

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        Locstatus = CLLocationManager.authorizationStatus()
         if CLLocationManager.authorizationStatus() == .notDetermined {
            Locstatus = .notDetermined
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0
        // The accuracy of the location data
         // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
//        locationManager.distanceFilter = 200
         locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
 
      }
     func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.startUpdatingLocation()
     }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }
       // singleton for get last(current) location
        currentLocation = location
         // use for real time update location
        updateLocation(location)
        if(Themes.sharedInstance.Getactive_reservation() == "Yes")
        {
            DispatchQueue.global(qos: .background).async {
                self.StartUpdatingLoc()
            }
          }
        
    }
    
  func StopUpdating()
  {
    loctimer?.invalidate()
    loctimer = nil
   }
    func StartUpdatingLoc()
    {
 
        let param:[String:String] = ["last_latitude":"\(String(describing: (self.currentLocation?.coordinate)!.latitude))","last_longitude":"\(String(describing: (self.currentLocation?.coordinate)!.longitude))"]
            URLhandler.sharedinstance.makeCall(url:Constant.sharedinstance.update_location as String, param: param, completionHandler: {(responseObject, error) ->  () in
                 if(error == nil)
                {
                    let resDict:NSDictionary = responseObject?.value(forKey: "responseArr") as! NSDictionary
                    if(resDict.count > 0)
                    {
                    }
                }
                else
                {
                 }
            })
            
 
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // do on error
        updateLocationDidFailWithError(error as NSError)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
             break
        case .authorizedWhenInUse:
            Locstatus = .authorizedWhenInUse

             break
        case .authorizedAlways:
            Locstatus = .authorizedWhenInUse
              break
        case .restricted:
            Locstatus = .restricted
             // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            Locstatus = .denied
             // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
        self.delegate?.ChangeStatus(status)
 
    }
     // Private function
    fileprivate func updateLocation(_ currentLocation: CLLocation){

        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation)
    }
    
    fileprivate func updateLocationDidFailWithError(_ error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error)
    }
}
