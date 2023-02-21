//
//  TableHeaderView.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import UIKit

protocol TableHeaderViewDelegate {
    func isEditingChange()
}

class TableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var changeEditButton: UIButton!
    
    var delegate: TableHeaderViewDelegate?
    
    /// 初期設定
    /// - Parameter header: セクションに表示する文字列
    /// - Parameter image: セクションに表示するシステム画像
    /// - parameter isEdit: sort・deleteボタンを表示する場合true
    /// - Parameter delegate: TableViewDelegateを継承したクラス
    func setup(header: String, image: String, isEdit: Bool, delegate: TableHeaderViewDelegate? = nil) {
        changeEditButton.layer.cornerRadius = 15
        changeEditButton.layer.masksToBounds = true
        
        headerLabel.text = header
        headerImageView.image = UIImage(systemName: image)
        changeEditButton.isHidden = !isEdit
        // sort・delegateボタンが押された際の処理
        self.delegate = delegate
        changeEditButton.addTarget(self, action: #selector(isEditingChange), for: .touchUpInside)
    }
    
    /// sort・deleteボタンが押された際に発火
    @objc private func isEditingChange() {
        delegate?.isEditingChange()
    }
    
    
    

}
