//
//  SectionModel.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import Foundation
import RxDataSources

struct SectionModel: Codable {
    var header: String
    var image: String
    var items: [ItemData]
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [ItemData]) {
        self = original
        self.items = items
    }
}


