//
//  MainViewModel.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModelInput {
    let itemDeleted: Observable<IndexPath>
    let itemMoved: Observable<ItemMovedEvent>
}

protocol MainViewModelType {
    func setup(input: MainViewModelInput)
}


class MainViewModel: MainViewModelType {
    
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
    
    /// 初期設定
    func setup(input: MainViewModelInput) {
        // セルが削除された際に発火
        input.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            // 現在のデータからindexPath番目を削除
            guard var data = self!.dataStorage.getData(key: Const.SectionModelKey) else {
                return
            }
            data[indexPath.section].items.remove(at: indexPath.row)
            // 削除後のデータを保存
            self!.dataStorage.saveData(sectionModel: data, key: Const.SectionModelKey)
        })
        .disposed(by: disposeBag)
        
        // セルが移動された際に発火
        input.itemMoved.subscribe(onNext: { [weak self] movedEvent in
            let sourceIndex = movedEvent.sourceIndex
            let destinationIndex = movedEvent.destinationIndex
            // 現在のデータを取得
            guard var data = self!.dataStorage.getData(key: Const.SectionModelKey) else {
                return
            }
            // sourceIndex番目から削除し、destinationIndex番目に挿入
            let item = data[sourceIndex.section].items[sourceIndex.row]
            data[sourceIndex.section].items.remove(at: sourceIndex.row)
            data[destinationIndex.section].items.insert(item, at: destinationIndex.row)
            // 加工後のデータを保存
            self!.dataStorage.saveData(sectionModel: data, key: Const.SectionModelKey)
        })
        .disposed(by: disposeBag)
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
