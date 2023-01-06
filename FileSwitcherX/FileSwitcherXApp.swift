//
//  FileSwitcherXApp.swift
//  FileSwitcherX
//
//  Created by mini on 2023/01/06.
//

import SwiftUI
import CoreLocation //CoreLocationを利用

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

// アプリの起動時に、位置情報を利用できるように設定してしまう
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{
    var locationManager : CLLocationManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestAlwaysAuthorization()


        if CLLocationManager.locationServicesEnabled(){
            locationManager!.distanceFilter = 1
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.allowsBackgroundLocationUpdates = true //バックグラウンド処理を可能にする
            locationManager!.pausesLocationUpdatesAutomatically = false //ポーズしても位置取得を続ける
            locationManager!.startUpdatingLocation()
        }

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
        )
    ]

    //位置情報に変化があった場合の処理（今回は単純に緯度と軽度を出力する）
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let newLocation = locations.last else {
            return
        }
        
        TargetFilesPath.forEach { item in
            if UserDefaults.standard.bool(forKey: item.TargetFilePath) == true {
                overwrite(TargetFilePath: item.TargetFilePath, OverwriteData: "xxx")
            }
        }
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        print("緯度: ", location.latitude, "経度: ", location.longitude)
    }
}
