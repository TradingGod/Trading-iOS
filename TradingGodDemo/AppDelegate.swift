//
//  AppDelegate.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/27.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let usrDef = UserDefaults.standard
        let psw = usrDef.object(forKey: "psw") as? String
//        if psw != nil {
//        let nav = BaseNavigationController.init(rootViewController: MainViewController())
//        window?.rootViewController = nav
//        }else {
//            let nav = BaseNavigationController.init(rootViewController: ViewController())
//            window?.rootViewController = nav
//        }
        
        self.window?.rootViewController = BaseTabBarController()
        window?.makeKeyAndVisible()
        
        
        TGWebSocket.sharedInstance.connectWebServiceWithURL(url:"wss://ws.okx.com:8443/ws/v5/public")
         
        var docDir:String = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
        print("docDir ==== \(String(describing: docDir))")
        //创建数据库的存储路径: 
        return true
    }
    
//    + (long long) fileSizeAtPath:(NSString*) filePath{
//        NSFileManager* manager = [NSFileManager defaultManager];
//        if ([manager fileExistsAtPath:filePath]){
//            return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
//        }
//        return 0;
//    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Trades")
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
}

