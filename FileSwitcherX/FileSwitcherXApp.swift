//
//  FileSwitcherXApp.swift
//  FileSwitcherX
//
//  Created by mini on 2023/01/06.
//

import SwiftUI
import CoreLocation
import UserNotifications

@main
struct FileSwitcherXApp: App {
    //AppDelegateを設定できるようにする
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!

    // アプリの起動時
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)

        return true
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        if UserDefaults.standard.bool(forKey: "Location") == true {
            locationManager = CLLocationManager()
            locationManager.requestAlwaysAuthorization()
            locationManager.showsBackgroundLocationIndicator = UserDefaults.standard.bool(forKey: "Location_Indicator")
            locationManager.distanceFilter = 1
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = true //バックグラウンド処理を可能にする
            locationManager.pausesLocationUpdatesAutomatically = false //ポーズしても位置取得を続ける
            locationManager.delegate = self
            
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }
    @objc func appMovedToForeground() {
        print("App moved to foreground!")
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("OK")
    }
}
