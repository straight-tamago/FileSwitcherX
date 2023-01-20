//
//  ContentView.swift
//  FileSwitcherX
//
//  Created by mini on 2023/01/06.
//

import SwiftUI
import UniformTypeIdentifiers
import MobileCoreServices
import CoreLocation

struct TargetFilesPath_Struct: Identifiable, Hashable {
    var id = UUID()
    let TargetFileTitle: String
    let TargetFilePath: String
    var LocationRequired: Bool = false
    let DefaultFileHeader: String
    var Disable: Bool = false
    var Replace: Bool = false
    var ReplaceFilePath: String = ""
    var OverWriteFiles_Dict: [OverWriteFiles_Struct] = []
}
struct TargetFilesPath_Dict_Struct: Identifiable, Hashable {
    var id = UUID()
    var Header: String
    var TargetFilesPath_Dict: [TargetFilesPath_Struct]
}
struct OverWriteFiles_Struct: Identifiable, Hashable {
    var id = UUID()
    var Name: String
    var Path: URL
    var Image: URL
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
    
    @State private var fileUrl: URL?
    @State private var showingPicker = false
    @State var Picker_index = 0
    @State var Picker_index_2 = 0
    
    @State var ios14 = true
    
    @State private var ReplaceModeShowing = false
    @State private var ReplaceChoose = false
    
    @State private var NewCarrierName = ""
    @State private var Reboot_Required = false
    @State private var LogMessage_CarrierName = ""
    @State private var NewBetaAlert = ""
    @State private var LogMessage_NewBetaAlert = ""

    @State var TargetFilesPath_Dict: [TargetFilesPath_Dict_Struct] = [
        TargetFilesPath_Dict_Struct(
            Header: "SpringBoard",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "Homebar (Assets.car)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car",
                    DefaultFileHeader: "BOM"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Dock (in dark mode)\n(dockDark.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe",
                    LocationRequired: true,
                    DefaultFileHeader: "bpl",
                    OverWriteFiles_Dict: [
                        OverWriteFiles_Struct(
                            Name: "Black",
                            Path:  Bundle.main.url(
                                forResource: "Dock/Black/dockDark_Black.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "Dock/Black/dock_Black.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        ),
                        OverWriteFiles_Struct(
                            Name: "White",
                            Path:  Bundle.main.url(
                                forResource: "Dock/White/dockDark_White.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "Dock/White/dock_White.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        )
                    ]
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Dock (in light mode)\n(dockLight.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe",
                    LocationRequired: true,
                    DefaultFileHeader: "bpl",
                    OverWriteFiles_Dict: [
                        OverWriteFiles_Struct(
                            Name: "Black",
                            Path:  Bundle.main.url(
                                forResource: "Dock/Black/dockLight_Black.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "Dock/Black/dock_Black.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        ),
                        OverWriteFiles_Struct(
                            Name: "White",
                            Path:  Bundle.main.url(
                                forResource: "Dock/White/dockLight_White.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "Dock/White/dock_White.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        )
                    ]
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Folder (in dark mode)\n(folderDark.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe",
                    LocationRequired: true,
                    DefaultFileHeader: "bpl",
                    OverWriteFiles_Dict: [
                        OverWriteFiles_Struct(
                            Name: "Black",
                            Path:  Bundle.main.url(
                                forResource: "Folder/Black/folderDark_Black.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "Folder/Black/folder_Black.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        ),
                        OverWriteFiles_Struct(
                            Name: "White",
                            Path:  Bundle.main.url(
                                forResource: "Folder/White/folderDark_White.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "Folder/White/folder_White.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        )
                    ]
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Folder (in light mode)\n(folderLight.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe",
                    LocationRequired: true,
                    DefaultFileHeader: "bpl",
                    OverWriteFiles_Dict: [
                        OverWriteFiles_Struct(
                            Name: "Black",
                            Path:  Bundle.main.url(
                                forResource: "Folder/Black/folderLight_Black.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "Folder/Black/folder_Black.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        ),
                        OverWriteFiles_Struct(
                            Name: "White",
                            Path:  Bundle.main.url(
                                forResource: "Folder/White/folderLight_White.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "Folder/White/folder_White.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        )
                    ]
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Folder Blur\n(folderExpandedBackgroundHome.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderExpandedBackgroundHome.materialrecipe",
                    LocationRequired: true,
                    DefaultFileHeader: "bpl",
                    OverWriteFiles_Dict: [
                        OverWriteFiles_Struct(
                            Name: "Black",
                            Path:  Bundle.main.url(
                                forResource: "folderExpandedBackgroundHome/folderExpandedBackgroundHome_Black.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "folderExpandedBackgroundHome/Black.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        ),
                        OverWriteFiles_Struct(
                            Name: "White",
                            Path:  Bundle.main.url(
                                forResource: "folderExpandedBackgroundHome/folderExpandedBackgroundHome_White.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "folderExpandedBackgroundHome/White.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        )
                    ]
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Switcher Blur\n(homeScreenBackdrop-application.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-application.materialrecipe",
                    DefaultFileHeader: "bpl",
                    OverWriteFiles_Dict: [
                        OverWriteFiles_Struct(
                            Name: "Clear",
                            Path:  Bundle.main.url(
                                forResource: "homeScreenBackdrop-switcher/homeScreenBackdrop-switcher_Clear.materialrecipe", withExtension: nil, subdirectory: "OverWriteFiles")!,
                            Image:  Bundle.main.url(
                                forResource: "homeScreenBackdrop-switcher/Clear.jpg", withExtension: nil, subdirectory: "OverWriteFiles")!
                        )
                    ]
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Shortcut Banner\n(BannersAuthorizedBundleIDs.plist)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoard.framework/BannersAuthorizedBundleIDs.plist",
                    DefaultFileHeader: "bpl"
                )
            ]
        ),
        TargetFilesPath_Dict_Struct(
            Header: "Keyboard Sound",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "key_press_click.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/key_press_click.caf",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "key_press_delete.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/key_press_delete.caf",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "key_press_modifier.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/key_press_modifier.caf",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Tock.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Tock.caf",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Tink.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Tink.caf",
                    DefaultFileHeader: "caf"
                ),
            ]
        ),
        TargetFilesPath_Dict_Struct(
            Header: "Camera Sound",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "photoShutter.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/photoShutter.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "begin_record.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/begin_record.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "end_record.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/end_record.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "camera_shutter_burst.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "camera_shutter_burst_begin.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_begin.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "camera_shutter_burst_end.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Modern/camera_shutter_burst_end.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
            ]
        ),
        TargetFilesPath_Dict_Struct(
            Header: "Other Sound",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "lock.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/lock.caf",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "low_power.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/low_power.caf",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "connect_power.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/connect_power.caf",
                    DefaultFileHeader: "caf"
                )
            ]
        ),
        TargetFilesPath_Dict_Struct(
            Header: "Dial Sound",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-0.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-0.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-1.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-1.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-2.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-2.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-3.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-3.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-4.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-4.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-5.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-5.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-6.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-6.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-7.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-7.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-8.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-8.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "dtmf-9.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-9.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "# (dtmf-pound.caf)",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-pound.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "* (dtmf-star.caf)",
                    TargetFilePath: "/System/Library/Audio/UISounds/nano/dtmf-star.caf",
                    LocationRequired: true,
                    DefaultFileHeader: "caf"
                )
            ]
        ),
    ]
    var body: some View {
        List {
            Section(header: Text("Text Editor")) {
                TextField("Carrier Name", text: $NewCarrierName)
                Button("Apply") {
                    var IsSuccess = [Bool]()
                    do {
                        LogMessage_CarrierName = "[- Run -]\n"
                        guard let files = try? FileManager.default.contentsOfDirectory(atPath: "/var/mobile/Library/Carrier Bundles/Overlay/") else {
                            LogMessage_CarrierName += "FileList Error\n"
                            return
                        }
                        for file in files {
                            LogMessage_CarrierName += "\n"+file+"\n"
                            let PlistPath = URL(fileURLWithPath: "/var/mobile/Library/Carrier Bundles/Overlay/"+file)
                            guard let PlistData = try? Data(contentsOf: URL(fileURLWithPath: PlistPath.path)) else {
                                LogMessage_CarrierName += "- "+"Read Error(Data)"+"\n"
                                IsSuccess.append(false)
                                continue
                            }
                            guard var Plist = try? PropertyListSerialization.propertyList(from: PlistData, format: nil) as? [String:Any] else {
                                LogMessage_CarrierName += "- "+"Read Error(Plist)"+"\n"
                                IsSuccess.append(false)
                                continue
                            }
                            var EditedDict = Plist as! [String: Any]
                            if EditedDict.keys.contains("StatusBarImages") == false{
                                LogMessage_CarrierName += "- "+"Skip"+"\n"
                                continue
                            }
                            EditedDict.removeValue(forKey: "MyAccountURLTitle")
                            EditedDict.removeValue(forKey: "MyAccountURL")
                            EditedDict.removeValue(forKey: "CarrierBookmarks")
                            EditedDict.removeValue(forKey: "CarrierName")
                            EditedDict.removeValue(forKey: "StockSymboli")
                            EditedDict.removeValue(forKey: "HomeBundleIdentifier")
                            
                            var StatusBarImages = EditedDict["StatusBarImages"] as! [[String: Any]]
                            for i in stride(from: 0, to: StatusBarImages.count, by: 1) {
                                var StatusBarImages_i = StatusBarImages[i] as! [String: Any]
//                                StatusBarCarrierName
                                if StatusBarImages_i.keys.contains("StatusBarCarrierName") == true{
                                    LogMessage_CarrierName += "   "+(StatusBarImages_i["StatusBarCarrierName"] as! String)
                                    LogMessage_CarrierName += " -> "
                                    StatusBarImages_i.updateValue(NewCarrierName, forKey: "StatusBarCarrierName")
                                    LogMessage_CarrierName += (StatusBarImages_i["StatusBarCarrierName"] as! String)+"\n"
                                }else{
                                    LogMessage_CarrierName += "[No StatusBarCarrierName]\n"
                                    LogMessage_CarrierName += "No Key -> "
                                    StatusBarImages_i.updateValue(NewCarrierName, forKey: "StatusBarCarrierName")
                                    LogMessage_CarrierName += (StatusBarImages_i["StatusBarCarrierName"] as! String)+"\n"
                                }
                                StatusBarImages[i] = StatusBarImages_i
                            }
                            EditedDict["StatusBarImages"] = StatusBarImages
                            
                            guard var newData = try? PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0) else { continue }
                            
                            var count = 0
                            while true {
                                newData = try! PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0)
                                if newData.count == PlistData.count {
                                    break
                                }
                                if newData.count > PlistData.count {
                                    LogMessage_CarrierName += "- "+"Size Error"+"\n"
                                    break
                                }
                                count += 1
                                EditedDict.updateValue(String(repeating:"0", count:count), forKey: "MyAccountURLTitle")
                            }
                            
                            let tmp = overwriteData(
                                TargetFilePath: PlistPath.path,
                                OverwriteFileData: newData)
                            if tmp.contains("Success") {
                                UserDefaults.standard.set(NewCarrierName, forKey: "NewCarrierName")
                                IsSuccess.append(true)
                            }else{
                                IsSuccess.append(false)
                            }
                            LogMessage_CarrierName += "- "+tmp+"\n"
                        }
                        LogMessage_CarrierName += "End..."
                        if IsSuccess.allSatisfy { $0 == true } {
                            LogMessage_CarrierName += "\n"+"- "+"Reboot Required"
                            Reboot_Required = true
                        }
                    } catch {
                        LogMessage_CarrierName += "Fatal Error..."
                    }
                }
                .onAppear {
                    NewCarrierName = UserDefaults.standard.string(forKey: "NewCarrierName") ?? ""
                }
                .alert(isPresented: $Reboot_Required) {
                    Alert(title: Text("Success. Reboot Required"),
                          message: Text("The iPhone must be manually restarted for it to apply.."),
                          primaryButton: .destructive(Text("OK")),
                          secondaryButton: .default(Text("Cancel"))
                    )
                }
                Button("FileList Test") {
                    LogMessage_CarrierName = "[- FileList Test -]\n"
                    guard let files = try? FileManager.default.contentsOfDirectory(atPath: "/var/mobile/Library/Carrier Bundles/Overlay/") else {
                        LogMessage_CarrierName += "FileList Error\n"
                        return
                    }
                    for file in files {
                        LogMessage_CarrierName += "\n"+file+"\n"
                    }
                }
                Text(LogMessage_CarrierName)
                Divider()
                    .frame(height: 1)
                    .background(Color.white)
                Text("Beta Alert (TrollStore Only) (iOS15 or newer)")
                    .disabled(ios14)
                TextField("Input", text: $NewBetaAlert)
                    .disabled(ios14)
                Button("Apply") {
                    var IsSuccess = [Bool]()
                    do {
                        LogMessage_NewBetaAlert = "[- Run -]\n"
                        guard let files = try? FileManager.default.contentsOfDirectory(atPath: "/System/Library/CoreServices/SpringBoard.app/") else {
                            LogMessage_NewBetaAlert += "FileList Error\n"
                            return
                        }
                        for file in files {
                            if file.contains(".lproj") == false{ continue }
                            LogMessage_NewBetaAlert += file+"\n"
                            let PlistPath = URL(fileURLWithPath: "/System/Library/CoreServices/SpringBoard.app/"+file+"/SpringBoard.strings")
                            let PlistData = try! Data(contentsOf: URL(fileURLWithPath: PlistPath.path))
                            guard var Plist = try? PropertyListSerialization.propertyList(from: PlistData, format: nil) as? [String:Any] else {
                                LogMessage_NewBetaAlert += "- "+"Read Error"+"\n"
                                IsSuccess.append(false)
                                continue
                            }
                            var EditedDict = Plist as! [String: Any]
                            EditedDict.updateValue(NewBetaAlert, forKey: "DEVELOPER_BUILD_EXPIRATION")
                            EditedDict.removeValue(forKey: "DISPLAY_BRIGHTNESS_DECREASE_DISCOVERABILITY")
                            EditedDict.removeValue(forKey: "DISPLAY_BRIGHTNESS_INCREASE_DISCOVERABILITY")
                            EditedDict.removeValue(forKey: "SIRI")
                            
                            guard var newData = try? PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0) else { continue }
                            
                            LogMessage_NewBetaAlert += String(newData.count)+"\n"
                            LogMessage_NewBetaAlert += String(PlistData.count)+"\n"
                            
                            var count = 0
                            while true {
                                newData = try! PropertyListSerialization.data(fromPropertyList: EditedDict, format: .binary, options: 0)
                                if newData.count == PlistData.count {
                                    break
                                }
                                if newData.count > PlistData.count {
                                    LogMessage_NewBetaAlert += "- "+"Size Error"+"\n"
                                    break
                                }
                                count += 1
                                EditedDict.updateValue(String(repeating:"0", count:count), forKey: "SIRI")
                            }
                            
                            let tmp = overwriteData(
                                TargetFilePath: PlistPath.path,
                                OverwriteFileData: newData)
                            if tmp.contains("Success") {
                                UserDefaults.standard.set(NewBetaAlert, forKey: "NewSwipeUpToUnlock")
                                IsSuccess.append(true)
                            }else{
                                IsSuccess.append(false)
                            }
                            LogMessage_NewBetaAlert += "- "+tmp+"\n"
                        }
                        LogMessage_NewBetaAlert += "End..."
                        if IsSuccess.allSatisfy { $0 == true } {
                            LogMessage_NewBetaAlert += "\n"+"- "+"Respring Required"
                            Respring_confirm = true
                        }
                    }catch {
                        LogMessage_NewBetaAlert += "Fatal Error..."
                    }
                }.disabled(ios14)
                Text(LogMessage_NewBetaAlert)
                Divider()
                    .frame(height: 1)
                    .background(Color.white)
            }
            ForEach(TargetFilesPath_Dict.indices, id: \.self) { index in
                Section(header: Text(TargetFilesPath_Dict[index].Header)) {
                    ForEach(TargetFilesPath_Dict[index].TargetFilesPath_Dict.indices, id: \.self) { index_2 in
                        HStack {
                            Text(TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFileTitle)+Text(TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].LocationRequired ? "\n[Location service required]" : "").foregroundColor(.green)
                        }
                        HStack {
                            VStack {
                                HStack {
                                    Text("File disabled?:")
                                    Text(IsSucceeded(TargetFilePath: "file://"+TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath) ? "Yes" : "No").foregroundColor(IsSucceeded(TargetFilePath: "file://"+TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath) ? .green : .red)
                                    Spacer()
                                    Toggle(isOn: $TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Disable) {
                                        HStack {
                                            Spacer()
                                            Text(TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Disable ? "To Disable" : "To Enable")
                                        }
                                    }.onChange(of: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Disable) { newValue in
                                        UserDefaults.standard.set(newValue, forKey: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath)
                                        if newValue == true {
                                            LogMessage = overwrite(TargetFilePath: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath, OverwriteData: "xxx")
                                        }else{
                                            LogMessage = overwrite(TargetFilePath: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath, OverwriteData: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].DefaultFileHeader)
                                        }
                                        TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].id = UUID()
                                    }
                                }
                                HStack {
                                    Text("Path:")
                                    Text(TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].ReplaceFilePath)
                                    Spacer()
                                    Toggle(isOn: $TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Replace) {
                                        HStack {
                                            Spacer()
                                            Text(TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Replace ? "Replace ON" : "Replace OFF")
                                        }
                                    }.onChange(of: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Replace) { newValue in
                                        if newValue == true {
                                            Picker_index =  index
                                            Picker_index_2 = index_2
                                            ReplaceModeShowing = true
                                        }else {
                                            UserDefaults.standard.set(nil, forKey: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath+"_ReplaceFilePath")
                                            TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].ReplaceFilePath = ""
//                                            do {
//                                                var fileManager = FileManager.default
//                                                var filePath = fileManager.urls(for: .libraryDirectory,
//                                                                                    in: .userDomainMask)[0].appendingPathComponent(TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].ReplaceFilePath)
//                                                try fileManager.removeItem(at: filePath)
//                                            } catch {
//                                                print(error.localizedDescription)
//                                            }
                                            TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].id = UUID()
                                        }
                                    }
                                    .actionSheet(isPresented: $ReplaceModeShowing) {
                                        ActionSheet(title: Text("Replace Mode"), message: Text(""), buttons:[
                                            .default(Text("Choose")) {
                                                print("Choose")
                                                ReplaceChoose = true
//                                                TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].Replace = false
                                            },
                                            .default(Text("Import File")) {
                                                print("Import File")
                                                showingPicker = true
                                            },
                                            .cancel() {
                                                TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].Replace = false
                                            }
                                        ])
                                    }
                                }
                                .sheet(isPresented: $ReplaceChoose) {
                                    List {
                                        ForEach(TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].OverWriteFiles_Dict.indices, id: \.self) { index_3 in
                                            Button(action: {
                                                ReplaceChoose = false
                                                LogMessage = "Copying..."
                                                var fileManager = FileManager.default
                                                let base = "0123456789"
                                                let randomStr_0 = String((0..<10).map{ _ in base.randomElement()! })
                                                var randomStr = TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].OverWriteFiles_Dict[index_3].Name+"-"+randomStr_0
                                                var filePath = fileManager.urls(for: .libraryDirectory,
                                                                                    in: .userDomainMask)[0].appendingPathComponent(randomStr)
                                                do {
                                                    LogMessage = "Copy OK..."
                                                    if fileManager.fileExists(atPath: filePath.path) {
                                                        try fileManager.removeItem(at: filePath)
                                                    }
                                                    try fileManager.copyItem(at: TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].OverWriteFiles_Dict[index_3].Path, to: filePath)
                                                } catch {
                                                    LogMessage = "Copy Error..."
                                                    print("コピー失敗")
                                                    print(error.localizedDescription)
                                //                    self.parent.LogMessage = error.localizedDescription+url.absoluteString
                                                    TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].Replace = false
                                                    return
                                                }
                                                let re1 = overwriteFile(
                                                    TargetFilePath: TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].TargetFilePath,
                                                    OverwriteFilePath: randomStr)
                                                LogMessage = re1
                                                if re1.contains("Error") {
                                                    TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].Replace = false
                                                    return
                                                }
                                                fileUrl = URL(string: randomStr)
                                                TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].ReplaceFilePath = randomStr
                                                UserDefaults.standard.set(randomStr, forKey: TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].TargetFilePath+"_ReplaceFilePath")

                                                TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].Disable = false
                                                UserDefaults.standard.set(false, forKey: TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].TargetFilePath)
                                                TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].Replace = true
                                            }) {
                                                VStack {
                                                    Image(uiImage: getImageByUrl(url: TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].OverWriteFiles_Dict[index_3].Image))
                                                        .resizable()
                                                        .scaledToFill()
                                                    Text(TargetFilesPath_Dict[Picker_index].TargetFilesPath_Dict[Picker_index_2].OverWriteFiles_Dict[index_3].Name)
                                                }
                                            }
                                        }
                                    }.listStyle(PlainListStyle())
                                }
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.white)
                            }
                        }
                    }
                }
            }.sheet(isPresented: $showingPicker) {
                DocumentPickerView(
                    fileUrl: $fileUrl,
                    TargetFilesPath_Dict: $TargetFilesPath_Dict,
                    Picker_index: $Picker_index,
                    Picker_index_2: $Picker_index_2,
                    LogMessage: $LogMessage
                )
            }
        }.listStyle(SidebarListStyle())
        .onAppear(){
            if #available(iOS 15.0, *){
                ios14 = false
            }
            LogMessage = "v\(version)"
            Pref()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                // なぜか更新されないから無理矢理
                // 多分osが勝手にやってるから
                print("List refresh")
                TargetFilesPath_Dict[0].TargetFilesPath_Dict[0].id = UUID()
            }
            Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { timer in
                FileSwitch_background()
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
                    .default(Text("\(NSLocalizedString("Run in background (Status: ", comment: ""))"+String(UserDefaults.standard.bool(forKey: "Location"))+")")) {
                        if UserDefaults.standard.bool(forKey: "Location") == true {
                            UserDefaults.standard.set(false, forKey: "Location")
                        }else {
                            UserDefaults.standard.set(true, forKey: "Location")
                            UserDefaults.standard.set(true, forKey: "Location_Indicator")
                        }
                        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                                    exit(0)
                                }

                    },
                    .default(Text("\(NSLocalizedString("Location Indicator (Status: ", comment: ""))"+String(UserDefaults.standard.bool(forKey: "Location_Indicator"))+")")) {
                        if UserDefaults.standard.bool(forKey: "Location_Indicator") == true {
                            UserDefaults.standard.set(false, forKey: "Location_Indicator")
                        }else {
                            UserDefaults.standard.set(true, forKey: "Location_Indicator")
                        }
                        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                                    exit(0)
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
        print("FileSwitch")
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        TargetFilesPath_Dict.forEach { item in
            item.TargetFilesPath_Dict.forEach { item_2 in
                if item_2.LocationRequired == true {
                    for i in 0..<5 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(i/10)) {
                            if item_2.Disable == true {
                                LogMessage = overwrite(TargetFilePath: item_2.TargetFilePath, OverwriteData: "xxx")
                            }else {
                                if item_2.Replace == true {
                                    LogMessage = overwriteFile(TargetFilePath: item_2.TargetFilePath, OverwriteFilePath: item_2.ReplaceFilePath)
                                }else {
                                    LogMessage = overwrite(TargetFilePath: item_2.TargetFilePath, OverwriteData: item_2.DefaultFileHeader)
                                }
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if item_2.Disable == true {
                            LogMessage = overwrite(TargetFilePath: item_2.TargetFilePath, OverwriteData: "xxx")
                        }else {
                            if item_2.Replace == true {
                                LogMessage = overwriteFile(TargetFilePath: item_2.TargetFilePath, OverwriteFilePath: item_2.ReplaceFilePath)
                            }else {
                                LogMessage = overwrite(TargetFilePath: item_2.TargetFilePath, OverwriteData: item_2.DefaultFileHeader)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func FileSwitch_background() -> (Void) {
        print("FileSwitch_background")
        TargetFilesPath_Dict.forEach { item in
            item.TargetFilesPath_Dict.forEach { item_2 in
                if UserDefaults.standard.bool(forKey:item_2.TargetFilePath) == true {
                    let _ = overwrite(TargetFilePath: item_2.TargetFilePath, OverwriteData: "xxx")
                }else {
                    let ReplaceFilePath = UserDefaults.standard.string(forKey: item_2.TargetFilePath+"_ReplaceFilePath") ?? ""
                    if ReplaceFilePath != "" {
                        let _ = overwriteFile(TargetFilePath: item_2.TargetFilePath, OverwriteFilePath: ReplaceFilePath)
                    }
                }
            }
        }
    }
    
    func Pref() -> (Void) {
        for index in TargetFilesPath_Dict.indices {
            for index_2 in TargetFilesPath_Dict[index].TargetFilesPath_Dict.indices {
                TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Disable = UserDefaults.standard.bool(forKey: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath)
                TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Replace = UserDefaults.standard.string(forKey: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath+"_ReplaceFilePath") != nil ? true : false
                TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].ReplaceFilePath = UserDefaults.standard.string(forKey: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath+"_ReplaceFilePath") ?? ""
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

//安定のクソコード
struct DocumentPickerView : UIViewControllerRepresentable {
    @Binding var fileUrl: URL?
    @Binding var TargetFilesPath_Dict: [TargetFilesPath_Dict_Struct]
    @Binding var Picker_index: Int
    @Binding var Picker_index_2: Int
    @Binding var LogMessage: String
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
            self.parent.LogMessage = "Copying..."
            var fileManager = FileManager.default
            var base = "0123456789"
            var randomStr = String((0..<10).map{ _ in base.randomElement()! })
            var filePath = fileManager.urls(for: .libraryDirectory,
                                                in: .userDomainMask)[0].appendingPathComponent(randomStr)
            if url.startAccessingSecurityScopedResource() {
                do {
                    self.parent.LogMessage = "Copy OK..."
                    try fileManager.copyItem(at: url, to: filePath)
                } catch {
                    self.parent.LogMessage = "Copy Error..."
                    print("コピー失敗")
                    print(error.localizedDescription)
//                    self.parent.LogMessage = error.localizedDescription+url.absoluteString
                    self.parent.TargetFilesPath_Dict[self.parent.Picker_index].TargetFilesPath_Dict[self.parent.Picker_index_2].Replace = false
                    return
                }
            }
            let re1 = overwriteFile(
                TargetFilePath: self.parent.TargetFilesPath_Dict[self.parent.Picker_index].TargetFilesPath_Dict[self.parent.Picker_index_2].TargetFilePath,
                OverwriteFilePath: randomStr)
            self.parent.LogMessage = re1
            if re1.contains("Error") {
                self.parent.TargetFilesPath_Dict[self.parent.Picker_index].TargetFilesPath_Dict[self.parent.Picker_index_2].Replace = false
                return
            }
            
            self.parent.fileUrl = URL(string: randomStr)
            self.parent.TargetFilesPath_Dict[self.parent.Picker_index].TargetFilesPath_Dict[self.parent.Picker_index_2].ReplaceFilePath = randomStr
            UserDefaults.standard.set(randomStr, forKey: self.parent.TargetFilesPath_Dict[self.parent.Picker_index].TargetFilesPath_Dict[self.parent.Picker_index_2].TargetFilePath+"_ReplaceFilePath")
            
            self.parent.TargetFilesPath_Dict[self.parent.Picker_index].TargetFilesPath_Dict[self.parent.Picker_index_2].Disable = false
            UserDefaults.standard.set(false, forKey: self.parent.TargetFilesPath_Dict[self.parent.Picker_index].TargetFilesPath_Dict[self.parent.Picker_index_2].TargetFilePath)
        }
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            self.parent.TargetFilesPath_Dict[self.parent.Picker_index].TargetFilesPath_Dict[self.parent.Picker_index_2].Replace = false
        }
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
//        let path = NSString(string: self.TargetFilesPath_Dict[self.Picker_index].TargetFilesPath_Dict[self.Picker_index_2].TargetFilePath)
//        let types = UTType.types(tag: path.pathExtension, tagClass: UTTagClass.filenameExtension, conformingTo: nil)
        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .open)
        documentPickerViewController.delegate = context.coordinator
        return documentPickerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

func getImageByUrl(url: URL) -> UIImage{
    print(url)
    do {
        let data = try Data(contentsOf: url)
        return UIImage(data: data)!
    } catch let err {
        print("Error : \(err.localizedDescription)")
    }
    return UIImage()
}
