//
//  DataStorage.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/20.
//

import Foundation
import RxSwift


enum DBError: LocalizedError {
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "保存に失敗しました。"
        }
    }
}


class DataStorage {
    
    /// UserDefaultsに保存する処理
    /// - Parameter sectionModel: 保存するオブジェクト
    /// - Parameter key: 保存先
    func saveData(sectionModel: [SectionModel], key: String) {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(sectionModel)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(DBError.saveFailed.localizedDescription)
        }
    }
    
    /// UserDefaultsから取得する処理
    /// - Parameter key: 取得先
    func getData(key: String) -> [SectionModel]? {
        var result: [SectionModel]?
        if let data = UserDefaults.standard.data(forKey: key) {
            result = try? JSONDecoder().decode([SectionModel].self, from: data)
        } else {
            return nil
        }
        return result
    }
}
