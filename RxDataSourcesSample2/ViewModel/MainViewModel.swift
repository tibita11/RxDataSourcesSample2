//
//  MainViewModel.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelOutput {
    var itemsObserver: Observable<[SectionModel]> { get }
}

protocol MainViewModelType {
    var output: MainViewModelOutput? { get }
}

class MainViewModel: MainViewModelType {
    var output: MainViewModelOutput?
    
    var dataStorage: DataStorage!

    let disposeBag = DisposeBag()
    
    init() {
        output = self
        dataStorage = DataStorage()
    }
    
    var items = BehaviorRelay<[SectionModel]>(value: [])
    
    /// テスト用に初期データを設定
    func setupInitialData() {
        // 初期データ
        let sectionModel = [SectionModel(header: "Setting", image: "swift", items: [ItemData(title: "About this app")]), SectionModel(header: "iPhone in use", image: "iphone", items: [ItemData(title: "iPhone 11")])]
        
        // 保存処理
        dataStorage.saveData(sectionModel: sectionModel, key: Const.SectionModelKey)
            .materialize()
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next:
                    // 正常に登録できた場合
                    self!.items.accept(event.element!)
                case let .error(error as DBError):
                    // エラー内容表示
                    print(error.localizedDescription)
                case .error:
                    // エラー内容表示
                    print("エラー")
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
}


// MARK: - MainViewModelOutput

extension MainViewModel: MainViewModelOutput {
    var itemsObserver: Observable<[SectionModel]> {
        return items.asObservable()
    }
    
}
