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
    let LocationRequired: String
    let DefaultFileHeader: String
    var Disable: Bool = false
    var Replace: Bool = false
    var ReplaceFilePath: String = ""
}
struct TargetFilesPath_Dict_Struct: Identifiable, Hashable {
    var id = UUID()
    var Header: String
    var TargetFilesPath_Dict: [TargetFilesPath_Struct]
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

    @State var TargetFilesPath_Dict: [TargetFilesPath_Dict_Struct] = [
        TargetFilesPath_Dict_Struct(
            Header: "SpringBoard",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "Homebar (Assets.car)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car",
                    LocationRequired: "",
                    DefaultFileHeader: "BOM"
                ),
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
                TargetFilesPath_Struct(
                    TargetFileTitle: "Switcher Blur\n(homeScreenBackdrop-application.materialrecipe)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoard.framework/homeScreenBackdrop-application.materialrecipe",
                    LocationRequired: "",
                    DefaultFileHeader: "bpl"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Shortcut Banner\n(BannersAuthorizedBundleIDs.plist)",
                    TargetFilePath: "/System/Library/PrivateFrameworks/SpringBoard.framework/BannersAuthorizedBundleIDs.plist",
                    LocationRequired: "",
                    DefaultFileHeader: "bpl"
                ),
            ]
        ),
        TargetFilesPath_Dict_Struct(
            Header: "Keyboard Sound",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "key_press_click.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/key_press_click.caf",
                    LocationRequired: "",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "key_press_delete.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/key_press_delete.caf",
                    LocationRequired: "",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "key_press_modifier.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/key_press_modifier.caf",
                    LocationRequired: "",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Tock.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Tock.caf",
                    LocationRequired: "",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "Tink.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/Tink.caf",
                    LocationRequired: "",
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
        TargetFilesPath_Dict_Struct(
            Header: "Other Sound",
            TargetFilesPath_Dict: [
                TargetFilesPath_Struct(
                    TargetFileTitle: "lock.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/lock.caf",
                    LocationRequired: "",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "low_power.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/low_power.caf",
                    LocationRequired: "",
                    DefaultFileHeader: "caf"
                ),
                TargetFilesPath_Struct(
                    TargetFileTitle: "connect_power.caf",
                    TargetFilePath: "/System/Library/Audio/UISounds/connect_power.caf",
                    LocationRequired: "",
                    DefaultFileHeader: "caf"
                )
            ]
        ),
    ]

    var body: some View {
        List {
            ForEach(TargetFilesPath_Dict.indices, id: \.self) { index in
                Section(header: Text(TargetFilesPath_Dict[index].Header)) {
                    ForEach(TargetFilesPath_Dict[index].TargetFilesPath_Dict.indices, id: \.self) { index_2 in
                        HStack {
                            Text(TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFileTitle)+Text(TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].LocationRequired).foregroundColor(.green)
                        }
                        HStack {
                            VStack {
                                HStack {
                                    Text("File Status:")
                                    Text(IsSucceeded(TargetFilePath: "file://"+TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath) ? "OFF" : "ON").foregroundColor(IsSucceeded(TargetFilePath: "file://"+TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath) ? .green : .red)
                                    Spacer()
                                    Toggle(isOn: $TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Disable) {
                                        HStack {
                                            Spacer()
                                            Text(TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Disable ? "File Disable" : "File Enable")
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
                                        UserDefaults.standard.set(newValue, forKey: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath+"_Replace")
                                        if newValue == true {
                                            Picker_index =  index
                                            Picker_index_2 = index_2
                                            showingPicker = true
                                        }else {
                                            UserDefaults.standard.set(nil, forKey: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath+"_ReplaceFilePath")
                                            TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].ReplaceFilePath = ""
                                            do {
                                                try FileManager.default.removeItem(atPath: NSHomeDirectory() + "/Documents/"+TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].ReplaceFilePath)
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                        }
                                        TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].id = UUID()
                                    }
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
            LogMessage = "v\(version)"
            Pref()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                // なぜか更新されないから無理矢理
                // 多分osが勝手にやってるから
                print("List refresh")
                TargetFilesPath_Dict[0].TargetFilesPath_Dict[0].id = UUID()
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
        TargetFilesPath_Dict.forEach { item in
            item.TargetFilesPath_Dict.forEach { item_2 in
                for i in 0..<5 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(i/10)) {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
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
    
    func Pref() -> (Void) {
        for index in TargetFilesPath_Dict.indices {
            for index_2 in TargetFilesPath_Dict[index].TargetFilesPath_Dict.indices {
                TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Disable = UserDefaults.standard.bool(forKey: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath)
                TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].Replace = UserDefaults.standard.bool(forKey: TargetFilesPath_Dict[index].TargetFilesPath_Dict[index_2].TargetFilePath+"_Replace")
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
            let fileManager = FileManager.default
            let base = "0123456789"
            let randomStr = String((0..<10).map{ _ in base.randomElement()! })
            let filePath = fileManager.urls(for: .libraryDirectory,
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
