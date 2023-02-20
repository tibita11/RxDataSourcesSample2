//
//  RegisterViewController.swift
//  RxDataSourcesSample2
//
//  Created by 鈴木楓香 on 2023/02/18.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var textView: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    /// PickerViewに表示する内容
    let iPhoneModels: [String] = ["iPhone 8", "iPhone 8 Plus", "iPhone 11", "iPhone 11 Pro", "iPhone 11 Pro Max", "iPhone 12", "iPhone 12 Pro", "iPhone 12 Pro Max", "iPhone12 mini", "iPhone 13", "iPhone 13 Pro", "iPhone 13 Pro Max", "iPhone13 mini", "iPhone 14", "iPhone 14 Plus", "iPhone 14 Pro", "iPhone 14 Pro Max", "iPhone SE", "iPod touch"]
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
    }
    
    
    // MARK: - Action
    
    /// PickerViewの初期設定
    private func setupPickerView() {
        // 表示するPickerView
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        textView.inputView = pickerView
        // 表示するToolBar
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100.0, height: 45.0)))
        let space = UIBarButtonItem(systemItem: .flexibleSpace)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearAction))
        toolBar.items = [clearButton, space, doneButton]
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
    }
    
    /// PickerViewのDoneボタンを押した場合に発火する
    @objc private func doneAction() {
        textView.resignFirstResponder()
    }
    
    /// PickerViewのClearボタンを押した場合に発火する
    @objc private func clearAction() {
        // TextViewを空にする
        textView.resignFirstResponder()
        textView.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }



}


// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return iPhoneModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return iPhoneModels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textView.text = iPhoneModels[row]
    }
    
    
}
