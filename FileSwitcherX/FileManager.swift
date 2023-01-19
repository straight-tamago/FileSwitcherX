//
//  FileManager.swift
//  FileSwitcherX
//
//  Created by mini on 2023/01/10.
//

import Foundation

struct FileOperator {
    private let fileManager = FileManager.default
    private let rootDirectory = NSHomeDirectory() + "/Documents"

    init() {
        // ルートディレクトリを作成する
        createDirectory(atPath: "")
    }

    private func convertPath(_ path: String) -> String {
        if path.hasPrefix("/") {
            return rootDirectory + path
        }
        return rootDirectory + "/" + path
    }

    /// ディレクトリを作成する
    /// - Parameter path: 対象パス
    func createDirectory(atPath path: String) {
        if fileExists(atPath: path) {
            return
        }
        do {
           try fileManager.createDirectory(atPath: convertPath(path), withIntermediateDirectories: false, attributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    /// ファイルを作成する
    /// - Parameters:
    ///   - path: 保存先ファイルパス
    ///   - contents: コンテンツ
    func createFile(atPath path: String, contents: Data?) {
        // 同名ファイルがある場合は上書きされるので判定いるかも？
//        if fileExists(atPath: path) {
//            print("already exists file: \(NSString(string: path).lastPathComponent)")
//            return
//        }
        if !fileManager.createFile(atPath: convertPath(path), contents: contents, attributes: nil) {
            print("Create file error")
        }
    }

    /// ファイルがあるか確認する
    /// - Parameter path: 対象ファイルパス
    /// - Returns: ファイルがあるかどうか
    func fileExists(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: convertPath(path))
    }

    /// 対象パスがディレクトリか確認する
    /// - Parameter path: 対象パス
    /// - Returns:ディレクトリかどうか（存在しない場合もfalse）
    func isDirectory(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        fileManager.fileExists(atPath: convertPath(path), isDirectory: &isDirectory)
        return isDirectory.boolValue
    }

    /// ファイルを移動する
    /// - Parameters:
    ///   - srcPath: 移動元ファイルパス
    ///   - dstPath: 移動先ファイルパス
    func moveItem(atPath srcPath: String, toPath dstPath: String) {
        // 移動先に同名ファイルが存在する場合はエラー
        do {
           try fileManager.moveItem(atPath: convertPath(srcPath), toPath: convertPath(dstPath))
        } catch let error {
            print(error.localizedDescription)
        }
    }

    /// ファイルをコピーする
    /// - Parameters:
    ///   - srcPath: コピー元ファイルパス
    ///   - dstPath: コピー先ファイルパス
    func copyItem(atPath srcPath: String, toPath dstPath: String) {
        // コピー先に同名ファイルが存在する場合はエラー
        do {
           try fileManager.copyItem(atPath: convertPath(srcPath), toPath: convertPath(dstPath))
        } catch let error {
            print(error.localizedDescription)
        }
    }

    /// ファイルを削除する
    /// - Parameter path: 対象ファイルパス
    func removeItem(atPath path: String) {
        do {
           try fileManager.removeItem(atPath: convertPath(path))
        } catch let error {
            print(error.localizedDescription)
        }
    }

    /// ファイルをリネームする
    /// - Parameters:
    ///   - path: 対象ファイルパス
    ///   - newName: 変更後のファイル名
    func renameItem(atPath path: String, to newName: String) {
        let srcPath = path
        let dstPath = NSString(string: NSString(string: srcPath).deletingLastPathComponent).appendingPathComponent(newName)
        moveItem(atPath: srcPath, toPath: dstPath)
    }

    // ディレクトリ内のアイテムのパスを取得する
    /// - Parameter path: 対象ディレクトリパス
    /// - Returns:対象ディレクトリ内のアイテムのパス一覧
    func contentsOfDirectory(atPath path: String) -> [String] {
        do {
           return try fileManager.contentsOfDirectory(atPath: convertPath(path))
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }

    /// ディレクトリ内のアイテムのパスを再帰的に取得する
    /// - Parameter path: 対象ディレクトリパス
    /// - Returns:対象ディレクトリ内のアイテムのパス一覧
    func subpathsOfDirectory(atPath path: String) -> [String] {
        do {
           return try fileManager.subpathsOfDirectory(atPath: convertPath(path))
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }

    /// ファイル情報を取得する
    /// - Parameter path: 対象ファイルパス
    /// - Returns: 対象ファイルの情報（作成日など）
    func attributesOfItem(atPath path: String) -> [FileAttributeKey : Any] {
        do {
           return try fileManager.attributesOfItem(atPath: convertPath(path))
        } catch let error {
            print(error.localizedDescription)
            return [:]
        }
    }
}
