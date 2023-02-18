//
//  TableHeaderView.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var changeEditButton: UIButton!
    
    // 初期設定
    func setup(header: String, image: String, isEdit: Bool) {
        changeEditButton.layer.cornerRadius = 15
        changeEditButton.layer.masksToBounds = true
        
        headerLabel.text = header
        headerImageView.image = UIImage(systemName: image)
        changeEditButton.isHidden = !isEdit
    }
    

}
