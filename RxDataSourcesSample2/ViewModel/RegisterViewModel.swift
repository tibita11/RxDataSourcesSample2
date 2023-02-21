//
//  RegisterViewModel.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/21.
//

import Foundation
import RxSwift
import RxOptional

struct RegisterViewModelInput {
    let addButton: Observable<String>
}

protocol RegisterViewModelType {
    func setup(input: RegisterViewModelInput, model: DataStorage)
}



class RegisterViewModel: RegisterViewModelType {
    
    let disposeBag = DisposeBag()
    
    func setup(input: RegisterViewModelInput, model: DataStorage) {
        input.addButton
            .subscribe(onNext: { text in
                guard var result = model.getData(key: Const.SectionModelKey) else {
                    return
                }
                // 新規データを追加
                result[1].items.append(ItemData(title: text))
                model.saveData(sectionModel: result, key: Const.SectionModelKey)
            })
            .disposed(by: disposeBag)
        
    }
    
    
}
