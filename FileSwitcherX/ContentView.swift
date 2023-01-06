//
//  ContentView.swift
//  FileSwitcherX
//
//  Created by mini on 2023/01/06.
//

import SwiftUI

struct TargetFilesPath_Struct: Identifiable {
    var id = UUID()
    let TargetFileTitle: String
    let TargetFilePath: String
    let LocationRequired: String
    let DefaultFileHeader: String
    var Disable: Bool
}

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    private let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    @State private var LogMessage = ""
    @State private var SettingsShowing = false
    @State private var Update_Alert = false
    @State private var Update_Available = false
    @State private var Notcompatiblewithios14 = false
    @State private var Respring_confirm = false

    @State var TargetFilesPath: [TargetFilesPath_Struct] = [
        TargetFilesPath_Struct(
            TargetFileTitle: "Homebar (Assets.car)",
            TargetFilePath: "/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car",
            LocationRequired: "",
            DefaultFileHeader: "BOM",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Dock Dark\n(dockDark.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Dock Light\n(dockLight.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Folder Dark\n(folderDark.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Folder Light\n(folderDark.materialrecipe)",
            TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe",
            LocationRequired: "\n[Location service required]",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Shortcut Banner\n(BannersAuthorizedBundleIDs.plist)",
            TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoard.framework/BannersAuthorizedBundleIDs.plist",
            LocationRequired: "",
            DefaultFileHeader: "bpl",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/PrivateFrameworks/SpringBoard.framework/BannersAuthorizedBundleIDs.plist")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "key_press_click.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/key_press_click.caf",
            LocationRequired: "",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/key_press_click.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "key_press_delete.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/key_press_delete.caf",
            LocationRequired: "",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/key_press_delete.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "key_press_modifier.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/key_press_modifier.caf",
            LocationRequired: "",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/key_press_modifier.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "Tock.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/Tock.caf",
            LocationRequired: "",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/Tock.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "lock.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/lock.caf",
            LocationRequired: "",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/lock.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "low_power.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/low_power.caf",
            LocationRequired: "",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/low_power.caf")
        ),
        TargetFilesPath_Struct(
            TargetFileTitle: "connect_power.caf",
            TargetFilePath: "/System/Library/Audio/UISounds/connect_power.caf",
            LocationRequired: "",
            DefaultFileHeader: "caf",
            Disable: UserDefaults.standard.bool(forKey: "/System/Library/Audio/UISounds/connect_power.caf")
        ),
    ]

    var body: some View {
        List(TargetFilesPath.indices, id: \.self) { index in
            HStack {
                Text(TargetFilesPath[index].TargetFileTitle)+Text(TargetFilesPath[index].LocationRequired).foregroundColor(.green)
                Spacer()
                Toggle(isOn: $TargetFilesPath[index].Disable) {
                    HStack {
                        Spacer()
                        Text(TargetFilesPath[index].Disable ? "To Disable" : "To Enable")
                    }
                }.onChange(of: TargetFilesPath[index].Disable) { newValue in
                    UserDefaults.standard.set(newValue, forKey: TargetFilesPath[index].TargetFilePath)
                    if newValue == true {
                        LogMessage = overwrite(TargetFilePath: TargetFilesPath[index].TargetFilePath, OverwriteData: "xxx")
                    }else{
                        LogMessage = overwrite(TargetFilePath: TargetFilesPath[index].TargetFilePath, OverwriteData: TargetFilesPath[index].DefaultFileHeader)
                    }
                    TargetFilesPath[index].id = UUID()
                }
            }
            HStack {
                HStack {
                    Spacer()
                    Text("File Status:")
                    Text(IsSucceeded(TargetFilePath: "file://"+TargetFilesPath[index].TargetFilePath) ? "OFF" : "ON").foregroundColor(IsSucceeded(TargetFilePath: "file://"+TargetFilesPath[index].TargetFilePath) ? .green : .red)
                }
            }
        }.onAppear(){
            LogMessage = "v\(version)"
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                // なぜか更新されないから無理矢理
                // 多分osが勝手にやってるから
                print("List refresh")
                TargetFilesPath[0].id = UUID()
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                print("フォアグラウンド！")
                if UserDefaults.standard.bool(forKey: "AutoRun") == true {
                    FileSwitch()
                }
            }
        }
        Text(LogMessage)
            .alert(isPresented: $Respring_confirm) {
                Alert(title: Text("Restart SpringBoard"),
                      primaryButton: .destructive(Text("Restart"),action: Respring),
                      secondaryButton: .default(Text("Cancel"))
                )
            }
        HStack {
            Button("Apply") {
                FileSwitch()
                self.Respring_confirm = true
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
            Button("Settings") {
                SettingsShowing = true
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
            .actionSheet(isPresented: $SettingsShowing) {
                ActionSheet(title: Text("FileSwitcherX v\(version)"), message: Text("by straight-tamago"), buttons: [
                    .default(Text("Source Code")) {
                        if let url = URL(string: "https://github.com/straight-tamago/FileSwitcherX") {
                            UIApplication.shared.open(url)
                        }
                    },
                    .default(Text("Dev Twitter")) {
                        if let url = URL(string: "https://mobile.twitter.com/straight_tamago") {
                            UIApplication.shared.open(url)
                        }
                    },
                    .default(Text("MacDirtyCowDemo (Exploit)")) {
                        if let url = URL(string: "https://github.com/zhuowei/MacDirtyCowDemo") {
                            UIApplication.shared.open(url)
                        }
                    },
                    .default(Text("\(NSLocalizedString("Auto run when the app starts (Status: ", comment: ""))"+String(UserDefaults.standard.bool(forKey: "AutoRun"))+")")) {
                        if #available(iOS 15.0, *) {
                            if UserDefaults.standard.bool(forKey: "AutoRun") == true {
                                UserDefaults.standard.set(false, forKey: "AutoRun")
                            }else {
                                UserDefaults.standard.set(true, forKey: "AutoRun")
                            }
                        }
                        else {
                            Notcompatiblewithios14 = true
                        }
                    },
                    .default(Text("\(NSLocalizedString("Update Check", comment: ""))")) {
                        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                        let url = URL(string: "https://api.github.com/repos/straight-tamago/FileSwitcherX/releases/latest")
                        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                            guard let data = data else { return }
                            do {
                                let object = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                                let latast_v = object["tag_name"]!
                                if version != latast_v as! String {
                                    print("update")
                                    Update_Available = true
                                    Update_Alert = true
                                }else{
                                    print("no update")
                                    Update_Available = false
                                    Update_Alert = true
                                }
                            } catch {
                                print(error)
                            }
                        }
                        task.resume()
                    },
                    .cancel()
                ])
            }
            .alert(isPresented: $Update_Alert) {
                if Update_Available == true {
                    return Alert(title: Text("Update available"),
                          message: Text("Do you want to download the update from the Github ?"),
                          primaryButton: .destructive(Text("OK"),action: {
                        if let url = URL(string: "https://github.com/straight-tamago/FileSwitcherX/releases") {
                            UIApplication.shared.open(url)
                        }
                    }),
                          secondaryButton: .default(Text("Cancel"))
                    )
                }else{
                    return Alert(title: Text("No Update"),
                          dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    func FileSwitch() -> (Void) {
        TargetFilesPath.forEach { item in
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            for i in 0..<5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(i/10)) {
                    if item.Disable == true {
                        LogMessage = overwrite(TargetFilePath: item.TargetFilePath, OverwriteData: "xxx")
                    }else {
                        LogMessage = overwrite(TargetFilePath: item.TargetFilePath, OverwriteData: item.DefaultFileHeader)
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if item.Disable == true {
                    LogMessage = overwrite(TargetFilePath: item.TargetFilePath, OverwriteData: "xxx")
                }else {
                    LogMessage = overwrite(TargetFilePath: item.TargetFilePath, OverwriteData: item.DefaultFileHeader)
                }
            }
        }
    }
}

func Respring() {
    let sharedApplication = UIApplication.shared
    let windows = sharedApplication.windows
    if let window = windows.first {
        while true {
            window.snapshotView(afterScreenUpdates: false)
        }
    }
}
