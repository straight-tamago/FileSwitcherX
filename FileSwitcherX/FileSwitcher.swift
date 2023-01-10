//
//  FileSwitcher.swift
//  FileSwitcherX
//
//  Created by straight-tamago★ on 2023/01/06.
//

import UIKit
import SwiftUI

//func overwriteAsync(TargetFilePath: String, completion: @escaping (String) -> Void) {
//    DispatchQueue.global(qos: .userInteractive).async {
//        let succeeded = overwrite(TargetFilePath: TargetFilePath)
//        DispatchQueue.main.async {
//            let base = "0123456789"
//            let randomStr = String((0..<2).map{ _ in base.randomElement()! })
//            completion(succeeded ? "Success - "+randomStr : "Error")
//        }
//    }
//}

func overwrite(TargetFilePath: String, OverwriteData: String) -> String {
    let base = "0123456789"
    let randomStr = String((0..<2).map{ _ in base.randomElement()! })
    let OverwriteFileData = OverwriteData.data(using: .utf8)!
    let fd = open(TargetFilePath, O_RDONLY | O_CLOEXEC)
    defer { close(fd) }
    let Map = mmap(nil, OverwriteFileData.count, PROT_READ, MAP_SHARED, fd, 0)
    if Map == MAP_FAILED {
        print("mmap Error")
        return "mmap Error - "+randomStr
    }
    guard mlock(Map, OverwriteFileData.count) == 0 else {
        print("mlock Error")
        return "mlock Error - "+randomStr
    }
    for chunkOff in stride(from: 0, to: OverwriteFileData.count, by: 0x4000) {
        let dataChunk = OverwriteFileData[chunkOff..<min(OverwriteFileData.count, chunkOff + 0x3fff)]
        var overwroteOne = false
        for _ in 0..<2 {
            let overwriteSucceeded = dataChunk.withUnsafeBytes { dataChunkBytes in
                return unaligned_copy_switch_race(
                    fd, Int64(chunkOff), dataChunkBytes.baseAddress, dataChunkBytes.count)
            }
            if overwriteSucceeded {
                overwroteOne = true
                break
            }
            sleep(1)
        }
        guard overwroteOne else {
            print("unknown Error")
            return "unknown Error - "+randomStr
        }
    }
    print("Success")
    return "Success - "+randomStr
}


func overwriteFile(TargetFilePath: String, OverwriteFilePath: String) -> String {
    let base = "0123456789"
    let randomStr = String((0..<2).map{ _ in base.randomElement()! })
    let fileManager = FileManager.default
    let filePath =  NSHomeDirectory() + "/Documents/"+OverwriteFilePath
    guard fileManager.fileExists(atPath: filePath) else {
        print("ファイル読み込みエラー")
        return "(Error) File Not Exist - "+randomStr
    }
    print(OverwriteFilePath)
    let OverwriteFileData = try! Data(contentsOf:URL(fileURLWithPath: filePath))
    let fd = open(TargetFilePath, O_RDONLY | O_CLOEXEC)
    defer { close(fd) }

    let originalSize = lseek(fd, 0, SEEK_END)
    guard originalSize >= OverwriteFileData.count else {
      print("FileSize too big")
      return "(Error) FileSize too big - "+randomStr
    }
    lseek(fd, 0, SEEK_SET)

    let Map = mmap(nil, OverwriteFileData.count, PROT_READ, MAP_SHARED, fd, 0)
    if Map == MAP_FAILED {
        print("mmap Error")
        return "mmap Error - "+randomStr
    }
    guard mlock(Map, OverwriteFileData.count) == 0 else {
        print("mlock Error")
        return "mlock Error - "+randomStr
    }
    for chunkOff in stride(from: 0, to: OverwriteFileData.count, by: 0x4000) {
        let dataChunk = OverwriteFileData[chunkOff..<min(OverwriteFileData.count, chunkOff + 0x3fff)]
        var overwroteOne = false
        for _ in 0..<2 {
            let overwriteSucceeded = dataChunk.withUnsafeBytes { dataChunkBytes in
                return unaligned_copy_switch_race(
                    fd, Int64(chunkOff), dataChunkBytes.baseAddress, dataChunkBytes.count)
            }
            if overwriteSucceeded {
                overwroteOne = true
                break
            }
            sleep(1)
        }
        guard overwroteOne else {
            print("unknown Error")
            return "unknown Error - "+randomStr
        }
    }
    print("Success")
    return "Success - "+randomStr
}

func IsSucceeded(TargetFilePath: String) -> Bool {
    guard let data = try? Data(contentsOf: URL(string: TargetFilePath)!) else {
        return false
    }
    var databinary = data[0..<3].map { String(format: "%02X", $0)}
    var dataString = databinary.joined()
//    print(dataString)
    if dataString != "787878" {
        return false
    }
    return true
}

