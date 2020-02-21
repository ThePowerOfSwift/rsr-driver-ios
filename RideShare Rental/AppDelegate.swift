//
//  AppDelegate.swift
//  RideShare Rental
//
//  Created by MV Anand Casp iOS on 05/12/17.
//  Copyright © 2017 RideShare Rental. All rights reserved.
//

import UIKit
import CoreData
import HockeySDK
import UserNotifications
import Reachability
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import AppUpdater
import  Firebase

var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let reachability = Reachability()!
    var IsInternetconnected:Bool=Bool()
    var byreachable : String = String()
    var CurrentPageID:String = String()
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        pushnotificationSetup()
        
      //  hockeysdkSetup()
        self.ReachabilityListener()
        for fontFamilyName in UIFont.familyNames{
            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
                print("Family: \(fontFamilyName)     Font: \(fontName)")
            }
        }
        GIDSignIn.sharedInstance().clientID = "873385332039-ss2irl7hjisjfaclki52o6u6pv34itob.apps.googleusercontent.com"
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
         self.ReachabilityListener()
        CurrentPageID = ""
         if(Themes.sharedInstance.CheckLogin())
         {
            LocationService.sharedInstance.startUpdatingLocation()
            Filemanager.sharedinstance.CreateFolder(foldername: "Doc");
           Make_RootVc("DLDemoRootViewController", RootStr: "HomeVCID")
         }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            AppUpdater.showUpdateAlert(isForce: true)
        }
        
if launchOptions != nil {
        // opened from a push notification when the app is closed
    let userInfo = launchOptions![.remoteNotification] as? [AnyHashable: Any]
    if userInfo != nil {
        let Dict:NSDictionary = ((userInfo! as NSDictionary).object(forKey: "message"))! as! NSDictionary
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
//            self.PushnotificationData(Dict:Dict)
        })
    }
    }
else {
    // opened app without a push notification.
   }
   FirebaseApp.configure()
        
    // Override point for customization after application launch.
        return true
    }
 func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func hockeysdkSetup()
    {
        BITHockeyManager.shared().configure(withIdentifier: "538091431f144a16b4f1a2fe323d43b0")
        BITHockeyManager.shared().crashManager.crashManagerStatus = BITCrashManagerStatus.autoSend
        BITHockeyManager.shared().logLevel = .debug
        BITHockeyManager.shared().start()
        print("BITHockeyManager version \(BITHockeyManager.shared().version()) build \(BITHockeyManager.shared().build())")
    }
    func pushnotificationSetup()
    {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        // Enable or disable features based on authorization.
        }
        UIApplication.shared.registerForRemoteNotifications()
   }
    func ReachabilityListener()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(note:)),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    @objc func reachabilityChanged(note: NSNotification) {
       let reachability = note.object as! Reachability
             IsInternetconnected=true
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                byreachable = "1"
            } else  if reachability.connection == .cellular {
                print("Reachable via Cellular")
                byreachable = "2"
            }
          else {
            IsInternetconnected=false
            print("Network not reachable")
            byreachable = ""
        }
    }
    //Mark:- APNS Delegate
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Token: \(token)")
        Themes.sharedInstance.saveDeviceToken(DeviceToken: token)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         print("Recived: \(userInfo)")
         let Dict:NSDictionary = ((userInfo as NSDictionary).object(forKey: "message"))! as! NSDictionary
         self.PushnotificationData(Dict:Dict)
     }
    func PushnotificationData(Dict:NSDictionary)
    {
        if(CurrentPageID == "MyreservationVCID")
        {
            Themes.sharedInstance.ShowAlert(title: Themes.sharedInstance.GetAppname(), body: (Dict.object(forKey: "message"))! as! String, isSuccess: true)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ReservationStatus"), object: (Dict.object(forKey: "key"))! as! String)
        }
        else
        {
            AJAlertController.initialization().showAlert(aStrMessage: (Dict.object(forKey: "message"))! as! String,
                                                         aCancelBtnTitle: "Cancel",
                                                         aOtherBtnTitle: "Go to Reservation")
            { (index, title) in
                if(index == 1)
                {
                    self.Make_RootVc("DLDemoRootViewController", RootStr: "MyreservationVCID")
                    
                }
                
            }
        }
    }
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
         var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("i am not available in simulator \(error)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler:{
            UIApplication.shared.setMinimumBackgroundFetchInterval(1880)
        })
        print(UIApplication.shared.backgroundTimeRemaining)
        
        assert(backgroundTask != UIBackgroundTaskInvalid)
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
        }

    }
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.endBackgroundTask()

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            AppUpdater.showUpdateAlert(isForce: true)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RideShare_Rental")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func MakeRootVc(_ ViewIdStr:NSString){
        let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootView: UINavigationController = sb.instantiateViewController(withIdentifier: "Rootnav") as! UINavigationController
        let signinVC = sb.instantiateViewController(withIdentifier: ViewIdStr as String) 
        rootView.viewControllers = [signinVC]
        self.window!.rootViewController=rootView
        self.window!.makeKeyAndVisible()
    }
    
     func Make_RootVc(_ ViewIdStr:NSString,RootStr:NSString){
        CurrentPageID = RootStr as String
        let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootView: UIViewController = sb.instantiateViewController(withIdentifier: ViewIdStr as String)
        self.window!.rootViewController=rootView
        NotificationCenter.default.post(name: Notification.Name(rawValue: "MakerootView"), object: RootStr)
        Filemanager.sharedinstance.CreateFolder(foldername: "Doc");
        
    }

}

