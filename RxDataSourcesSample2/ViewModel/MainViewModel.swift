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
    
    init() {
        output = self
    }
    
    var items = BehaviorRelay(value: [SectionModel(header: "Setting", image: "swift", items: [ItemData(title: "About this app")]), SectionModel(header: "iPhone in use", image: "iphone", items: [ItemData(title: "iPhone 11")])])
    
}

extension MainViewModel: MainViewModelOutput {
    var itemsObserver: Observable<[SectionModel]> {
        return items.asObservable()
    }
    
}
