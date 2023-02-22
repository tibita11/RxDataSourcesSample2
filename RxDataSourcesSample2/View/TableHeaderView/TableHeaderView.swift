//
//  TableHeaderView.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import UIKit

protocol TableHeaderViewDelegate {
    func isEditingChange(editButton: UIButton)
}

enum EditButtonTitle: String {
    case done = "Done"
    case edit = "Sort・Delete"
}

class TableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var changeEditButton: UIButton!
    
    var delegate: TableHeaderViewDelegate?
    
    /// 初期設定
    /// - Parameter header: セクションに表示する文字列
    /// - Parameter image: セクションに表示するシステム画像
    /// - parameter editButtontitle: 編集ボタンに表示するタイトル、ボタンを使用しない場合nil
    /// - Parameter delegate: TableViewDelegateを継承したクラス
    func setup(header: String, image: String, editButtontitle: String? = nil, delegate: TableHeaderViewDelegate? = nil) {
        changeEditButton.layer.cornerRadius = 15
        changeEditButton.layer.masksToBounds = true
        // 前のデータが再利用されないようボタンを初期化
        changeEditButton.setTitle("", for: .normal)
        
        headerLabel.text = header
        headerImageView.image = UIImage(systemName: image)
        //　編集ボタンTitle
        if let title = editButtontitle {
            changeEditButton.isHidden = false
            changeEditButton.setTitle(title, for: .normal)
        } else {
            changeEditButton.isHidden = true
        }
        // 編集ボタンが押された際の処理
        self.delegate = delegate
        changeEditButton.addTarget(self, action: #selector(isEditingChange), for: .touchUpInside)
    }
    
    /// sort・deleteボタンが押された際に発火
    @objc private func isEditingChange() {
        delegate?.isEditingChange(editButton: changeEditButton)
    }
    
    
    

}
