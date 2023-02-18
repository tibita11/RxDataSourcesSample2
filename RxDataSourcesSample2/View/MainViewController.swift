//
//  MainViewController.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MainViewModel!
    
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: {
        (dataSource, tableview, indexPath, item) in
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            // section1の場合
            cell.accessoryType = .disclosureIndicator
        } else {
            // section1以外はタップ不可
            cell.isUserInteractionEnabled = false
        }
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        // タップ不可の際に色が変わるため指定する
        config.textProperties.color = .black
        cell.contentConfiguration = config
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel()
        setupTabelView()

    }
    
    
    private func setupTabelView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // カスタマイズheaderの登録
        tableView.register(UINib(nibName: "TableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableHeaderView")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        // TableViewの自動更新
        viewModel.output?.itemsObserver
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }



}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // カスタマイズheaderの設定
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeaderView")
        if let headerView = view as? TableHeaderView {
            if section == 0 {
                // section1の場合、並び替え・削除ボタンは非表示
                headerView.setup(header: dataSource[section].header, image: dataSource[section].image, isEdit: false)
            } else {
                headerView.setup(header: dataSource[section].header, image: dataSource[section].image, isEdit: true)
            }
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // 下部に余白
        return 100
    }

}
