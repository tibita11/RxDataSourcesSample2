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
            // section0の場合
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        } else {
            cell.accessoryType = .none
            // section0以外はタップ不可
            cell.selectionStyle = .none
        }
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        cell.contentConfiguration = config
        return cell
    }, canEditRowAtIndexPath: { (dataSource, indexPath) in
        if indexPath.section == 1 {
            // section1の場合のみ編集モード可
            return true
        } else {
            return false
        }
    })
    
    /// headerの編集ボタンTitleをisEditingから判別して返す
    var editButtonTitle: String {
        if tableView.isEditing {
            // 編集中の場合 "Done"
            return EditButtonTitle.done.rawValue
        } else {
            // 編集中でない場合 "Sort・Delete"
            return EditButtonTitle.edit.rawValue
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel()
        setupTableView()
        setupNavigationBar()
        setupInput()

        if UserDefaults.standard.data(forKey: Const.SectionModelKey) == nil {
            // 初回起動の場合は初期値を設定
            viewModel.setupInitialData()
        } else {
            viewModel.getData()
        }

    }
    
    
    // MARK: - Action
    
    /// 初期設定
    private func setupInput() {
        let input = MainViewModelInput(itemDeleted: tableView.rx.itemDeleted.asObservable(), itemMoved: tableView.rx.itemMoved.asObservable())
        viewModel.setup(input: input)
    }
    
    /// TableViewに関する初期設定
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // カスタマイズheaderの登録
        tableView.register(UINib(nibName: "TableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableHeaderView")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        // TableViewの自動更新
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        // セルがタップされた際の遷移処理
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let item = self?.dataSource[indexPath] else { return }
                self?.tableView.deselectRow(at: indexPath, animated: true)
                
                switch item.title {
                case "About this app":
                    // 次の画面に遷移
                    self?.navigationController?.pushViewController(AppDescriptionViewController(), animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// NavigationBarに関する初期設定
    private func setupNavigationBar() {
        let addButtonItem = UIBarButtonItem(title: "Add New iPhone", style: .plain, target: self, action: #selector(goToRegisterScreen))
        navigationItem.rightBarButtonItem = addButtonItem
        
    }
    
    /// iPhone追加ボタンを押すと発火する
    @objc func goToRegisterScreen() {
        // 登録画面に遷移
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }



}


// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // カスタマイズheaderの設定
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeaderView")
        if let headerView = view as? TableHeaderView {
            if section == 0 {
                // section0の場合、並び替え・削除ボタンは非表示
                headerView.setup(header: dataSource[section].header, image: dataSource[section].image)
            } else {
                headerView.setup(header: dataSource[section].header, image: dataSource[section].image, editButtontitle: editButtonTitle, delegate: self)
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


// MARK: - TableHeaderViewDelegate

extension MainViewController: TableHeaderViewDelegate {
    func isEditingChange(editButton: UIButton) {
        // 編集状態を変更
        tableView.isEditing = !tableView.isEditing
        // 編集ボタンのタイトルを変更
        editButton.setTitle(editButtonTitle, for: .normal)
    }
    
    
}
