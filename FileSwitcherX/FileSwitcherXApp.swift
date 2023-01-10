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
    
    @State var TargetFilesPath_Dict: [TargetFilesPath_Dict_Struct] = [
        TargetFilesPath_Dict_Struct(
            Header: "SpringBoard",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "Dock Dark\n(dockDark.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "bpl"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Dock Light\n(dockLight.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "bpl"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Folder Dark\n(folderDark.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "bpl"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Folder Light\n(folderDark.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "bpl"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Folder Blur\n(folderExpandedBackgroundHome.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderExpandedBackgroundHome.materialrecipe",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "bpl"
                ),
            ]
        ),
        TargetFilesPath_Dict_Struct(
            Header: "Camera Sound",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "photoShutter.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/photoShutter.caf",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "begin_record.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/begin_record.caf",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "end_record.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/end_record.caf",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "camera_shutter_burst.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "camera_shutter_burst_begin.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "camera_shutter_burst_end.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf",
                    LocationRequired: "\n[Location service required]",
                    DefaultFileHeader: "caf"
                ),
            ]
        ),
    ]
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /* ここで位置情報を取得、保存する */
        print("Update")
        TargetFilesPath_Dict.forEach { item in
            item.TargetFilesPath_Dict.forEach { item_2 in
                if UserDefaults.standard.bool(forKey:item_2.TargetFilePath) == true {
                    overwrite(TargetFilePath: item_2.TargetFilePath, OverwriteData: "xxx")
                }else {
                    print("sss"+item_2.ReplaceFilePath)
                    let ReplaceFilePath = UserDefaults.standard.string(forKey: item_2.TargetFilePath+"_ReplaceFilePath") ?? ""
                    if ReplaceFilePath != "" {
                        if UserDefaults.standard.bool(forKey:item_2.TargetFilePath+"_Replace") == true {
                            overwriteFile(TargetFilePath: item_2.TargetFilePath, OverwriteFilePath: ReplaceFilePath)
                        }else {
                            overwrite(TargetFilePath: item_2.TargetFilePath, OverwriteData: item_2.DefaultFileHeader)
                        }
                    }
                }
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
