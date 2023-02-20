//
//  DataStorage.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/20.
//

import Foundation
import RxSwift
//import RxCocoa


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
    /// - Returns : onNext, onCompleted, onError
    func saveData(sectionModel: [SectionModel], key: String) -> Observable<[SectionModel]> {
        return Observable<[SectionModel]>.create { observer in
            let jsonEncoder = JSONEncoder()
            do {
                // 保存
                let data = try jsonEncoder.encode(sectionModel)
                UserDefaults.standard.set(data, forKey: key)
                // 成功
                observer.onNext(sectionModel)
                observer.onCompleted()
            } catch {
                // 失敗
                observer.onError(DBError.saveFailed)
            }
            return Disposables.create()
        }
    }
    
}
