//
//  MainViewModel.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import Foundation
import RxSwift
import RxCocoa


class MainViewModel {
    
    var dataStorage: DataStorage!

    let disposeBag = DisposeBag()
    /// dataStoregaからデータを取得した際に格納する
    var currentData: Observable<[SectionModel]>?
    /// データを取得又は更新した際に通知を送る
    var items: Observable<[SectionModel]> {
        let updateData = UserDefaults.standard.rx.observe(Data.self, Const.SectionModelKey)
            .map { $0.flatMap { try? JSONDecoder().decode([SectionModel].self, from: $0) } }
            .filterNil()
        
        let currentData = currentData ?? .empty()
        return Observable.merge(updateData, currentData)
    }
    
    init() {
        dataStorage = DataStorage()
    }
    
    /// 初期データを設定
    func setupInitialData() {
        // 初期データ
        let sectionModel = [SectionModel(header: "Setting", image: "swift", items: [ItemData(title: "About this app")]), SectionModel(header: "iPhone in use", image: "iphone", items: [])]
        // 保存処理
        dataStorage.saveData(sectionModel: sectionModel, key: Const.SectionModelKey)
    }
    
    /// ModelのData取得処理を実行する
    func getData() {
        guard let result = dataStorage.getData(key: Const.SectionModelKey) else {
            return
        }
        
        currentData = Observable<[SectionModel]>.create { observer in
            observer.onNext(result)
            observer.onCompleted()
            return Disposables.create()
        }

    }
    
}
