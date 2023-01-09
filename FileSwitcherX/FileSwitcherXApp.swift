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


class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    var locationManager: CLLocationManager!

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        locationManager = CLLocationManager()
        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true //バックグラウンド処理を可能にする
        locationManager.pausesLocationUpdatesAutomatically = false //ポーズしても位置取得を続ける
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        return true
    }
    
    @State var TargetFilesPath: [TargetFilesPath_Struct] = [
        TargetFilesPath_Struct(
            TargetFileTitle: "Dock Dark (dockDark.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe",
            LocationRequired: "",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Dock Light (dockLight.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe",
            LocationRequired: "",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Folder Dark (folderDark.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
            LocationRequired: "",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Folder Light (folderDark.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe",
            LocationRequired: "",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Folder Blur\n(folderExpandedBackgroundHome.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderExpandedBackgroundHome.materialrecipe",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderExpandedBackgroundHome.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Switcher Blur\n(homeScreenBackdrop-application.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-application.materialrecipe",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-application.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "photoShutter.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/photoShutter.caf",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/photoShutter.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "begin_record.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/begin_record.caf",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/begin_record.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "end_record.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/end_record.caf",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/end_record.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "camera_shutter_burst.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "camera_shutter_burst_begin.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "camera_shutter_burst_end.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf")
        ),
    ]

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /* ここで位置情報を取得、保存する */
        print("Update")
        TargetFilesPath.forEach { item in
            if UserDefaults.standard.bool(forKey: item.TargetFilePath) == true {
                overwrite(TargetFilePath: item.TargetFilePath, OverwriteData: "xxx")
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func willFinishLaunchingWithOptions(_ application: UIApplication) {
        locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
}
